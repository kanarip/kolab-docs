=========================================
OpenSUSE Build Service for Kolab Packages
=========================================

*   Web Address: https://obs.kolabsys.com
*   API Web Address: https://obs.kolabsys.com:444

Setup and Structure
===================

#.  Create a Logical Volume to hold the virtual machine::

    lvcreate -L 20G -n guest_obs01 vg_kvm02

#.  Refresh the storage pool::

    virsh pool-refresh vg_kvm02

#.  Download the raw server appliance image, and xzcat it in to the logical
    volume::

    xzcat /path/to/raw/xz/image > /dev/vg_kvm02/guest_obs01

#.  Start the VM
#.  Load the correct certificates
#.  Set the hostname, IP address, gateway and DNS servers
#.  Change passwords

Adding the Distributions
========================

Add CentOS 6
------------

#.  Create the project:

    .. parsed-literal::

        osc meta prj CentOS:6 -F - << EOF
        <project name="CentOS:6">
            <title>CentOS 6 (Santiago)</title>
            <description>CentOS 6 (Santiago)</description>
            <person userid="Admin" role="maintainer"/>
            <person userid="Admin" role="bugowner"/>
            <build>
                <disable/>
            </build>
            <publish>
                <disable/>
            </publish>
            <repository name="updates">
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="epel">
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="release">
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
        </project>
        EOF

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        :command:`osc -A https://api.opensuse.org meta prjconf CentOS:CentOS-6` | \\
            :command:`osc meta prjconf CentOS:6 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        :command:`mysql --password=opensuse api_production -e` \\
            "INSERT INTO distributions (vendor, version, name, project, reponame, \\
            repository) VALUES ('CentOS', '6', 'CentOS 6', 'CentOS:6', \\
            'CentOS_6', 'standard');"

.. NOTE::

    The opensuse configuration does not have a %{rhel} macro

Add Debian 6.0
--------------

.. parsed-literal::

    osc meta prj Debian:6.0 -F - << EOF
    <project name="Debian:6.0">
    <title>Debian 6.0 (Squeeze)</title>
    <description>Debian 6.0 (Squeeze)</description>
    <person userid="Admin" role="maintainer"/>
    <person userid="Admin" role="bugowner"/>
        <build>
            <disable/>
        </build>
        <publish>
            <disable/>
        </publish>
    <repository name="main">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    </project>
    EOF

    osc -A https://api.opensuse.org meta prjconf Debian:6.0 | \
        osc meta prjconf Debian:6.0 -F -

    mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('Debian', '6', 'Debian 6.0', 'Debian:6.0', 'Debian_6.0', 'standard');"

Add Debian 7.0
--------------

.. parsed-literal::

    osc meta prj Debian:7.0 -F - << EOF
    <project name="Debian:7.0">
    <title>Debian 7.0 (Wheezy)</title>
    <description>Debian 7.0 (Wheezy)</description>
    <person userid="Admin" role="maintainer"/>
    <person userid="Admin" role="bugowner"/>
        <build>
            <disable/>
        </build>
        <publish>
            <disable/>
        </publish>
    <repository name="main">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    </project>
    EOF

    osc -A https://api.opensuse.org meta prjconf Debian:7.0 | \
        osc meta prjconf Debian:7.0 -F -

    mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('Debian', '7', 'Debian 7.0', 'Debian:7.0', 'Debian_7.0', 'standard');"

Add Fedora 17
-------------

osc meta prj Fedora:17 -F - << EOF
<project name="Fedora:17">
<title>Fedora 17 (Beefy Miracle)</title>
<description>Fedora 17 (Beefy Miracle)</description>
<person userid="Admin" role="maintainer"/>
<person userid="Admin" role="bugowner"/>
<build>
<disable/>
</build>
<publish>
<disable/>
</publish>
    <repository name="updates">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    <repository name="release">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
</project>
EOF
osc -A https://api.opensuse.org meta prjconf Fedora:17 | \
osc meta prjconf Fedora:17 -F -

mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('Fedora', '17', 'Fedora 17', 'Fedora:17', 'Fedora_17', 'standard');"

Add Fedora 18
-------------

osc meta prj Fedora:18 -F - << EOF
<project name="Fedora:18">
<title>Fedora 18 (Spherical Cow)</title>
<description>Fedora 18 (Spherical Cow)</description>
<person userid="Admin" role="maintainer"/>
<person userid="Admin" role="bugowner"/>
<build>
<disable/>
</build>
<publish>
<disable/>
</publish>
    <repository name="updates">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    <repository name="release">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
</project>
EOF
osc -A https://api.opensuse.org meta prjconf Fedora:18 | \
osc meta prjconf Fedora:18 -F -

mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('Fedora', '18', 'Fedora 18', 'Fedora:18', 'Fedora_18', 'standard');"

.. NOTE::

    The opensuse configuration does not have a %{opensuse_bs} macro

Add Fedora 19
-------------

osc meta prj Fedora:19 -F - << EOF
<project name="Fedora:19">
<title>Fedora 19 (Schroedinger's Cat)</title>
<description>Fedora 19 (Schroedinger's Cat)</description>
<person userid="Admin" role="maintainer"/>
<person userid="Admin" role="bugowner"/>
<build>
<disable/>
</build>
<publish>
<disable/>
</publish>
    <repository name="updates">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    <repository name="release">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
</project>
EOF
osc -A https://api.opensuse.org meta prjconf Fedora:19 | \
osc meta prjconf Fedora:19 -F -

mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('Fedora', '19', 'Fedora 19', 'Fedora:19', 'Fedora_19', 'standard');"

.. NOTE::

    The opensuse configuration does not have a %{opensuse_bs} macro

Add openSUSE 12.1
-----------------

Add openSUSE 12.2
-----------------

Add openSUSE 12.3
-----------------

Add Ubuntu 12.04
----------------

osc meta prj Ubuntu:12.04 -F - << EOF
<project name="Ubuntu:12.04">
  <title>Ubuntu 12.04 (Precise)</title>
  <description>Ubuntu 12.04 (Precise)</description>
  <person userid="Admin" role="maintainer"/>
  <person userid="Admin" role="bugowner"/>
    <build>
        <disable/>
    </build>
    <publish>
        <disable/>
    </publish>
    <repository name="universe">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    <repository name="main">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
</project>
EOF

osc -A https://api.opensuse.org meta prjconf Ubuntu:12.04 | \
    osc meta prjconf Ubuntu:12.04 -F -

mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('Ubuntu', '12.04', 'Ubuntu 12.04', 'Ubuntu:12.04', 'Ubuntu_12.04', 'standard');"

Add Ubuntu 12.10
----------------

osc meta prj Ubuntu:12.10 -F - << EOF
<project name="Ubuntu:12.10">
  <title>Ubuntu 12.10 (Quantal)</title>
  <description>Ubuntu 12.10 (Quantal)</description>
  <person userid="Admin" role="maintainer"/>
  <person userid="Admin" role="bugowner"/>
    <build>
        <disable/>
    </build>
    <publish>
        <disable/>
    </publish>
    <repository name="universe">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    <repository name="main">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
</project>
EOF

osc -A https://api.opensuse.org meta prjconf Ubuntu:12.10 | \
    osc meta prjconf Ubuntu:12.10 -F -

mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('Ubuntu', '12.10', 'Ubuntu 12.10', 'Ubuntu:12.10', 'Ubuntu_12.10', 'standard');"

Add Ubuntu 13.04
----------------

osc meta prj Ubuntu:13.04 -F - << EOF
<project name="Ubuntu:13.04">
  <title>Ubuntu 13.04 (Raring)</title>
  <description>Ubuntu 13.04 (Raring)</description>
  <person userid="Admin" role="maintainer"/>
  <person userid="Admin" role="bugowner"/>
    <build>
        <disable/>
    </build>
    <publish>
        <disable/>
    </publish>
    <repository name="universe">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    <repository name="main">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
</project>
EOF

osc -A https://api.opensuse.org meta prjconf Ubuntu:13.04 | \
    osc meta prjconf Ubuntu:13.04 -F -

mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('Ubuntu', '13.04', 'Ubuntu 13.04', 'Ubuntu:13.04', 'Ubuntu_13.04', 'standard');"

Add Ubuntu 13.10
----------------

osc meta prj Ubuntu:13.10 -F - << EOF
<project name="Ubuntu:13.10">
  <title>Ubuntu 13.10 (Saucy)</title>
  <description>Ubuntu 13.10 (Saucy)</description>
  <person userid="Admin" role="maintainer"/>
  <person userid="Admin" role="bugowner"/>
    <build>
        <disable/>
    </build>
    <publish>
        <disable/>
    </publish>
    <repository name="universe">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    <repository name="main">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
</project>
EOF

osc -A https://api.opensuse.org meta prjconf Ubuntu:13.10 | \
    osc meta prjconf Ubuntu:13.10 -F -

mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('Ubuntu', '13.10', 'Ubuntu 13.10', 'Ubuntu:13.10', 'Ubuntu_13.10', 'standard');"

Add UCS 3.0
-----------

osc meta prj UCS:3.0 -F - << EOF
<project name="UCS:3.0">
    <title>UCS 3.0</title>
    <description>UCS 3.0</description>
    <person userid="Admin" role="maintainer"/>
    <person userid="Admin" role="bugowner"/>
    <build>
        <disable/>
    </build>
    <publish>
        <disable/>
    </publish>
    <repository name="maintained">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    <repository name="unmaintained">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
</project>
EOF

osc -A https://api.opensuse.org meta prjconf Debian:6.0 | \
    osc meta prjconf UCS:3.0 -F -

mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('UCS', '3.0', 'UCS 3.0', 'UCS:3.0', 'UCS_3.0', 'standard');"

Add UCS 3.1
-----------

osc meta prj UCS:3.1 -F - << EOF
<project name="UCS:3.1">
    <title>UCS 3.1</title>
    <description>UCS 3.1</description>
    <person userid="Admin" role="maintainer"/>
    <person userid="Admin" role="bugowner"/>
    <build>
        <disable/>
    </build>
    <publish>
        <disable/>
    </publish>
    <repository name="maintained">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
    <repository name="unmaintained">
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>
</project>
EOF

osc -A https://api.opensuse.org meta prjconf Debian:6.0 | \
    osc meta prjconf UCS:3.1 -F -

mysql --password=opensuse api_production -e "INSERT INTO distributions (vendor, version, name, project, reponame, repository) VALUES ('UCS', '3.1', 'UCS 3.1', 'UCS:3.1', 'UCS_3.1', 'standard');"

Adding the Projects
===================

Adding Kolab
------------

This is the latest and greatest Kolab.

.. parsed-literal::

osc meta prj Kolab:Development -F - << EOF
<project name="Kolab:Development">
    <title>Kolab:Development</title>
    <description></description>
    <person userid="Admin" role="maintainer"/>
    <person userid="Admin" role="bugowner"/>
    <repository name="CentOS_6">
        <path project="CentOS:6" repository="epel"/>
        <path project="CentOS:6" repository="updates"/>
        <path project="CentOS:6" repository="release"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

    <repository name="Debian_6.0">
        <path project="Debian:6.0" repository="main"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

    <repository name="Debian_7.0">
        <path project="Debian:7.0" repository="main"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

    <repository name="Fedora_18">
        <path project="Fedora:18" repository="updates"/>
        <path project="Fedora:18" repository="release"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

    <repository name="Fedora_19">
        <path project="Fedora:19" repository="updates"/>
        <path project="Fedora:19" repository="release"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

    <repository name="Ubuntu_12.04">
        <path project="Ubuntu:12.04" repository="universe"/>
        <path project="Ubuntu:12.04" repository="main"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

    <repository name="Ubuntu_12.10">
        <path project="Ubuntu:12.10" repository="universe"/>
        <path project="Ubuntu:12.10" repository="main"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

    <repository name="Ubuntu_13.04">
        <path project="Ubuntu:13.04" repository="universe"/>
        <path project="Ubuntu:13.04" repository="main"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

    <repository name="Ubuntu_13.10">
        <path project="Ubuntu:13.10" repository="universe"/>
        <path project="Ubuntu:13.10" repository="main"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

    <repository name="UCS_3.0">
        <path project="UCS:3.0" repository="maintained"/>
        <path project="UCS:3.0" repository="unmaintained"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

    <repository name="UCS_3.1">
        <path project="UCS:3.1" repository="maintained"/>
        <path project="UCS:3.1" repository="unmaintained"/>
        <path project="UCS:3.0" repository="maintained"/>
        <path project="UCS:3.0" repository="unmaintained"/>
        <arch>i586</arch>
        <arch>x86_64</arch>
    </repository>

</project>
EOF

Forking off Kolab 3.0
---------------------

Suggested on http://opensuse.14.x6.nabble.com/the-best-way-to-clone-entire-project-td4990396.html:

    osc api -X POST /source/NEW_PROJECT?cmd=copy&oproject=OLD_PROJECT&...

    "see api.txt for more details"

Packages
========

xsd
---
osc meta pkg Kolab:Development xsd -F - << EOF
<package name="xsd">
    <title>xsd</title>
    <description>Needed on Debian 6.0 (Squeeze) based distributions for libkolabxml</description>
    <url>http://www.codesynthesis.com/projects/xsd</url>
    <build>
        <disable repository="CentOS_6"/>
        <disable repository="Debian_7.0"/>
        <disable repository="Fedora_17"/>
        <disable repository="Fedora_18"/>
        <disable repository="Fedora_19"/>
    </build>
</package>
EOF

libkolabxml
-----------

osc meta pkg Kolab:Development libkolabxml -F - << EOF
<package name="libkolabxml">
    <title>libkolabxml</title>
    <description></description>

    <url>http://kolab.org/about/libkolabxml</url>
</package>
EOF

libcalendaring
--------------

osc meta pkg Kolab:Development libcalendaring -F - << EOF
<package name="libcalendaring">
    <title>libcalendaring</title>
    <description>Frankenstein module to avoid dependencies on most of KDE</description>
    <url>http://kolab.org/about/libcalendaring</url>
</package>
EOF

libkolab
--------

osc meta pkg Kolab:Development libkolab -F - << EOF
<package name="libkolab">
    <title>libkolab</title>
    <description></description>
    <url>http://kolab.org/about/libkolab</url>
</package>
EOF



osc meta pkg Kolab:Development cyrus-imapd -F - << EOF
<package name="cyrus-imapd">
    <title>cyrus-imapd</title>
    <description></description>
    <url>http://kolab.org/about/cyrus-imapd</url>
</package>
EOF

osc meta pkg Kolab:Development kolab-freebusy -F - << EOF
<package name="kolab-freebusy">
    <title>kolab-freebusy</title>
    <description></description>
    <url>http://kolab.org/about/kolab-freebusy</url>
</package>
EOF

osc meta pkg Kolab:Development kolab-syncroton -F - << EOF
<package name="kolab-syncroton">
    <title>kolab-syncroton</title>
    <description></description>
    <url>http://kolab.org/about/kolab-syncroton</url>
</package>
EOF

osc meta pkg Kolab:Development kolab-utils -F - << EOF
<package name="kolab-utils">
    <title>kolab-utils</title>
    <description></description>
    <url>http://kolab.org/about/kolab-utils</url>
</package>
EOF

osc meta pkg Kolab:Development pykolab -F - << EOF
<package name="pykolab">
    <title>pykolab</title>
    <description></description>
    <url>http://kolab.org/about/pykolab</url>
</package>
EOF

osc meta pkg Kolab:Development python-icalendar -F - << EOF
<package name="python-icalendar">
    <title>python-icalendar</title>
    <description></description>
    <url>http://kolab.org/about/python-icalendar</url>
    <build>
        <disable repository="Fedora_18"/>
        <disable repository="Fedora_19"/>
    </build>
</package>
EOF

osc meta pkg Kolab:Development python-pyasn1 -F - << EOF
<package name="python-pyasn1">
    <title>python-pyasn1</title>
    <description></description>
    <url>http://kolab.org/about/python-pyasn1</url>
    <build>
        <disable repository="Debian_6.0"/>
        <disable repository="Debian_7.0"/>
        <disable repository="Fedora_18"/>
        <disable repository="Fedora_19"/>
        <disable repository="Ubuntu_12.04"/>
        <disable repository="Ubuntu_12.10"/>
        <disable repository="Ubuntu_13.04"/>
        <disable repository="Ubuntu_13.10"/>
        <disable repository="UCS_3.0"/>
        <disable repository="UCS_3.1"/>
    </build>
</package>
EOF

osc meta pkg Kolab:Development roundcubemail -F - << EOF
<package name="roundcubemail">
    <title>roundcubemail</title>
    <description></description>
    <url>http://kolab.org/about/roundcubemail</url>
</package>
EOF

osc meta pkg Kolab:Development roundcubemail-plugins-kolab -F - << EOF
<package name="roundcubemail-plugins-kolab">
    <title>roundcubemail-plugins-kolab</title>
    <description></description>
    <url>http://kolab.org/about/roundcubemail-plugins-kolab</url>
</package>
EOF

osc meta pkg Kolab:Development roundcubemail-plugin-contextmenu -F - << EOF
<package name="roundcubemail-plugin-contextmenu">
    <title>roundcubemail-plugin-contextmenu</title>
    <description></description>
    <url>http://kolab.org/about/roundcubemail-plugin-contextmenu</url>
</package>
EOF

osc meta pkg Kolab:Development roundcubemail-plugin-composeaddressbook -F - << EOF
<package name="roundcubemail-plugin-composeaddressbook">
    <title>roundcubemail-plugin-composeaddressbook</title>
    <description></description>
    <url>http://kolab.org/about/roundcubemail-plugin-composeaddressbook</url>
</package>
EOF

osc meta pkg Kolab:Development roundcubemail-plugin-dblog -F - << EOF
<package name="roundcubemail-plugin-dblog">
    <title>roundcubemail-plugin-dblog</title>
    <description></description>
    <url>http://kolab.org/about/roundcubemail-plugin-dblog</url>
</package>
EOF

osc meta pkg Kolab:Development roundcubemail-plugin-terms -F - << EOF
<package name="roundcubemail-plugin-terms">
    <title>roundcubemail-plugin-terms</title>
    <description></description>
    <url>http://kolab.org/about/roundcubemail-plugin-terms</url>
</package>
EOF

osc meta pkg Kolab:Development roundcubemail-plugin-threading_as_default -F - << EOF
<package name="roundcubemail-plugin-threading_as_default">
    <title>roundcubemail-plugin-threading_as_default</title>
    <description></description>
    <url>http://kolab.org/about/roundcubemail-plugin-threading_as_default</url>
</package>
EOF


