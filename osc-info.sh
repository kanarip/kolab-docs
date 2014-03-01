#!/bin/bash

mkdir -p osc-cache/

rm -f osc-info.stop

# List the projects and cache them locally.
if [ ! -f "osc_cache/obs_projects.list" ]; then
    osc ls | grep -vE "^(home|deleted)" > osc-cache/obs_projects.list
fi

obs_projects=$(cat osc-cache/obs_projects.list)

# Placeholder for Kolab projects
declare -a kolab_projects
# Placeholder for target platform repositories
declare -a target_repositories

# First, attempt to discover the maximum width of:
#
# - Either the table column header or any project names, and
# - Either the table column header or any target platform name.

project_column_width=0
target_column_width=0
version_column_width=36

for project in ${obs_projects}; do
    if [ -z "$(echo ${project} | grep ^Kolab)" ]; then
        target_repositories[${#target_repositories[@]}]=$(echo ${project} | sed -e 's/:/_/g')
        # Determine if the name of this project is longer than any other project
        # name we've seen before
        if [ $(echo -n "$(echo ${project} | sed -e 's/:/_/g')" | wc -c) -gt ${target_column_width} ]; then
            target_column_width=$(echo -n "$(echo ${project} | sed -e 's/:/_/g')" | wc -c)
        fi
    else
        kolab_projects[${#kolab_projects[@]}]="${project}"

        # Determine if the name of this project is longer than any other project
        # name we've seen before
        if [ $(echo -n "${project}" | wc -c) -gt ${project_column_width} ]; then
            project_column_width=$(echo -n "${project}" | wc -c)
        fi
    fi
done

# Capture all names being shorter than the header.
if [ $(echo -n "Kolab Version(s)" | wc -c) -gt ${project_column_width} ]; then
    project_column_width=$(echo -n "Kolab Version(s)" | wc -c)
fi

# Capture all names being shorter than the header.
if [ $(echo -n "Platform(s)" | wc -c) -gt ${target_column_width} ]; then
    target_column_width=$(echo -n "Platform(s)" | wc -c)
fi

# List all packages in all projects
x=0
while [ ${x} -lt ${#kolab_projects[@]} ]; do
    project=${kolab_projects[${x}]}

    if [ ! -f "osc-cache/${project}_packages.list" ]; then
        osc ls ${project} > osc-cache/${project}_packages.list
    fi

    let x++
done

# To initialize the tables, first iterate over all unique packages (across all
# projects).

packages=$(cat osc-cache/*_packages.list | sort -u)

for package in ${packages}; do
    target="source/developer-guide/packaging/obs-for-kolab/packages/${package}.txt"

    if [ -f "${target}" ]; then
        rm -rf ${target}
    fi

    echo ".. table:: Version Table for ${package}" >> ${target}
    echo "" >> ${target}
    printf "%s" "    +-" >> ${target}
    printf "%*.*s" 0 ${project_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
    printf "%s" "-+-" >> ${target}
    printf "%*.*s" 0 ${target_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
    printf "%s" "-+-" >> ${target}
    printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
    printf "%s" "-+" >> ${target}
    echo "" >> ${target}

    printf "%s" "    | " >> ${target}
    printf "%-${project_column_width}s" "Kolab Version(s)" >> ${target}
    printf "%s" " | " >> ${target}
    printf "%-${target_column_width}s" "Platform(s)" >> ${target}
    printf "%s" " | " >> ${target}
    printf "%-${version_column_width}s" "Version" >> ${target}
    printf "%s" " |" >> ${target}
    echo "" >> ${target}

    printf "%s" "    +=" >> ${target}
    printf "%*.*s" 0 ${project_column_width} $(printf '%0.1s' "="{1..60}) >> ${target}
    printf "%s" "=+=" >> ${target}
    printf "%*.*s" 0 ${target_column_width} $(printf '%0.1s' "="{1..60}) >> ${target}
    printf "%s" "=+=" >> ${target}
    printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "="{1..60}) >> ${target}
    printf "%s" "=+" >> ${target}
    echo "" >> ${target}

done

# Loop through our projects,
# then through the packages for that project,
# then see what the packages are configured to build for,
# then see where the package originates from and what version is included, or
# we include.

x=0
while [ ${x} -lt ${#kolab_projects[@]} ]; do
    project=${kolab_projects[${x}]}
    packages=$(cat osc-cache/${project}_packages.list)

    echo -n "${project}: "

    for package in ${packages}; do
        if [ -f "osc-info.stop" ]; then
            exit 1
        fi

        enabled_repositories=""
        target="source/developer-guide/packaging/obs-for-kolab/packages/${package}.txt"

        if [ ! -f "osc-cache/${project}_${package}.meta" ]; then
            osc meta pkg ${project} ${package} > osc-cache/${project}_${package}.meta
        fi

        disabled_default=$(awk '/<build>/,/<\/build>/' osc-cache/${project}_${package}.meta | grep -E "^\s*<disable/>$")

        if [ -z "${disabled_default}" ]; then
            disabled_repositories=$(
                    awk '/<build>/,/<\/build>/' osc-cache/${project}_${package}.meta | \
                    grep -E "^\s*<disable repository.*" | \
                    sed -r -e 's/\s*<disable repository="(.*)"\/>/\1/g' | \
                    sort -u
                )

            y=0
            while [ ${y} -lt ${#target_repositories[@]} ]; do
                repo_disabled=0
                for disabled_repository in ${disabled_repositories}; do
                    if [ "${target_repositories[${y}]}" == "${disabled_repository}" ]; then
                        repo_disabled=1
                    fi
                done

                if [ ${repo_disabled} -eq 0 ]; then
                    enabled_repositories="${enabled_repositories} ${target_repositories[${y}]}"
                fi

                let y++
            done
        else
            enabled_repositories=$(
                    awk '/<build>/,/<\/build>/' osc-cache/${project}_${package}.meta | \
                    grep -E "^\s*<enable repository.*" | \
                    sed -r -e 's/\s*<enable repository="(.*)"\/>/\1/g' | \
                    sort -u
                )
        fi

        if [ ! -z "${enabled_repositories}" ]; then
            printf "    | %-${project_column_width}s |" ${project} >> ${target}

            have_had_first=0
            for enabled_repository in ${enabled_repositories}; do
                # Here be version magic.
                # osc buildinfo Kolab:3.1 389-admin Debian_7.0 x86_64 | awk '/<versrel>/,/<\/versrel>/' | sed -e 's/\s*<versrel>//g' -e 's/<\/versrel>//g'
                if [ ! -s "osc-cache/${project}_${enabled_repository}_${package}.version" ]; then
                    osc buildinfo ${project} ${package} ${enabled_repository} x86_64 2>/dev/null | awk '/<versrel>/,/<\/versrel>/' | sed -e 's/\s*<versrel>//g' -e 's/<\/versrel>//g' > osc-cache/${project}_${enabled_repository}_${package}.version
                fi

                version=$(cat osc-cache/${project}_${enabled_repository}_${package}.version)
                if [ -z "${version}" ]; then
                    version="N/A"
                fi

                if [ ${have_had_first} -eq 0 ]; then
                    printf " %-${target_column_width}s | %-${version_column_width}s |" ${enabled_repository} ${version} >> ${target}
                    echo "" >> ${target}
                    printf "%s" "    +-" >> ${target}
                    printf "%*.*s" 0 ${project_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+-" >> ${target}
                    printf "%*.*s" 0 ${target_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+-" >> ${target}
                    printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+" >> ${target}
                    echo "" >> ${target}
                    have_had_first=1
                else
                    printf "    | %-${project_column_width}s |" >> ${target}
                    printf " %-${target_column_width}s | %-${version_column_width}s |" ${enabled_repository} ${version} >> ${target}
                    echo "" >> ${target}
                    printf "%s" "    +-" >> ${target}
                    printf "%*.*s" 0 ${project_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+-" >> ${target}
                    printf "%*.*s" 0 ${target_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+-" >> ${target}
                    printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+" >> ${target}
                    echo "" >> ${target}
                fi
            done
        fi

        echo -n "."

    done
    echo ""
    let x++
done
