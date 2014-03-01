==============
Extra Packages
==============

drbd
====

glusterfs
=========

.. _packages-extras-httpd:

httpd
=====

Version 2.4 or later is required for :term:`Perfect Forward Secrecy`.

.. WARNING::

    This package is shipped exclusively for Kolab 13 Enterprise.

    For the **httpd** (*apache2*) package for Debian Wheezy, see
    :ref:`packages-dependencies-httpd`.

.. parsed-literal::

    # :command:`osc meta pkg Kolab:13 httpd -F -` << EOF
    <package name="httpd">
        <title>httpd</title>
        <description></description>
        <url>http://kolab.org/about/httpd</url>
        <build>
            <disable/>
            <enable repository="CentOS_6"/>
        </build>
    </package>
    EOF

.. rubric:: See Also

*   :ref:`packages-extras-openssl` (Build dependency)
*   :ref:`packages-dependencies-apr` (Build dependency)
*   :ref:`packages-dependencies-apr-util` (Build dependency)

.. include:: packages/httpd.txt

.. _packages-extras-mysql:

mysql
=====

.. parsed-literal::

    # :command:`osc meta pkg Kolab:13 mysql -F -` << EOF
    <package name="mysql">
        <title>mysql</title>
        <description></description>
        <url>http://mysql.com</url>
        <build>
            <disable/>
        </build>
    </package>
    EOF

.. include:: packages/nginx.txt

nginx
=====

The version of NGINX in Enterprise Linux 6 is rather outdated (1.0.15 at the
time of this writing).

.. parsed-literal::

    # :command:`osc meta pkg Kolab:13 nginx -F -` << EOF
    <package name="nginx">
        <title>nginx</title>
        <description></description>
        <url>http://kolab.org/about/nginx</url>
        <build>
            <disable/>
        </build>
    </package>
    EOF

.. include:: packages/nginx.txt

.. _packages-extras-openssl:

openssl
=======

Version 1.0.1 or later is required for :term:`Perfect Forward Secrecy`.

.. parsed-literal::

    # :command:`osc meta pkg Kolab:13 openssl -F -` << EOF
    <package name="openssl">
        <title>openssl</title>
        <description></description>
        <url>http://kolab.org/about/openssl</url>
        <build>
            <disable/>
        </build>
    </package>
    EOF

.. include:: packages/openssl.txt

.. _packages-extras-postfix:

postfix
=======

Postfix needs to be rebuilt against openssl-1.0.1e for Elliptic Curve encryption
capabilities.

.. parsed-literal::

    # :command:`osc meta pkg Kolab:13 postfix -F -` << EOF
    <package name="postfix">
        <title>postfix</title>
        <description></description>
        <url>http://kolab.org/about/postfix</url>
        <build>
            <disable/>
        </build>
    </package>
    EOF

.. include:: packages/postfix.txt

.. _packages-extras-php:

php
===

*   Needs rebuild against :ref:`packages-extras-httpd`
*   Needs rebuild against :ref:`packages-extras-openssl`
*   Needs rebuild against :ref:`packages-extras-mysql`

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

.. include:: packages/php.txt

roundcubemail-plugin-contextmenu
================================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-contextmenu -F -` << EOF
    <package name="roundcubemail-plugin-contextmenu">
        <title>roundcubemail-plugin-contextmenu</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-contextmenu</url>
    </package>
    EOF

.. include:: packages/roundcubemail-plugin-contextmenu.txt

roundcubemail-plugin-composeaddressbook
=======================================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-composeaddressbook -F -` << EOF
    <package name="roundcubemail-plugin-composeaddressbook">
        <title>roundcubemail-plugin-composeaddressbook</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-composeaddressbook</url>
    </package>
    EOF

.. include:: packages/roundcubemail-plugin-composeaddressbook.txt

roundcubemail-plugin-dblog
==========================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-dblog -F -` << EOF
    <package name="roundcubemail-plugin-dblog">
        <title>roundcubemail-plugin-dblog</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-dblog</url>
    </package>
    EOF

.. include:: packages/roundcubemail-plugin-dblog.txt

roundcubemail-plugin-importmessages
===================================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-importmessages -F -` << EOF
    <package name="roundcubemail-plugin-importmessages">
        <title>roundcubemail-plugin-importmessages</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-importmessages</url>
    </package>
    EOF

.. include:: packages/roundcubemail-plugin-importmessages.txt

roundcubemail-plugin-terms
==========================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-terms -F -` << EOF
    <package name="roundcubemail-plugin-terms">
        <title>roundcubemail-plugin-terms</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-terms</url>
    </package>
    EOF

.. include:: packages/roundcubemail-plugin-terms.txt

roundcubemail-plugin-threading_as_default
=========================================

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development roundcubemail-plugin-threading_as_default -F -` << EOF
    <package name="roundcubemail-plugin-threading_as_default">
        <title>roundcubemail-plugin-threading_as_default</title>
        <description></description>
        <url>http://kolab.org/about/roundcubemail-plugin-threading_as_default</url>
    </package>
    EOF

.. include:: packages/roundcubemail-plugin-threading_as_default.txt
