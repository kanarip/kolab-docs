======================
Installation on Fedora
======================

1.  Install the **yum-plugin-priorities** package:

    .. parsed-literal::

        # yum install yum-plugin-priorities


2.  Install the Kolab Groupware repository configuration using the RPM package
    linked to from `this page <http://mirror.kolabsys.com/pub/fedora/kolab-3.1/f19/development/i386/repoview/kolab-3.1-community-release.html>`_

    .. parsed-literal::

        # rpm -Uvh http://url/to/kolab-community-release.rpm

    .. tip::

        Prior to the stable release of Kolab 3.1, you must also install the
        development repository using the package linked to from
        `this page <http://mirror.kolabsys.com/pub/fedora/kolab-3.1/f19/development/i386/repoview/kolab-3.1-community-release-development.html>`_

3.  Install Kolab Groupware:

    .. parsed-literal::

        # yum install kolab

Continue to :ref:`install-setup-kolab`.
