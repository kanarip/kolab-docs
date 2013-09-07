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

kolab
--------------

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

libcalendaring
--------------

.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development libcalendaring -F -` << EOF
    <package name="libcalendaring">
        <title>libcalendaring</title>
        <description>Frankenstein module to avoid dependencies on most of KDE</description>
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

xsd
---
.. parsed-literal::

    # :command:`osc meta pkg Kolab:Development xsd -F -` << EOF
    <package name="xsd">
        <title>xsd</title>
        <description>Needed on Debian 6.0 (Squeeze) based distributions for libkolabxml</description>
        <url>http://www.codesynthesis.com/projects/xsd</url>
        <build>
            <disable repository="CentOS_6"/>
            <disable repository="Debian_7.0"/>
            <disable repository="Fedora_17"/>
            <disable repository="Fedora_18"/>
            <disable repository="Fedora_19"/>
        </build>
    </package>
    EOF
