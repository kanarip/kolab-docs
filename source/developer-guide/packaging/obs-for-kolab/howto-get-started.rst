============================================
Getting Started with the Kolab Groupware OBS
============================================

Step 1: Install **osc**
=======================

The openSUSE build system is interacted with using a command-line utility called
**osc**.

To download **osc** for your platform, please visit:

    http://software.opensuse.org/download?package=osc&project=openSUSE%3ATools

Select your Linux distribution, and follow the instructions.

Initial configuration for the **osc** command-line utility would be created when
you first run it, but the configuration defaults to using build.opensuse.org
rather than obs.kolabsys.com.

Consider seeding your configuration by putting the following in
:file:`~/.oscrc`, changing of course your username and password:

.. parsed-literal::

    [general]
    apiurl = https://obs.kolabsys.com:444

    [https://obs.kolabsys.com:444]
    user=doe
    pass=VerySecret

Step 2: Create your Home Project
================================

To be able to submit updates for review and approval, we recommend you first
create your home project, which will function as the parent, and hold the
repository configuration.

The projects you will be creating in your home project are branches off of the
targeted branch. So, for example, if you wish to submit an update for the
**libkolab** package in **Kolab:3.1:Updates**, you will branch off the package
**libkolab** from **Kolab:3.1:Updates**, and create a **libkolab** package in
a new project **home:vanmeeuwen:branches:Kolab:3.1:Updates**.

Taking the **home:vanmeeuwen** project as an example, pull the configuration of
it to your own home project:

.. parsed-literal::

    $ :command:`username=<USERNAME>`
    $ :command:`osc meta prj home:vanmeeuwen | \\
        osc meta prj home:$username -F -`

Alternatively, use the following command:

.. parsed-literal::

    $ :command:`username=<USERNAME>`
    $ :command:`osc meta prj home:$username -F - << EOF`
    <project name="home:$username">
        <title>Kolab:Development</title>
        <description></description>
        <person userid="$username" role="maintainer"/>
        <person userid="$username" role="bugowner"/>
        <repository name="openSUSE_12.3">
            <path project="openSUSE:12.3" repository="updates"/>
            <path project="openSUSE:12.3" repository="release"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="openSUSE_12.2">
            <path project="openSUSE:12.2" repository="updates"/>
            <path project="openSUSE:12.2" repository="release"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="openSUSE_12.1">
            <path project="openSUSE:12.1" repository="updates"/>
            <path project="openSUSE:12.1" repository="release"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="Ubuntu_13.10">
            <path project="Ubuntu:13.10" repository="universe"/>
            <path project="Ubuntu:13.10" repository="main"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="Ubuntu_13.04">
            <path project="Ubuntu:13.04" repository="universe"/>
            <path project="Ubuntu:13.04" repository="main"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="Ubuntu_12.10">
            <path project="Ubuntu:12.10" repository="universe"/>
            <path project="Ubuntu:12.10" repository="main"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="Ubuntu_12.04">
            <path project="Ubuntu:12.04" repository="universe"/>
            <path project="Ubuntu:12.04" repository="main"/>
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
        <repository name="UCS_3.0">
            <path project="UCS:3.0" repository="maintained"/>
            <path project="UCS:3.0" repository="unmaintained"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="Fedora_19">
            <path project="Fedora:19" repository="updates"/>
            <path project="Fedora:19" repository="release"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="Fedora_18">
            <path project="Fedora:18" repository="updates"/>
            <path project="Fedora:18" repository="release"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="Debian_7.0">
            <path project="Debian:7.0" repository="main"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="Debian_6.0">
            <path project="Debian:6.0" repository="main"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
        <repository name="CentOS_6">
            <path project="CentOS:6" repository="epel"/>
            <path project="CentOS:6" repository="updates"/>
            <path project="CentOS:6" repository="release"/>
            <arch>i586</arch>
            <arch>x86_64</arch>
        </repository>
    </project>
    EOF

Step 3: Pick your Poison
========================

At the time of this writing, the Kolab Groupware OBS maintains the following
projects:

    #.  **Kolab Development**

        This repository contains the latest and greatest releases upstream,
        possibly including builds of software that is gravely unstable, does not
        work and break your system.

        This repository is in the lead for future Kolab Groupware releases, and
        should be used by packagers and developers in non-production,
        development environments only, and only by those that are autonomous in
        supporting such environment.

    #.  **Kolab 3.1 Updates**

        This project provides users of Kolab Groupware with updates to the
        base release of Kolab 3.1.

    #.  Kolab 3.0 Updates

        This project provides users of Kolab Groupware with updates to the
        base release of Kolab 3.0, and is no longer actively supported.

Step 4: Branch off a Package
============================

Having chosen your target destination for the update your are going to be
working on, branch off the appropriate package:

.. parsed-literal::

    $ :command:`mkdir -p ~/devel/osc`
    $ :command:`cd ~/devel/osc`
    $ :command:`osc branch Kolab:3.1:Updates libkolab`
    A working copy of the branched package can be checked out with:

    osc co home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab
    $ :command:`osc co home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab`
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/debian-Debian_6.0.control
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/debian.changelog
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/debian.control
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/debian.rules
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/debian.series
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/debian.tar.gz
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/libkolab-0.4.2-cmake-2.8.11.patch
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/libkolab-0.4.2-paths.patch
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/libkolab-0.5-swigutils.cmake.patch
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/libkolab-0.5.tar.gz
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/libkolab.dsc
    A    home:vanmeeuwen:branches:Kolab:3.1:Updates/libkolab/libkolab.spec
    At revision 217384e71ed2eaaeb0f22058e8b51eec.

.. NOTE::

    This branch starts building immediately, for all the target platforms
    configured as part of the ``home:vanmeeuwen`` home project (for user
    vanmeeuwen).

Step 5: Update the Packaging & Testing the Changes
==================================================

First off, you are going to make some changes most likely.

.. parsed-literal::

    $ :command:`cd home\:vanmeeuwen\:branches\:Kolab\:3.1\:Updates/libkolab/`
    $ (... make changes ...)

Do not yet commit these unless you are certain the changes work. Instead,
attempt a local build:

.. parsed-literal::

    $ :command:`osc build --no-verify $target $spec`

where:

**$target**

    is one of the target repository names, such as *Debian_6.0*, *CentOS_6*,
    etc.

**$spec**

    is one of the local package specifications, i.e. either the :file:`.dsc` or
    :file:`.spec` of the package.

Step 6: Make Sure the Package is Actually an Update
===================================================

When you are satisfied with the results of your test build(s), bump the version
numbers and release numbers as appropriate, in at least the following files:

    #. The :file:`.dsc` for the package, if applicable,

    #. The :file:`debian.changelog` for the package, if applicable,

    #. The :file:`.spec` for the package, if applicable.

Step 7: Commit the Changes
==========================

Once step 1 through 6 are completed, continue with commiting the changes back to
the Kolab Groupware OBS:

.. parsed-literal::

    $ :command:`osc ci`

See additional **osc** command documentation for further aid in adding, removing
and other such actions.

.. NOTE::

    This will start the authoritative builds on the Kolab Groupware OBS, and it
    will be those builds you are submitting in Step 8.

    Please make sure everything builds correctly on the Kolab Groupware OBS as
    well, and consider testing the updates before continuing with Step 8.

Step 8: Submit the Package Update Request
=========================================

.. WARNING::

    By doing so, you are requesting your updated package be made available to
    thousands of consumers globally.

    We would encourage you to execute some Quality Assurance both on the
    software as well as the packaging, before submitting update requests.

    Package updates that supposedly fix one or more issues that do not have
    corresponding tickets in Bugzilla will be refused.

.. parsed-literal::

    $ :command:`osc sr`

Provide an appropriate message with the request, that aids the reviewer(s) in
determining the feasibility and impact of accepting your update, such as
including the ticket numbers of resolved issues.
