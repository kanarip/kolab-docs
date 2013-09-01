========================================
Installation on Red Hat Enterprise Linux
========================================

1.  Ensure that the system is registered with the Red Hat Network, and is
    associated with the optional software repository.

2.  Install the `EPEL repository <http://fedoraproject.org/wiki/EPEL>`_
    configuration using the RPM package linked to from
    `this page <http://download.fedoraproject.org/pub/epel/6/i386/repoview/epel-release.html>`_.

    .. parsed-literal::

        # rpm -Uhv http://url/to/epel-release.rpm

3.  Install the **yum-plugin-priorities** package:

    .. parsed-literal::

        # yum install yum-plugin-priorities


4.  Install the Kolab Groupware repository configuration using the RPM package
    linked to from `this page <http://mirror.kolabsys.com/pub/redhat/kolab-3.1/el6/development/i386/repoview/kolab-3.1-community-release.html>`_

    .. parsed-literal::

        # rpm -Uvh http://url/to/kolab-community-release.rpm

    .. tip::

        Prior to the stable release of Kolab 3.1, you must also install the
        development repository using the package linked to from
        `this page <http://mirror.kolabsys.com/pub/redhat/kolab-3.1/el6/development/i386/repoview/kolab-3.1-community-release-development.html>`_

5.  Install Kolab Groupware:

    .. parsed-literal::

        # yum install kolab

Continue to :ref:`install-setup-kolab`.
