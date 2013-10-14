======================
Installation on Fedora
======================

1.  Install the **yum-plugin-priorities** package:

    .. parsed-literal::

        # :command:`yum install yum-plugin-priorities`


2.  Install the Kolab Groupware repository configuration:

    *   For Fedora 18:

        .. parsed-literal::

            # :command:`cd /etc/yum.repos.d/`
            # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1/Fedora_18/Kolab:3.1.repo`
            # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Fedora_18/Kolab:3.1:Updates.repo`

    *   For Fedora 19:

        .. parsed-literal::

            # :command:`cd /etc/yum.repos.d/`
            # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1/Fedora_19/Kolab:3.1.repo`
            # :command:`wget http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/Fedora_19/Kolab:3.1:Updates.repo`

3.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`install-setup-kolab`.
