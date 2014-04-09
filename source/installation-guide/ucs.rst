.. _installation-ucs:

===========================================
Installation on Univention Corporate Server
===========================================

.. WARNING::

    There are **three** versions of Kolab for UCS. Make sure you choose the correct
    version for your requirements.

Kolab Enterprise 13
-------------------

To install the Enterprise edition under Kolab Systems support, execute the
following process:

#.  Configure your UCS system to obtain the repository configuration packages:

    .. parsed-literal::

        # :command:`ucr set \\
            repository/online/component/kolab-13=enabled \\
            repository/online/component/kolab-13/description="Kolab Enterprise 13 Installation Repository" \\
            repository/online/component/kolab-13/server="mirror.kolabsys.com" \\
            repository/online/component/kolab-13/prefix="pub/ucs" \\
            repository/online/component/kolab-13/version="current" \\
            repository/online/component/kolab-13/parts="maintained"`

#.  Install the client certificate you have obtained from Kolab Systems in the
    following location:

    .. parsed-literal::

        /etc/apt/certs/mirror.kolabsys.com.client.pem

    If you do not have an SSL client certificate from Kolab Systems, contact
    sales@kolabsys.com.

#.  Install the repository configuration package:

    .. parsed-literal::

        # :command:`univention-install kolab-13-enterprise-release`

    When the installation complains the package cannot be verified, type [y] and
    [Enter] to continue:

    .. parsed-literal::

        WARNING: The following packages cannot be authenticated!
          kolab-13-enterprise-release-development
        Install these packages without verification [y/N]? y

#.  Install kolab:

    .. parsed-literal::

        # :command:`univention-install kolab`

Kolab Groupware from the App Center
-----------------------------------

An evaluation version of Kolab is also available in the Univention App Center.

Kolab Groupware from the OBS
----------------------------

.. WARNING::

    This is a community version of Kolab Groupware, and it is not recommended
    you run this version in production. Instead, for production use Kolab Enterprise from Kolab Systems.

#.  Add the following line to ``/etc/apt/sources.list.d/kolab.list``:

    For UCS 3.2:

    .. parsed-literal::

        deb http://obs.kolabsys.com:82/Kolab:/Development/UCS_3.2/ ./

#.  Obtain and install the GPG keys for the archives:

    For UCS 3.2:

    .. parsed-literal::

        # :command:`wget http://obs.kolabsys.com:82/Kolab:/Development/UCS_3.2/Release.key`
        # :command:`apt-key add Release.key`
        # :command:`rm -rf Release.key`

#.  To ensure the Kolab packages have priority over the Debian packages, such as
    must be the case for PHP as well as Cyrus IMAP, please make sure the APT
    preferences pin the obs.kolabsys.com origin as a preferred source.

    Put the following in ``/etc/apt/preferences.d/kolab``:

    .. parsed-literal::

        Package: *
        Pin: origin obs.kolabsys.com
        Pin-Priority: 501

#.  Enable the unmaintained UCS software repositories:

    .. parsed-literal::

        # :command:`ucr set repository/online/unmaintained="yes"`

#.  Update the repository metadata:

    .. parsed-literal::

        # :command:`univention-install kolab`

#.  When asked to confirm you want to install the package and its dependencies, press Enter.

.. WARNING::

    The Kolab Groupware packages for Univention Corporate Server are configured
    automatically. There is no need to run any setup.
