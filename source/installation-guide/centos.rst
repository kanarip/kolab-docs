======================
Installation on CentOS
======================

1.  Install the `EPEL repository <http://fedoraproject.org/wiki/EPEL>`_
    configuration using the RPM package linked to from
    `this page <http://download.fedoraproject.org/pub/epel/6/i386/repoview/epel-release.html>`_.

    .. parsed-literal::

        # :command:`rpm -Uhv http://url/to/epel-release.rpm`

2.  Install the **yum-plugin-priorities** package:

    .. parsed-literal::

        # :command:`yum install yum-plugin-priorities`


3.  Install the Kolab Groupware repository configuration using the RPM package
    linked to from `this page <http://mirror.kolabsys.com/pub/redhat/kolab-3.1/el6/development/i386/repoview/kolab-3.1-community-release.html>`_

    .. parsed-literal::

        # :command:`rpm -Uvh http://url/to/kolab-community-release.rpm`

    .. tip::

        Prior to the stable release of Kolab 3.1, you must also install the
        development repository using the package linked to from
        `this page <http://mirror.kolabsys.com/pub/redhat/kolab-3.1/el6/development/i386/repoview/kolab-3.1-community-release-development.html>`_

4.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`install-setup-kolab`.
