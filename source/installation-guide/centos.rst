======================
Installation on CentOS
======================

1.  Install the `EPEL repository <http://fedoraproject.org/wiki/EPEL>`_
    configuration using the RPM package linked to from the
    `epel-release repository view page <http://download.fedoraproject.org/pub/epel/6/i386/repoview/epel-release.html>`_.

    .. parsed-literal::

        # :command:`rpm -Uhv http://url/to/epel-release.rpm`

2.  Install the **yum-plugin-priorities** package:

    .. parsed-literal::

        # :command:`yum install yum-plugin-priorities`


3.  Install the Kolab Groupware repository configuration:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1/CentOS_6/Kolab:3.1.repo`
        # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/CentOS_6/Kolab:3.1:Updates.repo`

4.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`install-setup-kolab`.
