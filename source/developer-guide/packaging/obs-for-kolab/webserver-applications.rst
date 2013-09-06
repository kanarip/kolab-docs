================================
Packaging Webserver Applications
================================

In principle, Kolab Groupware applications depend on **httpd** from the Apache
foundation.

To re-use ``Requires:``, commands to install initial application configuration for
the webserver, ``%post`` and ``%pre`` commands, we seek to use the following
snippets of macro definitions:

**Define the httpd package name**

    .. parsed-literal::

        %if 0%{?suse_version}
        %global httpd_name apache2
        %else
        %global httpd_name httpd
        %endif

**Define the dependency**

    .. parsed-literal::
    
        Requires:       %{httpd_name}

**Define the configuration directory**

    Defining the **httpd** configuration directory for individual web
    applications helps address differences between distributions just once, to
    further avoid making ``%install`` and ``%files`` conditionals unnecessary.

    .. parsed-literal::

        %global _ap_sysconfdir %{_sysconfdir}/%{httpd_name}
        
**Define your** ``%{php_inidir}``

    Define the PHP .ini configuration dir for additional extensions such as APC,
    for applications that are being updated should reload the webserver, but
    only if APC is enabled.

    .. parsed-literal::
    
        %{!?php_inidir: %global php_inidir %{_sysconfdir}/php.d}
    
The combination of the aforementioned can now be used to:
    
.. parsed-literal::

    %post
    if [ -f "%{php_inidir}/apc.ini" ]; then
        if [ ! -z "\`grep ^apc.enabled=1 %{php_inidir}/apc.ini\`" ]; then
    %if 0%{?with_systemd}
            /sbin/systemctl condrestart httpd.service
    %else
            /sbin/service httpd condrestart
    %endif
        fi
    fi
        
Possible Future Enhancements
============================

#.  Package to depend on a capability provided by **httpd** / **apache2**,
    **nginx**, **lighttpd** and other alternatives, which may be *webserver*.
    
    #.  Consider providing the default configuration to install along with the
        packages, and where to put them on various platforms.
        
        In Fedora, this may not be done in ``%post``.