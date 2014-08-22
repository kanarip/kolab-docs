.. _installation-debian:

======================
Installation on Debian
======================

Debian Wheezy
=============

1.  Add the following two lines to ``/etc/apt/sources.list.d/kolab.list``:

    .. parsed-literal::

        deb http://obs.kolabsys.com/repositories/Kolab:/3.3/Debian_7.0/ ./
        deb http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/Debian_7.0/ ./

2.  Obtain and install the GPG keys for the archives:

    .. parsed-literal::

        # :command:`wget -qO - http://obs.kolabsys.com/repositories/Kolab:/3.3/Debian_7.0/Release.key | apt-key add -`
        # :command:`wget -qO - http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/Debian_7.0/Release.key | apt-key add -`

Next, continue with step #3 below.

Debian Jessie
=============

.. warning::

    The packages for Debian Jessie are in an experimental stage, and
    provided solely on popular demand.

1.  Add the following two lines to ``/etc/apt/sources.list.d/kolab.list``:

    .. parsed-literal::

        deb http://obs.kolabsys.com/repositories/Kolab:/3.3/Debian_8.0/ ./
        deb http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/Debian_8.0/ ./

2.  Obtain and install the GPG keys for the archives:

    .. parsed-literal::

        # :command:`wget -qO - http://obs.kolabsys.com/repositories/Kolab:/3.3/Debian_8.0/Release.key | apt-key add -`
        # :command:`wget -qO - http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/Debian_8.0/Release.key | apt-key add -`

Next, continue with step #3 below.

Both Debian Wheezy and Jessie
=============================

3.  To ensure the Kolab packages have priority over the Debian packages, such as
    must be the case for PHP as well as Cyrus IMAP, please make sure the APT
    preferences pin the obs.kolabsys.com origin as a preferred source.

    Put the following in ``/etc/apt/preferences.d/kolab``:

    .. parsed-literal::

        Package: *
        Pin: origin obs.kolabsys.com
        Pin-Priority: 501

4.  Update the repository metadata:

    .. parsed-literal::

        # :command:`apt-get update`

5. Start the installation of the base package as follows:

    .. parsed-literal::

        # :command:`aptitude install kolab`

6.  When asked to confirm you want to install the package and its dependencies, press Enter.

Continue to :ref:`install-setup-kolab`.
