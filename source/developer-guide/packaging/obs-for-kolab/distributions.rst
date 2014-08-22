=============
Distributions
=============

Kolab OBS provides community packages for the following distribution(s)
and version(s):

==========  =======
Name        Version
==========  =======
CentOS      6
            7
Debian      6.0
            7.0
            8.0
Fedora      19
            20
openSUSE    12.2
            12.3
            13.1
Ubuntu      12.04
            12.10
            13.04
            13.10
            14.04
UCS         3.0
            3.1
            3.2
==========  =======

Adding the Distributions
========================

Add CentOS 6
------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj CentOS:6 -F -` << EOF
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

        # :command:`osc -A https://api.opensuse.org meta prjconf CentOS:CentOS-6` | \\
            :command:`osc meta prjconf CentOS:6 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('CentOS', '6', 'CentOS 6', 'CentOS:6', 'CentOS_6', 'standard');"

.. NOTE::

    The opensuse configuration does not have a %{rhel} macro

Add CentOS 7
------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj CentOS:7 -F -` << EOF
        <project name="CentOS:7">
            <title>CentOS 7 (Maipo)</title>
            <description>CentOS 7 (Maipo)</description>
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

        # :command:`osc -A https://api.opensuse.org meta prjconf CentOS:CentOS-7` | \\
            :command:`osc meta prjconf CentOS:7 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('CentOS', '7', 'CentOS 7', 'CentOS:7', 'CentOS_7', 'standard');"

.. NOTE::

    The opensuse configuration does not have a %{rhel} macro

Add Debian 6.0
--------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj Debian:6.0 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Debian:6.0` | \\
            :command:`osc meta prjconf Debian:6.0 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('Debian', '6', 'Debian 6.0', 'Debian:6.0', 'Debian_6.0', 'standard');"

Add Debian 7.0
--------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj Debian:7.0 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Debian:7.0` | \\
            :command:`osc meta prjconf Debian:7.0 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('Debian', '7', 'Debian 7.0', 'Debian:7.0', 'Debian_7.0', 'standard');"

Add Debian 8.0
--------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj Debian:8.0 -F -` << EOF
        <project name="Debian:8.0">
            <title>Debian 8.0 (Jessie)</title>
            <description>Debian 8.0 (Jessie)</description>
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Debian:8.0` | \\
            :command:`osc meta prjconf Debian:8.0 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('Debian', '8', 'Debian 8.0', 'Debian:8.0', 'Debian_8.0', 'standard');"

Add Fedora 17
-------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj Fedora:17 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Fedora:17` | \\
            :command:`osc meta prjconf Fedora:17 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('Fedora', '17', 'Fedora 17', 'Fedora:17', 'Fedora_17', 'standard');"

Add Fedora 18
-------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj Fedora:18 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Fedora:18` | \\
            :command:`osc meta prjconf Fedora:18 -F -`

    .. NOTE::

        The opensuse configuration does not have a %{opensuse_bs} macro

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('Fedora', '18', 'Fedora 18', 'Fedora:18', 'Fedora_18', 'standard');"

Add Fedora 19
-------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj Fedora:19 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Fedora:19` | \\
            :command:`osc meta prjconf Fedora:19 -F -`

    .. NOTE::

        The opensuse configuration does not have a %{opensuse_bs} macro

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('Fedora', '19', 'Fedora 19', 'Fedora:19', 'Fedora_19', 'standard');"

Add openSUSE 12.1
-----------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj openSUSE:12.1 -F -` << EOF
        <project name="openSUSE:12.1">
            <title>openSUSE 12.1</title>
            <description>openSUSE 12.1</description>
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf openSUSE:12.1` | \\
            :command:`osc meta prjconf openSUSE:12.1 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('openSUSE', '12.1', 'openSUSE 12.1', 'openSUSE:12.1', 'openSUSE_12.1', 'standard');"

Add openSUSE 12.2
-----------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj openSUSE:12.2 -F -` << EOF
        <project name="openSUSE:12.2">
            <title>openSUSE 12.2</title>
            <description>openSUSE 12.2</description>
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf openSUSE:12.2` | \\
            :command:`osc meta prjconf openSUSE:12.2 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('openSUSE', '12.2', 'openSUSE 12.2', 'openSUSE:12.2', 'openSUSE_12.2', 'standard');"

Add openSUSE 12.3
-----------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj openSUSE:12.3 -F -` << EOF
        <project name="openSUSE:12.3">
            <title>openSUSE 12.3</title>
            <description>openSUSE 12.3</description>
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf openSUSE:12.3` | \\
            :command:`osc meta prjconf openSUSE:12.3 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('openSUSE', '12.3', 'openSUSE 12.3', 'openSUSE:12.3', 'openSUSE_12.3', 'standard');"

Add Ubuntu 12.04
----------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj Ubuntu:12.04 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Ubuntu:12.04` | \\
            :command:`osc meta prjconf Ubuntu:12.04 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('Ubuntu', '12.04', 'Ubuntu 12.04', 'Ubuntu:12.04', 'Ubuntu_12.04', 'standard');"

Add Ubuntu 12.10
----------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj Ubuntu:12.10 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Ubuntu:12.10` | \\
            :command:`osc meta prjconf Ubuntu:12.10 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('Ubuntu', '12.10', 'Ubuntu 12.10', 'Ubuntu:12.10', 'Ubuntu_12.10', 'standard');"

Add Ubuntu 13.04
----------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj Ubuntu:13.04 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Ubuntu:13.04` | \\
            :command:`osc meta prjconf Ubuntu:13.04 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('Ubuntu', '13.04', 'Ubuntu 13.04', 'Ubuntu:13.04', 'Ubuntu_13.04', 'standard');"

Add Ubuntu 13.10
----------------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj Ubuntu:13.10 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Ubuntu:13.10` \\
            > Ubuntu:13.10.prjconf

        # :command:`sed -i -e 's/version 1304/version 1310/g' Ubuntu\:13.10.prjconf`

        # :command:`osc meta prjconf Ubuntu:13.10 -F -` < Ubuntu\:13.10.prjconf

    .. NOTE::

        At the time of this writing, the upstream openSUSE Build Service did not
        yet have an Ubuntu 13.10 project configuration.

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('Ubuntu', '13.10', 'Ubuntu 13.10', 'Ubuntu:13.10', 'Ubuntu_13.10', 'standard');"

Add UCS 3.0
-----------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj UCS:3.0 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Debian:6.0` | \\
            :command:`osc meta prjconf UCS:3.0 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('UCS', '3.0', 'UCS 3.0', 'UCS:3.0', 'UCS_3.0', 'standard');"

Add UCS 3.1
-----------

#.  Create the project:

    .. parsed-literal::

        # :command:`osc meta prj UCS:3.1 -F -` << EOF
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

#.  Copy the project configuration over from api.opensuse.org:

    .. parsed-literal::

        # :command:`osc -A https://api.opensuse.org meta prjconf Debian:6.0` | \\
            :command:`osc meta prjconf UCS:3.1 -F -`

#.  Insert the project as being a distribution:

    .. parsed-literal::

        # :command:`mysql api_production -e` "INSERT INTO distributions \\
            (vendor, version, name, project, reponame, repository) VALUES \\
            ('UCS', '3.1', 'UCS 3.1', 'UCS:3.1', 'UCS_3.1', 'standard');"
