======================
Installation on Fedora
======================

1.  Install the **yum-plugin-priorities** package:

    .. parsed-literal::

        # :command:`yum install yum-plugin-priorities`


2.  Install the Kolab Groupware repository configuration:

    *   For Fedora 20:

        .. parsed-literal::

            # :command:`cd /etc/yum.repos.d/`
            # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.2/Fedora_20/Kolab:3.2.repo`
            # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.2:/Updates/Fedora_20/Kolab:3.2:Updates.repo`

3.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`install-setup-kolab`.
