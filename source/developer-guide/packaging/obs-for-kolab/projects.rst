========
Projects
========

Kolab Development
=================

This is the latest and greatest Kolab.

.. parsed-literal::

    # :command:`osc meta prj Kolab:Development -F -` << EOF
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
        <repository name="openSUSE_12.1">
            <path project="openSUSE:12.1" repository="updates"/>
            <path project="openSUSE:12.1" repository="release"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="openSUSE_12.2">
            <path project="openSUSE:12.2" repository="updates"/>
            <path project="openSUSE:12.2" repository="release"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="openSUSE_12.3">
            <path project="openSUSE:12.3" repository="updates"/>
            <path project="openSUSE:12.3" repository="release"/>
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

#.  Set the **Release**:

    .. parsed-literal::

        # :command:`osc meta prjconf Kolab:Development -F -` << EOF
        Release: <CI_CNT>%%{?dist}.kolab_3.2
        EOF

Forking off Kolab 3.0
=====================

#.  Copy all of Kolab:Development to a new project Kolab:3.0:

    .. parsed-literal::

        # :command:`osc api -X POST \\
            /source/Kolab:3.0?cmd=copy&oproject=Kolab:Development&makeolder=1&withhistory=1&withbinaries=1`

#.  Set the corresponding attributes on the new Kolab:3.0 project:

    .. parsed-literal::

        # :command:`osc meta attribute Kolab:3.0 \\
            --attribute "OBS:RejectRequests"` \\
            --set "Please submit to Kolab:Development and/or Kolab:3.0:Updates"
        # :command:`osc meta attribute Kolab:3.0 \\
            --attribute "OBS:UpdateProject" \\
            --set "Kolab:3.0:Updates"`

#.  Lock the base maintenance repository:

    .. parsed-literal::

        # :command:`osc meta prj Kolab:3.0 > Kolab:3.0.prj`

    #.  Check the contents of ``Kolab:3.0.prj``:

        .. parsed-literal::

            <project name="Kolab:3.0">
                <title>Kolab 3.0</title>
                <description>Kolab 3.0 Community Edition</description>
                <person userid="Admin" role="maintainer"/>
                <repository name="CentOS_6">
                    <path project="Kolab:3.0" repository="CentOS_6"/>
                    <arch>i586</arch>
                    <arch>x86_64</arch>
                </repository>
                (... snip ...)
            </project>
            EOF

    #.  Add the lock:

        .. parsed-literal::

            (... snip ...)
            <lock>
                <enable/>
            </lock>
            (... snip ...)

        .. WARNING::

            You can only take this step after the initial rebuilds are
            completed.

    #. Push it back:

        .. parsed-literal::

            # :command:`osc meta prj Kolab:3.0 -F -` < Kolab\:3.0.prj

#.  Create the Kolab:3.0:Updates project as a subproject:

    .. parsed-literal::

        # :command:`osc meta prj Kolab:3.0:Updates -F -` << EOF
        <project name="Kolab:3.0:Updates" kind="maintenance_release">
            <title>Updates for Kolab 3.0</title>
            <description></description>
            <link project="Kolab:3.0"/>
            <person userid="Admin" role="maintainer"/>
            <person userid="Admin" role="bugowner"/>
            <build>
                <disable/>
            </build>
            <publish>
                <disable/>
            </publish>
            <debuginfo>
                <enable/>
            </debuginfo>
            <repository name="CentOS_6">
                <path project="Kolab:3.0" repository="CentOS_6"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Debian_6.0">
                <path project="Kolab:3.0" repository="Debian_6.0"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Debian_7.0">
                <path project="Kolab:3.0" repository="Debian_7.0"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Fedora_18">
                <path project="Kolab:3.0" repository="Fedora_18"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Fedora_19">
                <path project="Kolab:3.0" repository="Fedora_19"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="openSUSE_12.1">
                <path project="Kolab:3.0" repository="openSUSE_12.1"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="openSUSE_12.2">
                <path project="Kolab:3.0" repository="openSUSE_12.2"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="openSUSE_12.3">
                <path project="Kolab:3.0" repository="openSUSE_12.3"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Ubuntu_12.04">
                <path project="Kolab:3.0" repository="Ubuntu_12.04"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Ubuntu_12.10">
                <path project="Kolab:3.0" repository="Ubuntu_12.10"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Ubuntu_13.04">
                <path project="Kolab:3.0" repository="Ubuntu_13.04"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Ubuntu_13.10">
                <path project="Kolab:3.0" repository="Ubuntu_13.10"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="UCS_3.0">
                <path project="Kolab:3.0" repository="UCS_3.0"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="UCS_3.1">
                <path project="Kolab:3.0" repository="UCS_3.1"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
        </project>
        EOF

#.  Set the maintenance attributes on Kolab:3.0:Updates

    .. parsed-literal::

        # :command:`osc meta attribute Kolab:3.0:Updates \\
            --attribute "OBS:Maintained" \\
            --set ""`
        # :command:`osc meta attribute Kolab:3.0:Updates \\
            --attribute "OBS:BranchTarget" \\
            --set ""`

#.  Set the **Release**:

    .. parsed-literal::

        # :command:`osc meta prjconf Kolab:3.0 -F -` << EOF
        Release: <CI_CNT>%%{?dist}.kolab_3.0
        EOF

Forking off Kolab 3.1
=====================

#.  Copy all of Kolab:Development to a new project Kolab:3.1:

    .. parsed-literal::

        # :command:`osc api -X POST \\
            /source/Kolab:3.1?cmd=copy&oproject=Kolab:Development&makeolder=1&withhistory=1&withbinaries=1`

#.  Set the corresponding attributes on the new Kolab:3.1 project:

    .. parsed-literal::

        # :command:`osc meta attribute Kolab:3.1 \\
            --attribute "OBS:RejectRequests"` \\
            --set "Please submit to Kolab:Development and/or Kolab:3.1:Updates"
        # :command:`osc meta attribute Kolab:3.1 \\
            --attribute "OBS:UpdateProject" \\
            --set "Kolab:3.1:Updates"`

#.  Lock the base maintenance repository:

    .. parsed-literal::

        # :command:`osc meta prj Kolab:3.1 > Kolab:3.1.prj`

    #.  Check the contents of ``Kolab:3.1.prj``:

        .. parsed-literal::

            <project name="Kolab:3.1">
                <title>Kolab 3.1</title>
                <description>Kolab 3.1 Community Edition</description>
                <person userid="Admin" role="maintainer"/>
                <repository name="CentOS_6">
                    <path project="Kolab:3.1" repository="CentOS_6"/>
                    <arch>i586</arch>
                    <arch>x86_64</arch>
                </repository>
                (... snip ...)
            </project>
            EOF

    #.  Add the lock:

        .. parsed-literal::

            (... snip ...)
            <lock>
                <enable/>
            </lock>
            (... snip ...)

        .. WARNING::

            You can only take this step after the initial rebuilds are
            completed.

    #. Push it back:

        .. parsed-literal::

            # :command:`osc meta prj Kolab:3.1 -F -` < Kolab\:3.1.prj

#.  Create the Kolab:3.1:Updates project as a subproject:

    .. parsed-literal::

        # :command:`osc meta prj Kolab:3.1:Updates -F -` << EOF
        <project name="Kolab:3.1:Updates" kind="maintenance_release">
            <title>Updates for Kolab 3.1</title>
            <description></description>
            <link project="Kolab:3.1"/>
            <person userid="Admin" role="maintainer"/>
            <person userid="Admin" role="bugowner"/>
            <build>
                <disable/>
            </build>
            <publish>
                <disable/>
            </publish>
            <debuginfo>
                <enable/>
            </debuginfo>
            <repository name="CentOS_6">
                <path project="Kolab:3.1" repository="CentOS_6"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Debian_6.0">
                <path project="Kolab:3.1" repository="Debian_6.0"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Debian_7.0">
                <path project="Kolab:3.1" repository="Debian_7.0"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Fedora_18">
                <path project="Kolab:3.1" repository="Fedora_18"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Fedora_19">
                <path project="Kolab:3.1" repository="Fedora_19"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="openSUSE_12.1">
                <path project="Kolab:3.1" repository="openSUSE_12.1"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="openSUSE_12.2">
                <path project="Kolab:3.1" repository="openSUSE_12.2"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="openSUSE_12.3">
                <path project="Kolab:3.1" repository="openSUSE_12.3"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Ubuntu_12.04">
                <path project="Kolab:3.1" repository="Ubuntu_12.04"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Ubuntu_12.10">
                <path project="Kolab:3.1" repository="Ubuntu_12.10"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Ubuntu_13.04">
                <path project="Kolab:3.1" repository="Ubuntu_13.04"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="Ubuntu_13.10">
                <path project="Kolab:3.1" repository="Ubuntu_13.10"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="UCS_3.0">
                <path project="Kolab:3.1" repository="UCS_3.0"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
            <repository name="UCS_3.1">
                <path project="Kolab:3.1" repository="UCS_3.1"/>
                <arch>i586</arch>
                <arch>x86_64</arch>
            </repository>
        </project>
        EOF

#.  Set the maintenance attributes on Kolab:3.1:Updates

    .. parsed-literal::

        # :command:`osc meta attribute Kolab:3.1:Updates \\
            --attribute "OBS:Maintained" \\
            --set ""`
        # :command:`osc meta attribute Kolab:3.1:Updates \\
            --attribute "OBS:BranchTarget" \\
            --set ""`

#.  Set the **Release**:

    .. parsed-literal::

        # :command:`osc meta prj Kolab:3.1 -F -` << EOF
        Release: <CI_CNT>%%{?dist}.kolab_3.1
        EOF

