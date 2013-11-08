======================
Installation on Ubuntu
======================

.. note::

   At the moment, the Ubuntu packages are still in the process of being developed.
   Therefore, the Updates Repository is quite outdated, and until the Ubuntu packages are considered stable,
   the community is invited to test the packages from the Development repository.

1.  Add the following two lines to ``/etc/apt/sources.list.d/kolab.list``:

    For Ubuntu 12.04:

    .. parsed-literal::

        deb http://obs.kolabsys.com:82/Kolab:/3.1/Ubuntu_12.04/ ./
        deb http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Ubuntu_12.04/ ./
        deb http://obs.kolabsys.com:82/Kolab:/Development/Ubuntu_12.04/ ./

    For Ubuntu 12.10:

    .. parsed-literal::

        deb http://obs.kolabsys.com:82/Kolab:/3.1/Ubuntu_12.10/ ./
        deb http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Ubuntu_12.10/ ./
        deb http://obs.kolabsys.com:82/Kolab:/Development/Ubuntu_12.10/ ./

    For Ubuntu 13.04:

    .. parsed-literal::

        deb http://obs.kolabsys.com:82/Kolab:/3.1/Ubuntu_13.04/ ./
        deb http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Ubuntu_13.04/ ./
        deb http://obs.kolabsys.com:82/Kolab:/Development/Ubuntu_13.04/ ./

    For Ubuntu 13.10:

    .. parsed-literal::

        deb http://obs.kolabsys.com:82/Kolab:/3.1/Ubuntu_13.10/ ./
        deb http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Ubuntu_13.10/ ./
        deb http://obs.kolabsys.com:82/Kolab:/Development/Ubuntu_13.10/ ./

2.  Obtain and install the GPG keys for the archives:

    For Ubuntu 12.04:

    .. parsed-literal::

        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1/Ubuntu_12.04/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Ubuntu_12.04/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/Development/Ubuntu_12.04/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`

    For Ubuntu 12.10:

    .. parsed-literal::

        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1/Ubuntu_12.10/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Ubuntu_12.10/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/Development/Ubuntu_12.10/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`

    For Ubuntu 13.04:

    .. parsed-literal::

        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1/Ubuntu_13.04/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Ubuntu_13.04/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/Development/Ubuntu_13.04/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`

    For Ubuntu 13.10:

    .. parsed-literal::

        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1/Ubuntu_13.10/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Ubuntu_13.10/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/Development/Ubuntu_13.10/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`

3.  To ensure the Kolab packages have priority over the Ubuntu packages, such as
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
