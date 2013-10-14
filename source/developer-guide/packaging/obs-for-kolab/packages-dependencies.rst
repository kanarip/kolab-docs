===================
Dependency Packages
===================

.. _packages-dependencies-389-admin:

389-admin
=========

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras 389-admin \\
        home:vanmeeuwen:branches:Kolab:Development 389-admin`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development 389-admin -F -` << EOF
    <package name="389-admin">
        <title>389 Administration Server</title>
        <description>
            389 Administration Server is an HTTP agent that provides management
            features for 389 Directory Server. It provides some management web
            apps that can be used through a web browser. It provides the
            authentication, access control, and CGI utilities used by the
            console.
        </description>
        <build>
            <disable/>
            <enable repository="Debian_7.0"/>
            <enable repository="openSUSE_12.1"/>
            <enable repository="openSUSE_12.2"/>
            <enable repository="openSUSE_12.3"/>
        </build>
    </package>
    EOF

.. rubric:: See Also

*   Rebuild against :ref:`packages-dependencies-httpd` (Debian 7.0 only).

.. include:: packages/389-admin.txt

389-admin-console
=================

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras 389-admin-console \\
        home:vanmeeuwen:branches:Kolab:Development 389-admin-console`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development 389-admin -F -` << EOF
    <package name="389-admin-console">
        <title></title>
        <description></description>
        <build>
            <disable/>
            <enable repository="Debian_7.0"/>
            <enable repository="openSUSE_12.1"/>
            <enable repository="openSUSE_12.2"/>
            <enable repository="openSUSE_12.3"/>
        </build>
    </package>
    EOF

.. include:: packages/389-admin-console.txt

389-adminutil
=============

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras 389-adminutil \\
        home:vanmeeuwen:branches:Kolab:Development 389-adminutil`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development 389-adminutil -F -` << EOF
    <package name="389-adminutil">
        <title>Utility library for 389 administration</title>
        <description>
            389-adminutil is libraries of functions used to administer directory
            servers, usually in conjunction with the admin server. 389-adminutil
            is broken into two libraries - libadminutil contains the basic
            functionality, and libadmsslutil contains SSL versions and wrappers
            around the basic functions. The PSET functions allow applications
            to store their preferences and configuration parameters in LDAP,
            without having to know anything about LDAP. The configuration is
            cached in a local file, allowing applications to function even if
            the LDAP server is down. The other code is typically used by CGI
            programs used for directory server management, containing GET/POST
            processing code as well as resource handling (ICU ures API).
        </description>
        <build>
            <disable/>
            <enable repository="Debian_7.0"/>
            <enable repository="openSUSE_12.1"/>
            <enable repository="openSUSE_12.2"/>
            <enable repository="openSUSE_12.3"/>
        </build>
    </package>
    EOF

.. include:: packages/389-adminutil.txt

389-console
===========

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras 389-console \\
        home:vanmeeuwen:branches:Kolab:Development 389-console`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development 389-console -F -` << EOF
    <package name="389-console">
        <title></title>
        <description></description>
        <build>
            <disable/>
            <enable repository="Debian_7.0"/>
            <enable repository="openSUSE_12.1"/>
            <enable repository="openSUSE_12.2"/>
            <enable repository="openSUSE_12.3"/>
        </build>
    </package>
    EOF

.. include:: packages/389-console.txt

389-ds-base
===========

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras 389-ds-base \\
        home:vanmeeuwen:branches:Kolab:Development 389-ds-base`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development 389-ds-base -F -` << EOF
    <package name="389-ds-base">
        <title>389 Directory Server (base)</title>
        <description>
            The enterprise-class Open Source LDAP server for Linux. It is
            hardened by real-world use, is full-featured, supports multi-master
            replication, and already handles many of the largest LDAP
            deployments in the world.

            Key Features

            *   4-Way Multi-Master Replication, to provide fault tolerance and
                high write performance.

            *   Scalability: thousands of operations per second, tens of
                thousands of concurrent users, tens of millions of entries,
                hundreds of gigabytes of data.

            *   The code base has been developed and deployed continuously by
                the same team for more than a decade.

            *   Extensive documentation, including helpful Installation and
                Deployment guides.

            *   Active Directory user and group synchronization.

            *   Secure authentication and transport (SSLv3, TLSv1, and SASL)

            *   Support for LDAPv3

            *   On-line, zero downtime, LDAP-based update of schema,
                configuration, management and in-tree Access Control Information
                (ACIs).

            *   Graphical console for all facets of user, group, and server
                management.
        </description>
        <build>
            <disable/>
            <enable repository="Debian_7.0"/>
            <enable repository="openSUSE_12.1"/>
            <enable repository="openSUSE_12.2"/>
            <enable repository="openSUSE_12.3"/>
        </build>
    </package>
    EOF

.. include:: packages/389-ds-base.txt

389-ds-console
==============

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras 389-ds-console \\
        home:vanmeeuwen:branches:Kolab:Development 389-ds-console`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development 389-ds-console -F -` << EOF
    <package name="389-ds-console">
        <title>389 Directory Server Management Console</title>
        <description>
            A Java based remote management console used for managing 389
            Directory Server.
        </description>
        <build>
            <disable/>
            <enable repository="Debian_7.0"/>
            <enable repository="openSUSE_12.1"/>
            <enable repository="openSUSE_12.2"/>
            <enable repository="openSUSE_12.3"/>
        </build>
    </package>
    EOF

.. include:: packages/389-ds-console.txt

389-dsgw
========

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development 389-dsgw -F -` << EOF
    <package name="389-dsgw">
        <title>389-dsgw</title>
        <description>389-dsgw</description>
        <url>http://www.port389.org</url>
        <build>
            <disable/>
            <enable repository="Debian_7.0"/>
        </build>
    </package>
    EOF

.. include:: packages/389-dsgw.txt

.. _packages-dependencies-apr:

apr
===

Build- and runtime dependency of :ref:`packages-extras-httpd`.

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development apr -F -` << EOF
    <package name="apr">
        <title>apr</title>
        <description>
            Apache Portable Runtime library
        </description>
        <url>http://apr.apache.org</url>
        <build>
            <disable/>
        </build>
    </package>
    EOF

.. rubric:: See Also

*   Build dependency for :ref:`packages-extras-httpd`

.. include:: packages/apr.txt

.. _packages-dependencies-apr-util:

apr-util
========

Build- and runtime dependency of :ref:`packages-extras-httpd`.

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development apr-util -F -` << EOF
    <package name="apr-util">
        <title>apr-util</title>
        <description>
            Apache Portable Runtime Utility library
        </description>
        <url>http://apr.apache.org</url>
        <build>
            <disable/>
        </build>
    </package>
    EOF

.. rubric:: See Also

*   Build dependency for :ref:`packages-extras-httpd`
*   Rebuild required against :ref:`packages-extras-mysql`

.. include:: packages/apr-util.txt

.. _packages-dependencies-httpd:

httpd
=====

Debian Wheezy requires an *apache2* build that allows the parallel installation
of the worker and prefork MPM thread models.

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development httpd -F -` << EOF
    <package name="httpd">
        <title>httpd</title>
        <description></description>
        <url>http://kolab.org/about/httpd</url>
        <build>
            <disable/>
            <enable repository="Debian_7.0"/>
        </build>
    </package>
    EOF

.. rubric:: See Also

*   Build- and runtime dependency of :ref:`packages-dependencies-389-admin`
    (Debian 7.0 only).

.. include:: packages/httpd.txt

idm-console-framework
=====================

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras idm-console-framework \\
        home:vanmeeuwen:branches:Kolab:Development idm-console-framework`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development idm-console-framework -F -` << EOF
    <package name="idm-console-framework">
        <title>Identity Management Console Framework</title>
        <description>
            A Java Management Console framework used for remote server
            management.
        </description>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Debian_7.0"/>
            <disable repository="UCS_3.1"/>
            <disable repository="UCS_3.0"/>
            <disable repository="Debian_6.0"/>
        </build>
    </package>
    EOF

.. include:: packages/idm-console-framework.txt

.. _packages-dependencies-jansson:

jansson
=======

The **jansson** package is required for at least Enterprise Linux 6, to allow
Cyrus IMAP 2.5 to be compiled with notification support.

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development jansson -F -` << EOF
    <package name="jansson">
        <title>jansson</title>
        <description>
            C library for encoding, decoding and manipulating JSON data
        </description>
        <url>http://www.digip.org/jansson/</url>
        <build>
            <disable/>
            <enable repository="CentOS_6"/>
        </build>
    </package>
    EOF

.. include:: packages/jansson.txt

jss
===

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras jss \\
        home:vanmeeuwen:branches:Kolab:Development jss`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development jss -F -` << EOF
    <package name="jss">
        <title>Java Security Services (JSS)</title>
        <description>
            Java Security Services (JSS) is a java native interface which
            provides a bridge for java-based applications to use native Network
            Security Services (NSS). This only works with gcj. Other JREs
            require that JCE providers be signed.
        </description>
        <build>
            <disable repository="Fedora_17"/>
            <disable repository="CentOS_6"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Debian_7.0"/>
            <disable repository="UCS_3.1"/>
            <disable repository="UCS_3.0"/>
            <disable repository="Debian_6.0"/>
        </build>
    </package>
    EOF

.. include:: packages/jss.txt

ldapjdk
=======

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras ldapjdk \\
        home:vanmeeuwen:branches:Kolab:Development ldapjdk`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development ldapjdk -F -` << EOF
    <package name="ldapjdk">
        <title>The Mozilla LDAP Java SDK</title>
        <description>
            The Mozilla LDAP SDKs enable you to write applications that access,
            manage, and update the information stored in an LDAP directory.
        </description>
        <build>
            <disable repository="Fedora_19"/>
            <disable repository="Fedora_18"/>
            <disable repository="CentOS_6"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="Debian_7.0"/>
            <disable repository="UCS_3.1"/>
            <disable repository="UCS_3.0"/>
            <disable repository="Debian_6.0"/>
        </build>
    </package>
    EOF

.. include:: packages/ldapjdk.txt

mod_nss
=======

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras mod_nss \\
        home:vanmeeuwen:branches:Kolab:Development mod_nss`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development mod_nss -F -` << EOF
    <package name="mod_nss">
        <title>Mozilla SSL/TLS module for the Apache HTTP server</title>
        <description>
            The mod_nss module provides strong cryptography for the Apache Web
            server via the Secure Sockets Layer (SSL) and Transport Layer
            Security (TLS) protocols using the Network Security Services (NSS)
            security library.
        </description>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
        </build>
    </package>
    EOF

.. include:: packages/mod_nss.txt

mozldap
=======

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development mozldap -F -` << EOF
    <package name="mozldap">
        <title>mozldap</title>
        <description></description>
        <url>http://kolab.org/about/mozldap</url>
        <build>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
        </build>
    </package>
    EOF

.. include:: packages/mozldap.txt

perl-Mozilla-LDAP
=================

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras perl-Mozilla-LDAP \\
        home:vanmeeuwen:branches:Kolab:Development perl-Mozilla-LDAP`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development perl-Mozilla-LDAP -F -` << EOF
    <package name="perl-Mozilla-LDAP">
        <title>LDAP Perl module that wraps the Mozilla C SDK</title>
        <description></description>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Debian_7.0"/>
            <disable repository="UCS_3.1"/>
            <disable repository="UCS_3.0"/>
            <disable repository="Debian_6.0"/>
        </build>
    </package>
    EOF

.. include:: packages/perl-Mozilla-LDAP.txt

php-pear-Auth-SASL
==================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-Auth-SASL -F -` << EOF
    <package name="php-pear-Auth-SASL">
        <title>php-pear-Auth-SASL</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-Auth-SASL</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-Auth-SASL.txt

php-pear-DB
===========

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-DB -F -` << EOF
    <package name="php-pear-DB">
        <title>php-pear-DB</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-DB</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-DB.txt

php-pear-HTTP-Request2
======================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-HTTP-Request2 -F -` << EOF
    <package name="php-pear-HTTP-Request2">
        <title>php-pear-HTTP-Request2</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-HTTP-Request2</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-HTTP-Request2.txt

php-pear-MDB2
=============

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-MDB2 -F -` << EOF
    <package name="php-pear-MDB2">
        <title>php-pear-MDB2</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-MDB2</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-MDB2.txt

php-pear-MDB2-Driver-mysqli
===========================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-MDB2-Driver-mysqli -F -` << EOF
    <package name="php-pear-MDB2-Driver-mysqli">
        <title>php-pear-MDB2-Driver-mysqli</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-MDB2-Driver-mysqli</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-MDB2-Driver-mysqli.txt

php-pear-Mail-Mime
==================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-Mail-Mime -F -` << EOF
    <package name="php-pear-Mail-Mime">
        <title>php-pear-Mail-Mime</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-Mail-Mime</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-Mail-Mime.txt

php-pear-Mail-mimeDecode
========================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-Mail-mimeDecode -F -` << EOF
    <package name="php-pear-Mail-mimeDecode">
        <title>php-pear-Mail-mimeDecode</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-Mail-mimeDecode</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-Mail-mimeDecode.txt

php-pear-Net-IDNA2
==================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-Net-IDNA2 -F -` << EOF
    <package name="php-pear-Net-IDNA2">
        <title>php-pear-Net-IDNA2</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-Net-IDNA2</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-Net-IDNA2.txt

php-pear-Net-LDAP2
==================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-Net-LDAP2 -F -` << EOF
    <package name="php-pear-Net-LDAP2">
        <title>php-pear-Net-LDAP2</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-Net-LDAP2</url>
        <build>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-Net-LDAP2.txt

php-pear-Net-SMTP
=================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-Net-SMTP -F -` << EOF
    <package name="php-pear-Net-SMTP">
        <title>php-pear-Net-SMTP</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-Net-SMTP</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-Net-SMTP.txt

php-pear-Net-Socket
===================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php-pear-Net-Socket -F -` << EOF
    <package name="php-pear-Net-Socket">
        <title>php-pear-Net-Socket</title>
        <description></description>
        <url>http://kolab.org/about/php-pear-Net-Socket</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/php-pear-Net-Socket.txt

python-icalendar
================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development python-icalendar -F -` << EOF
    <package name="python-icalendar">
        <title>python-icalendar</title>
        <description></description>
        <url>http://kolab.org/about/python-icalendar</url>
        <build>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
        </build>
    </package>
    EOF

.. include:: packages/python-icalendar.txt

python-ldap
===========

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development python-ldap -F -` << EOF
    <package name="python-ldap">
        <title>python-ldap</title>
        <description></description>
        <url>http://kolab.org/about/python-ldap</url>
        <build>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="openSUSE_12.1"/>
            <disable repository="openSUSE_12.2"/>
            <disable repository="openSUSE_12.3"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/python-ldap.txt

python-pyasn1
=============

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development python-pyasn1 -F -` << EOF
    <package name="python-pyasn1">
        <title>python-pyasn1</title>
        <description></description>
        <url>http://kolab.org/about/python-pyasn1</url>
        <build>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/python-pyasn1.txt

python-pyasn1-modules
=====================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development python-pyasn1-modules -F -` << EOF
    <package name="python-pyasn1-modules">
        <title>python-pyasn1-modules</title>
        <description></description>
        <url>http://kolab.org/about/python-pyasn1-modules</url>
        <build>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/python-pyasn1-modules.txt

pytz
====

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development pytz -F -` << EOF
    <package name="pytz">
        <title>pytz</title>
        <description></description>
        <url>http://kolab.org/about/pytz</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_6.0"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
            <disable repository="UCS_3.0"/>
            <disable repository="UCS_3.1"/>
        </build>
    </package>
    EOF

.. include:: packages/pytz.txt

svrcore
=======

Originally copied from the openSUSE OBS, after which Debian Sid sources have
been added for Squeeze/Wheezy:

.. parsed-literal::

    # :command:`osc -A https://api.opensuse.org copypac \\
        --expand \\
        -t https://obs.kolabsys.com:444 \\
        --client-side-copy \\
        server:Kolab:Extras svrcore \\
        home:vanmeeuwen:branches:Kolab:Development svrcore`

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development svrcore -F -` << EOF
    <package name="svrcore">
        <title>Secure PIN handling using NSS crypto</title>
        <description>
            svrcore provides applications with several ways to handle secure PIN
            storage e.g. in an application that must be restarted, but needs the
            PIN to unlock the private key and other crypto material, without
            user intervention. svrcore uses the facilities provided by NSS.
        </description>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_19"/>
            <disable repository="Fedora_18"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
            <disable repository="Ubuntu_13.10"/>
        </build>
    </package>
    EOF

.. include:: packages/svrcore.txt

swig2.0
=======

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development swig2.0 -F -` << EOF
    <package name="swig2.0">
        <title>swig2.0</title>
        <description></description>
        <url>http://kolab.org/about/swig2.0</url>
        <build>
            <disable/>
            <enable repository="Debian_6.0"/>
            <enable repository="UCS_3.0"/>
            <enable repository="UCS_3.1"/>
            <enable repository="openSUSE_12.1"/>
            <enable repository="openSUSE_12.2"/>
            <enable repository="openSUSE_12.3"/>
            <enable repository="Ubuntu_13.10"/>

            <disable repository="CentOS_6"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
            <disable repository="Ubuntu_12.04"/>
            <disable repository="Ubuntu_12.10"/>
            <disable repository="Ubuntu_13.04"/>
        </build>
    </package>
    EOF

.. include:: packages/swig2.0.txt

xsd
===

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development xsd -F -` << EOF
    <package name="xsd">
        <title>xsd</title>
        <description>
            W3C XML Schema to C++ translator, needed for libkolabxml.
        </description>
        <url>http://www.codesynthesis.com/projects/xsd</url>
        <build>
            <disable/>
            <enable repository="Debian_6.0"/>
            <enable repository="UCS_3.0"/>
            <enable repository="UCS_3.1"/>
            <enable repository="openSUSE_12.1"/>
        </build>
    </package>
    EOF

.. include:: packages/xsd.txt
