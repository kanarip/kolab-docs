.. _installation-debian:

======================
Installation on Debian
======================

.. note::

   At the moment, the Debian packages are still in the process of being developed.
   Therefore, the Updates Repository is quite outdated, and until the Debian packages are considered stable,
   the community is invited to test the packages from the Development repository.

1.  Add the following two lines to ``/etc/apt/sources.list.d/kolab.list``:

    For Debian Wheezy:

    .. parsed-literal::

        deb http://obs.kolabsys.com:82/Kolab:/3.1/Debian_7.0/ ./
        deb http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Debian_7.0/ ./
        deb http://obs.kolabsys.com:82/Kolab:/Development/Debian_7.0/ ./

2.  Obtain and install the GPG keys for the archives:

    For Debian Wheezy:

    .. parsed-literal::

        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1/Debian_7.0/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Debian_7.0/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/Development/Debian_7.0/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`

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
