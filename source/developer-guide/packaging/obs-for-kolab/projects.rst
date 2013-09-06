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

Forking off Kolab 3.0
---------------------

Suggested on http://opensuse.14.x6.nabble.com/the-best-way-to-clone-entire-project-td4990396.html:

    osc api -X POST /source/NEW_PROJECT?cmd=copy&oproject=OLD_PROJECT&...

    "see api.txt for more details"
