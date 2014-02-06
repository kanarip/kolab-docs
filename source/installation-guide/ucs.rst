.. _installation-ucs:

===========================================
Installation on Univention Corporate Server
===========================================

1.  Add the following line to ``/etc/apt/sources.list.d/kolab.list``:

    For UCS 3.1:

    .. parsed-literal::

        deb http://obs.kolabsys.com:82/Kolab:/Development/UCS_3.1/ ./

2.  Obtain and install the GPG keys for the archives:

    For UCS 3.1:

    .. parsed-literal::

        # :command:`wget http://obs.kolabsys.com:82/Kolab:/Development/UCS_3.1/Release.key`
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

4.  Enable the unmaintained UCS software repositories:

    .. parsed-literal::

        # :command:`ucr set repository/online/unmaintained="yes"`

5.  Update the repository metadata:

    .. parsed-literal::

        # :command:`univention-install kolab`

6.  When asked to confirm you want to install the package and its dependencies, press Enter.

.. WARNING::

    The Kolab Groupware packages for Univention Corporate Server are configured
    automatically. There is no need to run any setup.
