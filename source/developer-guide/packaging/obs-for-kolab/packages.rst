========
Packages
========

Packages come in three categories:

#.  Software for which the Kolab Groupware community is upstream;

    These packages we tend to build for all platforms.

#.  So-called "meta-packages" for ease of installation;

    These packages we tend to build for all platforms.

#.  Additional dependencies not supplied by or out-dated in the base platform;

    These packages we strive to keep to an absolute minimum.

We tend to create packages disabled for all repositories by default, and
therefore each package creation includes a segment by default:

.. parsed-literal::

    <build>
        <disable/>
    </build>

389-admin
---------

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

389-admin-console
-----------------

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

389-adminutil
-------------

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

389-console
-----------

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

389-ds-base
-----------

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

389-ds-console
--------------

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

389-dsgw
--------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development 389-dsgw -F -` << EOF
    <package name="389-dsgw">
        <title>389-dsgw</title>
        <description>389-dsgw</description>
        <url>http://www.port389.org</url>
        <build>
            <disable/>
        </build>
    </package>
    EOF

apr
---

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

apr-util
--------

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

chwala
------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development chwala -F -` << EOF
    <package name="chwala">
        <title>chwala</title>
        <description>
            Kolab Groupware Integrated File Storage Interfaces
        </description>
        <url>http://chwala.org</url>
    </package>
    EOF

cyrus-imapd
-----------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development cyrus-imapd -F -` << EOF
    <package name="cyrus-imapd">
        <title>cyrus-imapd</title>
        <description>Cyrus IMAP server</description>
        <url>http://www.cyrusimap.org</url>
    </package>
    EOF

httpd
-----

Version 2.4 or later is required for :term:`Perfect Forward Secrecy`.

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development httpd -F -` << EOF
    <package name="httpd">
        <title>httpd</title>
        <description></description>
        <url>http://kolab.org/about/httpd</url>
        <build>
            <disable/>
        </build>
    </package>
    EOF

idm-console-framework
---------------------

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

iRony
------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development iRony -F -` << EOF
    <package name="iRony">
        <title>iRony</title>
        <description>
            DAV Access Provider for Kolab Groupware
        </description>
        <url>http://kolab.org/about/iRony</url>
    </package>
    EOF

jansson
-------

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

jss
---

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

kolab
-----

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development kolab -F -` << EOF
    <package name="kolab">
        <title>kolab</title>
        <description></description>
        <url>http://kolab.org/about/kolab</url>
    </package>
    EOF

kolab-freebusy
--------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development kolab-freebusy -F -` << EOF
    <package name="kolab-freebusy">
        <title>kolab-freebusy</title>
        <description></description>
        <url>http://kolab.org/about/kolab-freebusy</url>
    </package>
    EOF

kolab-webadmin
--------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development kolab-webadmin -F -` << EOF
    <package name="kolab-webadmin">
        <title>kolab-webadmin</title>
        <description></description>
        <url>http://kolab.org/about/kolab-webadmin</url>
    </package>
    EOF

kolab-syncroton
---------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development kolab-syncroton -F -` << EOF
    <package name="kolab-syncroton">
        <title>kolab-syncroton</title>
        <description></description>
        <url>http://kolab.org/about/kolab-syncroton</url>
    </package>
    EOF

kolab-utils
-----------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development kolab-utils -F -` << EOF
    <package name="kolab-utils">
        <title>kolab-utils</title>
        <description></description>
        <url>http://kolab.org/about/kolab-utils</url>
    </package>
    EOF

ldapjdk
-------

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

libcalendaring
--------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development libcalendaring -F -` << EOF
    <package name="libcalendaring">
        <title>libcalendaring</title>
        <description>
            Frankenstein module to avoid dependencies on most of KDE
        </description>
        <url>http://kolab.org/about/libcalendaring</url>
    </package>
    EOF

libkolab
--------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development libkolab -F -` << EOF
    <package name="libkolab">
        <title>libkolab</title>
        <description></description>
        <url>http://kolab.org/about/libkolab</url>
    </package>
    EOF

libkolabxml
-----------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development libkolabxml -F -` << EOF
    <package name="libkolabxml">
        <title>libkolabxml</title>
        <description></description>

        <url>http://kolab.org/about/libkolabxml</url>
    </package>
    EOF

mod_nss
-------

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

mozldap
-------

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

nginx
-----

The version of NGINX in Enterprise Linux 6 is rather outdated (1.0.15 at the
time of this writing).

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development nginx -F -` << EOF
    <package name="nginx">
        <title>nginx</title>
        <description></description>
        <url>http://kolab.org/about/nginx</url>
        <build>
            <disable/>
        </build>
    </package>
    EOF

openssl
-------

Version 1.0.1 or later is required for :term:`Perfect Forward Secrecy`.

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development openssl -F -` << EOF
    <package name="openssl">
        <title>openssl</title>
        <description></description>
        <url>http://kolab.org/about/openssl</url>
        <build>
            <disable/>
        </build>
    </package>
    EOF

perl-Mozilla-LDAP
-----------------

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

php
---

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development php -F -` << EOF
    <package name="php">
        <title>php</title>
        <description></description>
        <url>http://kolab.org/about/php</url>
        <build>
            <disable repository="CentOS_6"/>
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

php-pear-Auth-SASL
------------------

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

php-pear-DB
-----------

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

php-pear-HTTP-Request2
----------------------

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

php-pear-MDB2
-------------

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

php-pear-MDB2-Driver-mysqli
---------------------------

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

php-pear-Mail-Mime
------------------

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

php-pear-Mail-mimeDecode
------------------------

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

php-pear-Net-IDNA2
------------------

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

php-pear-Net-LDAP2
------------------

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

php-pear-Net-SMTP
-----------------

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

php-pear-Net-Socket
-------------------

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

pykolab
-------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development pykolab -F -` << EOF
    <package name="pykolab">
        <title>pykolab</title>
        <description></description>
        <url>http://kolab.org/about/pykolab</url>
    </package>
    EOF

python-icalendar
----------------

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

python-ldap
----------------

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

python-pyasn1
-------------

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

pytz
----

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

roundcubemail
-------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail -F -` << EOF
    <package name="roundcubemail">
        <title>roundcubemail</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail</url>
    </package>
    EOF

roundcubemail-plugin-contextmenu
--------------------------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-contextmenu -F -` << EOF
    <package name="roundcubemail-plugin-contextmenu">
        <title>roundcubemail-plugin-contextmenu</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-contextmenu</url>
    </package>
    EOF

roundcubemail-plugin-composeaddressbook
---------------------------------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-composeaddressbook -F -` << EOF
    <package name="roundcubemail-plugin-composeaddressbook">
        <title>roundcubemail-plugin-composeaddressbook</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-composeaddressbook</url>
    </package>
    EOF

roundcubemail-plugin-dblog
--------------------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-dblog -F -` << EOF
    <package name="roundcubemail-plugin-dblog">
        <title>roundcubemail-plugin-dblog</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-dblog</url>
    </package>
    EOF

roundcubemail-plugin-terms
--------------------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-terms -F -` << EOF
    <package name="roundcubemail-plugin-terms">
        <title>roundcubemail-plugin-terms</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-terms</url>
    </package>
    EOF

roundcubemail-plugin-threading_as_default
-----------------------------------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-threading_as_default -F -` << EOF
    <package name="roundcubemail-plugin-threading_as_default">
        <title>roundcubemail-plugin-threading_as_default</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-threading_as_default</url>
    </package>
    EOF

roundcubemail-plugins-kolab
---------------------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugins-kolab -F -` << EOF
    <package name="roundcubemail-plugins-kolab">
        <title>roundcubemail-plugins-kolab</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugins-kolab</url>
    </package>
    EOF

svrcore
-------

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

swig2.0
-------

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

xsd
---

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
