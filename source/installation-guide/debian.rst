======================
Installation on Debian
======================

1.  Add the following two lines to ``/etc/apt/sources.list.d/kolab-3.1.list``:

    .. parsed-literal::

        deb http://mirror.kolabsys.com/pub/debian/kolab-3.1/ wheezy release updates
        deb-src http://mirror.kolabsys.com/pub/debian/kolab-3.1/ wheezy release updates

    .. tip::

        Prior to the stable release of Kolab 3.1, you must include the following
        lines, possibly in a separate file
        ``/etc/apt/sources.list.d/kolab-3.1-development.list``:

            .. parsed-literal::

                deb http://mirror.kolabsys.com/pub/debian/kolab-3.1/ wheezy development
                deb-src http://mirror.kolabsys.com/pub/debian/kolab-3.1/ wheezy development

2.  To ensure the Kolab packages have priority over the Debian packages, such as must be the case for PHP as well as Cyrus IMAP, please make sure the APT preferences pin the mirror.kolabsys.com origin as a preferred source. Put the following in ``/etc/apt/preferences.d/kolab``:

    .. parsed-literal::

        Package: *
        Pin: origin mirror.kolabsys.com
        Pin-Priority: 501

3.  Update the repository metadata:

    .. parsed-literal::

        # :command:`apt-get update`

4. Start the installation of the base package as follows:

    .. parsed-literal::

        # :command:`aptitude install kolab`

5.  When asked to confirm you want to install the package and its dependencies, press Enter.

6.  When asked to confirm you want to continue installing the packages of which the integrity nor source can be securely verified, press y then Enter.

Continue to :ref:`install-setup-kolab`.
