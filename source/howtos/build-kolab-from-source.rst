===============================
HOWTO: Build Kolab From Sources
===============================

This HOWTO uses an Enterprise Linux 6, default installation of Kolab Groupware.
For the purpose of this HOWTO, setup-kolab should have been run already, either
from the installed packages or using the command from source as outlined in
:ref:`build-source_pykolab`.

.. WARNING:: Out of Mainstream

    Continuing with this HOWTO, running Kolab Groupware directly from source,
    brings you out of mainline supply streams for updates. We recommend that
    after going through the procedure(s) outlined in this document, you disable
    the Kolab YUM repositories, or package updates might overwrite the files you
    compiled from source.

    We also recommend you subscribe to the following mailing lists to keep in
    touch with upstream, and be notified of important changes:

    * devel@lists.kolab.org
    * commits@lists.kolab.org

libkolabxml
===========

The libkolabxml libraries and modules for PHP and Python are used with
:ref:`build-source_libkolab`, :ref:`build-source_pykolab_wallace`, and the Kolab
plugins for Roundcube :ref:`build-source_kolab-plugins`.

Building and Installing libkolabxml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.  Clone the GIT repository:

    .. parsed-literal::

        # git clone git://git.kolab.org/git/libkolabxml libkolabxml.git
        Initialized empty Git repository in /root/libkolabxml.git/.git/
        remote: Counting objects: 3566, done.
        remote: Compressing objects: 100% (1782/1782), done.
        remote: Total 3566 (delta 2616), reused 2333 (delta 1743)
        Receiving objects: 100% (3566/3566), 650.50 KiB, done.
        Resolving deltas: 100% (2616/2616), done.

2.  Install the build dependencies:

    .. parsed-literal::

        # yum-builddep libkolabxml

3.  Build libkolabxml:

    .. parsed-literal::

        # mkdir build
        # cd build
        # cmake \\
            -DCMAKE_VERBOSE_MAKEFILE=ON \\
            -DCMAKE_INSTALL_PREFIX=$(rpm --eval="%{_prefix}") \\
            -DINCLUDE_INSTALL_DIR=$(rpm --eval="%{_includedir}") \\
            -DLIB_INSTALL_DIR=$(rpm --eval="%{_libdir}") \\
            -DPHP_BINDINGS=ON \\
            -DPYTHON_BINDINGS=ON \\
            ..
        # make

4.  Install libkolabxml:

    .. parsed-literal::

        # make install

Testing Modifications
^^^^^^^^^^^^^^^^^^^^^

Your modifications to libkolabxml should be complete before submitting a patch
or making a commit. To test whether libkolabxml builds with your modifications,
use the following command:

.. parsed-literal::

    # ./autogen.sh

libcalendaring
==============

libcalendaring is only needed if the system packages do not include KDE >= 4.8.

Building and Installing libcalendaring
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.  Clone the GIT repository:

    .. parsed-literal::

        # git clone git://git.kolab.org/git/libcalendaring libcalendaring.git
        Initialized empty Git repository in /root/libcalendaring.git/.git/
        remote: Counting objects: 2624, done.
        remote: Compressing objects: 100% (1830/1830), done.
        remote: Total 2624 (delta 927), reused 2317 (delta 716)
        Receiving objects: 100% (2624/2624), 3.28 MiB | 263 KiB/s, done.
        Resolving deltas: 100% (927/927), done.

2.  Install the build dependencies:

    .. parsed-literal::

        # yum-builddep libcalendaring

3.  Build libcalendaring:

    .. parsed-literal::

        # mkdir build
        # cd build
        # cmake \\
            -DCMAKE_VERBOSE_MAKEFILE=ON \\
            -DCMAKE_INSTALL_PREFIX=$(rpm --eval="%{_prefix}") \\
            -DINCLUDE_INSTALL_DIR=$(rpm --eval="%{_includedir}") \\
            -DLIB_INSTALL_DIR=$(rpm --eval="%{_libdir}") \\
            -DCMAKE_BUILD_TYPE=Release \\
            ..
        # make

4.  Install libcalendaring:

    .. parsed-literal::

        # make install

Testing Modifications
^^^^^^^^^^^^^^^^^^^^^

Your modifications to libcalendaring should be complete before submitting a
patch or making a commit. To test whether libcalendaring builds with your
modifications, use the following command:

.. parsed-literal::

    # ./autogen.sh

.. _build-source_libkolab:

libkolab
========

Requires libkolabxml, and for systems that do not have KDE >= 4.8,
libcalendaring.

Building and Installing libkolab
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.  Clone the GIT repository:

    .. parsed-literal::

        # git clone git://git.kolab.org/git/libkolab libkolab.git
        Initialized empty Git repository in /root/libkolab.git/.git/
        remote: Counting objects: 2021, done.
        remote: Compressing objects: 100% (1925/1925), done.
        remote: Total 2021 (delta 1353), reused 101 (delta 53)
        Receiving objects: 100% (2021/2021), 441.36 KiB | 250 KiB/s, done.
        Resolving deltas: 100% (1353/1353), done.

2.  Install the build dependencies:

    .. parsed-literal::

        # yum-builddep libkolab

3.  Build libkolab

    *   Build libkolab with libcalendaring

        .. parsed-literal::

            # mkdir build
            # cd build
            # cmake \\
                -DCMAKE_VERBOSE_MAKEFILE=ON \\
                -DCMAKE_INSTALL_PREFIX=$(rpm --eval="%{_prefix}") \\
                -DLIB_INSTALL_DIR=$(rpm --eval="%{_libdir}") \\
                -DINCLUDE_INSTALL_DIR=$(rpm --eval="%{_includedir}") \\
                -DUSE_LIBCALENDARING=ON \\
                -DPHP_BINDINGS=ON \\
                -DPHP_INSTALL_DIR=$(rpm --eval="%{_libdir}")/php/modules \\
                -DPYTHON_BINDINGS=ON \\
                -DCMAKE_BUILD_TYPE=Release \\
                ..
            # make

    *   Build libkolab without libcalendaring

        .. parsed-literal::

            # mkdir build
            # cd build
            # cmake \\
                -DCMAKE_VERBOSE_MAKEFILE=ON \\
                -DCMAKE_INSTALL_PREFIX=$(rpm --eval="%{_prefix}") \\
                -DLIB_INSTALL_DIR=$(rpm --eval="%{_libdir}") \\
                -DINCLUDE_INSTALL_DIR=$(rpm --eval="%{_includedir}") \\
                -DPHP_BINDINGS=ON \\
                -DPHP_INSTALL_DIR=$(rpm --eval="%{_libdir}")/php/modules \\
                -DPYTHON_BINDINGS=ON \\
                -DCMAKE_BUILD_TYPE=Release \\
                ..
            # make

4.  Install libkolab:

    .. parsed-literal::

        # make install

Testing Modifications
^^^^^^^^^^^^^^^^^^^^^

Your modifications to libkolab should be complete before submitting a patch or
making a commit. To test whether libkolab builds with your modifications, use
the following command:

.. parsed-literal::

    # ./autogen.sh

.. _build-source_pykolab:

PyKolab
=======

This section outlines running PyKolab directly from source. This involves the
Kolab daemon (kolabd), Wallace (wallaced), and the Kolab SASL Authentication
daemon (kolab-saslauthd).

1.  Clone the GIT repository:

    .. parsed-literal::

        # git clone git://git.kolab.org/git/pykolab.git pykolab.git
        Initialized empty Git repository in /root/pykolab.git/.git/
        remote: Counting objects: 6938, done.
        remote: Compressing objects: 100% (5467/5467), done.
        remote: Total 6938 (delta 4713), reused 1964 (delta 1323)
        Receiving objects: 100% (6938/6938), 1.27 MiB | 1.22 MiB/s, done.
        Resolving deltas: 100% (4713/4713), done.

2.  Install the build dependencies:

    .. parsed-literal::
        # yum-builddep pykolab

3.  Configure pykolab:

    .. parsed-literal::

        # cd pykolab.git
        # autoreconf -v
        # ./configure

Kolab Setup / Bootstrap
^^^^^^^^^^^^^^^^^^^^^^^

Running the Kolab setup procedure (setup-kolab) directly from source allows you
to test fixes and enhancements otherwise not available, and develop your own.

You probably want some level of increased verbosity when running setup-kolab
from source. Use the -d 9 command-line option for protocol level tracing, and
-d 8 for program level step tracing.

.. rubric:: Running setup-kolab.py from Source

.. parsed-literal::

    # ./setup-kolab.py -d 9

Kolab Daemon
^^^^^^^^^^^^

Running the Kolab daemon (kolabd) directly from source allows you to test fixes
and enhancements otherwise not available, and develop your own.

You probably want some level of increased verbosity when running the Kolab
daemon from source. Use the -d 9 command-line option for protocol level tracing,
and -d 8 for program level step tracing.

.. rubric:: Running kolabd.py from Source

1.  Stop the system service and prevent it from starting on boot:

    .. parsed-literal::
        # service kolabd stop
        # chkconfig kolabd off

2.  Run the Kolab daemon

    .. parsed-literal::

        # ./kolabd.py -d 9

.. _build-source_pykolab_wallace:

Wallace Daemon
^^^^^^^^^^^^^^

Running the Wallace daemon (wallaced) directly from source allows you to test
fixes and enhancements otherwise not available, and develop your own.

You probably want some level of increased verbosity when running the Wallace
daemon from source. Use the -d 9 command-line option for protocol level tracing,
and -d 8 for program level step tracing.

.. rubric:: Running wallace.py from Source

1.  Stop the system service and prevent it from starting on boot:

    .. parsed-literal::

        # service wallace stop
        # chkconfig wallace off

2.  Run the Wallace daemon from source:

    .. parsed-literal::

        # ./wallace.py -d 9

Kolab SMTP Access Policy
^^^^^^^^^^^^^^^^^^^^^^^^

Running the Kolab SMTP Access Policy directly from source allows you to test
fixes and enhancements otherwise not available, and develop your own.

You probably want some level of increased verbosity when running the Wallace
daemon from source. Use the -d 9 command-line option for protocol level tracing,
and -d 8 for program level step tracing.

.. rubric:: Running the Kolab SMTP Access Policy from Source

1.  Move the version of the Kolab SMTP Acccess Policy installed on the system out of the way:

    .. parsed-literal::

        # mv /usr/libexec/postfix/kolab_smtp_access_policy \\
            /usr/libexec/postfix/kolab_smtp_access_policy.orig

2.  Create a symbolic link to the GIT version of the Kolab SMTP Access Policy:

    .. parsed-literal::

        # cd /usr/libexec/postfix/
        # ln -s /root/pykolab.git/bin/kolab_smtp_access_policy.py \\
            kolab_smtp_access_policy

3.  Edit /etc/postfix/master.cf to increase the verbosity the Kolab SMTP Access
    Policy logs interactions with. At the end of the file, replace the lines for
    the recipient_policy, recipient_policy_incoming, sender_policy,
    sender_policy_incoming and submission_policy with the following:

    .. NOTE::

        The '\' at the end of these lines is supposed to indicate continuation
        of the line

    .. parsed-literal::

        recipient_policy unix    -   n   n   -    -   spawn
            user=kolab-n argv=/usr/libexec/postfix/kolab_smtp_access_policy \\
            --verify-recipient -d 9

        recipient_policy_incoming unix - n n -    -   spawn
            user=kolab-n argv=/usr/libexec/postfix/kolab_smtp_access_policy \\
            --verify-recipient --allow-unauthenticated -d 9

        sender_policy    unix    -   n   n   -    -   spawn
            user=kolab-n argv=/usr/libexec/postfix/kolab_smtp_access_policy \\
            --verify-sender -d 9

        sender_policy_incoming unix - n  n   -    -   spawn
            user=kolab-n argv=/usr/libexec/postfix/kolab_smtp_access_policy \\
            --verify-sender --allow-unauthenticated -d 9

        submission_policy unix - n n - - spawn
            user=kolab-n argv=/usr/libexec/postfix/kolab_smtp_access_policy \\
            --verify-sender --verify-recipient -d 9

.. _build-source_kolab-plugins:

Roundcube and Kolab Plugins for Roundcube
=========================================

By default, the Roundcube web client interface is available at
``/roundcubemail/``, and served from ``/usr/share/roundcubemail/``. To install
Roundcube and Kolab plugins from source, you will have perform the following
procedure:

Installing Roundcube and Kolab Plugins from Source
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.  Choose a location to install the GIT version of Roundcube. We suggest using
    ``/var/www/html/``.

    .. parsed-literal::

        # cd /usr/share/
        # rm -rf roundcubemail

2.  Clone the Roundcube GIT repository:

    .. parsed-literal::

        # git clone git://github.com/roundcube/roundcubemail
        Cloning into 'roundcubemail'...
        remote: Counting objects: 63856, done.
        remote: Compressing objects: 100% (17118/17118), done.
        remote: Total 63856 (delta 46441), reused 63204 (delta 45880)
        Receiving objects: 100% (63856/63856), 16.92 MiB | 2.28 MiB/s, done.
        Resolving deltas: 100% (46441/46441), done.

3.  Use the configuration from the RPM Roundcube installation:

    .. parsed-literal::

        # cd roundcubemail/config/
        # cp -a /etc/roundcubemail/db.inc.php db.inc.php
        # cp -a /etc/roundcubemail/main.inc.php main.inc.php

4.  We create a new database for this Roundcube version.

    .. parsed-literal::

        # mysql -p -e 'CREATE DATABASE roundcube_git;'
        # mysql -p -e "GRANT ALL PRIVILEGES ON roundcube_git.*
            TO roundcube@localhost IDENTIFIED BY 'password';"
        # mysql -p -e 'FLUSH PRIVILEGES;'
        # sed -i -e "s\|/roundcube'\|/roundcube_git'\|g" config/db.inc.php
        # mysql -p roundcube_git < ./SQL/mysql.initial.sql

5.  Clone the GIT repository for the Kolab plugins:

    .. parsed-literal::

        # cd /usr/share/
        # git clone git://git.kolab.org/git/roundcubemail-plugins-kolab
        Cloning into 'roundcubemail-plugins-kolab'...
        remote: Counting objects: 11172, done.
        remote: Compressing objects: 100% (4664/4664), done.
        remote: Total 11172 (delta 6696), reused 8756 (delta 5080)
        Receiving objects: 100% (11172/11172), 2.42 MiB | 2.00 MiB/s, done.
        Resolving deltas: 100% (6696/6696), done.

6.  Use the Kolab plugin configuration from the system directory
    ``/etc/roundcubemail/`` as installed by the roundcubemail-plugins-kolab RPM
    package and configured using the setup-kolab utility:

    .. parsed-literal::

        # cd roundcubemail-plugins-kolab/plugins
        # for plugin in \`ls -d \*\`; do
            if [ -f $plugin/config.inc.php.dist -a \\
                -f /etc/roundcubemail/$plugin.inc.php ]; then

                cp -a /etc/roundcubemail/$plugin.inc.php $plugin/config.inc.php; \\
            fi; \\
        done

7.  The libkolab plugin is special:

    .. parsed-literal::

        # cp -a /etc/roundcubemail/kolab.inc.php libkolab/config.inc.php

8.  Load the database schemas for the Kolab plugins:

    .. parsed-literal::

        # mysql -p roundcube_git < calendar/drivers/kolab/SQL/mysql.initial.sql
        # mysql -p roundcube_git < libkolab/SQL/mysql.initial.sql

9.  Put the Kolab plugins into the Roundcube plugins/ directory:

    .. parsed-literal::

        # cd /usr/share/roundcubemail/
        # for plugin in \`find ../roundcubemail-plugins-kolab/plugins/ \\
                -mindepth 1 -maxdepth 1 -type d | \\
                xargs -n 1 basename\`; do
            ln -s ../../roundcubemail-plugins-kolab/plugins/$plugin plugins/$plugin; \\
        done

10. Make sure Roundcube can write to its log files and directory for temporary files:

    .. parsed-literal::

        # chmod 777 logs temp

Kolab Web Administration Panel and API
======================================

By default, the Kolab Web Administration Panel client interface and API are
normally available at /kolab-webadmin/, and served from
``/usr/share/kolab-webadmin/``.

To install the Kolab Web Administration Panel client interface and API, execute
the following procedure:

Installing the Kolab WAP Client and API from Source
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.  Remove the version installed by packaging:

    .. parsed-literal::

        # cd /usr/share/
        # rm -rf kolab-webadmin

2.  Clone the GIT repository:

    .. parsed-literal::

        # git clone git://git.kolab.org/git/kolab-wap kolab-webadmin
        Initialized empty Git repository in /usr/share/kolab-webadmin/.git/
        remote: Counting objects: 6086, done.
        remote: Compressing objects: 100% (4140/4140), done.
        remote: Total 6086 (delta 4016), reused 2649 (delta 1669)
        Receiving objects: 100% (6086/6086), 1.52 MiB | 468 KiB/s, done.
        Resolving deltas: 100% (4016/4016), done.

3.  Set the necessary file permissions:

    .. parsed-literal::

        # cd kolab-webadmin/
        # chmod 777 cache logs

4.  Consider setting the following two options in :file:`/etc/kolab/kolab.conf`:

    .. parsed-literal::

        [kolab_wap]
        devel_mode = 1
        debug_mode = trace

    This will enable full debugging, and avoid the use of caching.

Hosted Kolab Customer Control Panel
===================================

.. todo::

    Write the section on running the Hosted Kolab Customer Control Panel from
    source.

Chwala
======

.. todo::

    Write the section on running Chwala from source.

iRony
=====

.. todo::

    Write the section on running iRony from source.


Kolab Utilities
===============

The Kolab utilities include Kolab Free/Busy, Migration, Format Upgrade.

The Kolab utilities require libkolab to be successfully built and installed.

Running Kolab Free/Busy from Source
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.  Install the build dependencies:

    .. parsed-literal::

        # yum-builddep kolab-utils

2.  Clone the GIT repository:

    .. parsed-literal::

        # git clone git://git.kolab.org/git/kolab-utils kolab-utils.git

3.  Build the Kolab utilities:

    .. parsed-literal::

        # cd kolab-utils.git
        # ./autogen.sh

Free/Busy Generation and Aggregation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Upgrading the Format Version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Migration
^^^^^^^^^

Kolab Free/Busy Web Application
===============================
