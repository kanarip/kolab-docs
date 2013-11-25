========================
Installation on openSUSE
========================

1.  Install the Kolab Groupware repositories:

    *   For openSUSE 13.1:
    
        .. parsed-literal::

            # :command:`zypper ar http://obs.kolabsys.com:82/Kolab:/3.1/openSUSE_13.1/`
            # :command:`zypper ar http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/openSUSE_13.1/`
            
    *   For openSUSE 12.3:
    
        .. parsed-literal::

            # :command:`zypper ar http://obs.kolabsys.com:82/Kolab:/3.1/openSUSE_12.3/`
            # :command:`zypper ar http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/openSUSE_12.3/`
            
    *   For openSUSE 12.2:
    
        .. parsed-literal::

            # :command:`zypper ar http://obs.kolabsys.com:82/Kolab:/3.1/openSUSE_12.2/`
            # :command:`zypper ar http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/openSUSE_12.2/`
            
    *   For openSUSE 12.1:
    
        .. parsed-literal::

            # :command:`zypper ar http://obs.kolabsys.com:82/Kolab:/3.1/openSUSE_12.1/`
            # :command:`zypper ar http://obs.kolabsys.com:82/Kolab:/3.1:/Updates/openSUSE_12.1/`

2.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`zypper in kolab`

Continue to :ref:`install-setup-kolab`.
