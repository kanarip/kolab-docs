================================
HOWTO: Secure all Kolab Services
================================

This howto is based on Centos 6.4. The configuration on Debian is similar, just
the base path for the certifcates storage is a different one and that Debian
already has a group called ssl-cert where applications like cyrus or postfix
are added by default.

Prerequirements
===============

Prepare your certificates! You'll need your certificate, your key, the CA and
intermediate CA certificates. This tutorial is based on the StartCom SSL CA.
Feel free to use any other Certificate Authority to your liking.

In this case the certificate is a wildcard \*.example.org certificate, which
makes it easier to cover various hostnames (like smtp.example.org imap.example.org
webmail.example.org).

#.  Transfer/Copy your personal ssl certificates on your new kolab server.

    On Debian the default location is /etc/ssl/ instead of /etc/pki/tls/

    .. parsed-literal::

        # :command:`scp example.org.key kolab.example.org:/etc/pki/tls/private/`
        # :command:`scp example.org.crt kolab.example.org:/etc/pki/tls/certs/`

#.  Download root and chain certificates from your certification auhority.

    .. parsed-literal::

        # :command:`wget --no-check-certificate https://www.startssl.com/certs/ca.pem \\
            -O /etc/pki/tls/certs/startcom-ca.pem`
        # :command:`wget --no-check-certificate https://www.startssl.com/certs/sub.class2.server.ca.pem \\
            -O /etc/pki/tls/certs/startcom-sub.class2.server.ca.pem`

#.  Lets build some bundle files we can use later

    .. parsed-literal::

        # :command:`cat /etc/pki/tls/certs/example.org.crt \\
              /etc/pki/tls/private/example.org.key \\
              /etc/pki/tls/certs/startcom-sub.class2.server.ca.pem \\
              /etc/pki/tls/certs/startcom-ca.pem \\
              > /etc/pki/tls/private/example.org.bundle.pem`
        # :command:`cat /etc/pki/tls/certs/startcom-ca.pem \\
              /etc/pki/tls/certs/startcom-sub.class2.server.ca.pem \\
              > /etc/pki/tls/certs/example.org.ca-chain.pem`

#.  Add a ssl group. Only members of this group should be able to access your private key, etc.

    On Debian the usergroup is not needed.

    .. parsed-literal::

        # :command:`groupadd ssl`
        # :command:`chmod 640 /etc/pki/tls/private/*`
        # :command:`chown root:ssl /etc/pki/tls/private/*`

#.  Add you CA to system cabundle

    Other applications and scripts that want to communicate via SSL should point
    to the cabundle in case they want check if your own certificate is trusted.

    For RedHat/Centos based systems:

    .. parsed-literal::

        # :command:`cat /etc/pki/tls/certs/startcom-ca.pem >> /etc/pki/tls/certs/ca-bundle.crt`

    On Debian based systems it's even easier. The command update-ca-certificates takes
    care of the ca-bundle file.

    .. parsed-literal::

        # :command:`cp /etc/ssl/private/startcom-ca.pem /usr/local/share/ca-certificates/startcom-ca.crt`
        # :command:`update-ca-certificates`


Applications
============

Cyrus IMAPD
-----------

#.  Allow cyrus user to access the ssl certificate

    .. parsed-literal::

        # :command:`usermod -G saslauth,ssl cyrus`

#.  Configure ssl certificates

    .. parsed-literal::

        # :command:`sed -r -i \\
              -e 's|^tls_cert_file:.*|tls_cert_file: /etc/pki/tls/certs/example.org.crt|g' \\
              -e 's|^tls_key_file:.*|tls_key_file: /etc/pki/tls/private/example.org.key|g' \\
              -e 's|^tls_ca_file:.*|tls_ca_file: /etc/pki/tls/certs/example.org.ca-chain.pem|g' \\
              /etc/imapd.conf`

#.  Restart and verify

    .. parsed-literal::

        # :command:`service cyrus-imapd restart`
        # :command:`openssl s_client -showcerts -connect localhost:993`

Postfix
-------

#.  Allow postfix user to access the ssl certificate

    .. parsed-literal::

        # :command:`usermod -G mail,ssl postfix`

#.  Configure SSL certificates

    .. parsed-literal::

        # :command:`postconf -e smtpd_tls_key_file=/etc/pki/tls/private/example.org.key`
        # :command:`postconf -e smtpd_tls_cert_file=/etc/pki/tls/certs/example.org.crt`
        # :command:`postconf -e smtpd_tls_CAfile=/etc/pki/tls/certs/example.org.ca-chain.pem`

#.  Restart

    .. parsed-literal::

        # :command:`service postfix restart`

Apache
------

Apache offers 2 modules that provide SSL support. The wildly used mod_ssl and
mod_nss. Since mod_nss was already installed and loaded through some dependency
I'll cover this. Feel free to use mod_ssl.

mod_nss
^^^^^^^

I configures mod_nss because it was already installed. If you prefer mod_ssl nobody stops you.

#.  Import your CA into NSS Cert Database for Apache

    .. parsed-literal::

        # :command:`certutil -d /etc/httpd/alias -A  -t "CT,," -n "StartCom Certification Authority" \\
            -i /etc/pki/tls/certs/startcom-ca.pem`

#.  Convert and import your personal certificate into NSS DB

    .. parsed-literal::

        # :command:`openssl pkcs12 -export -in /etc/pki/tls/certs/example.org.crt -inkey /etc/pki/tls/private/example.org.key \\
            -out /tmp/example.p12 -name Server-Cert -passout pass:foo`
        # :command:`echo "foo" > /tmp/foo`
        # :command:`pk12util -i /tmp/example.p12 -d /etc/httpd/alias -w /tmp/foo -k /dev/null`
        # :command:`rm /tmp/foo`
        # :command:`rm /tmp/example.p12`

#.  You should now be able to see all the imported certificates

    .. parsed-literal::

        # :command:`certutil -L -d /etc/httpd/alias`
        # :command:`certutil -V -u V -d /etc/httpd/alias -n "Server-Cert"`

#.  Move mod_nss from port 8443 to 443 and set the certificate which mod_nss should use.

    .. parsed-literal::

        # :command:`sed -i -e 's/8443/443/' /etc/httpd/conf.d/nss.conf`
        # :command:`sed -i -e 's/NSSNickname.*/NSSNickname Server-Cert/' /etc/httpd/conf.d/nss.conf`

#.  Create a vhost for http (:80) to redirect everything to https

    .. parsed-literal::

        # :command:`cat >> /etc/httpd/conf/httpd.conf << EOF

        <VirtualHost _default_:80>
            RewriteEngine On
            RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R=301,L]
        </VirtualHost>
        EOF`

#.  Restart and verify

    .. parsed-literal::

        # :command:`service httpd restart`
        # :command:`openssl s_client -showcerts -connect localhost:443`

mod_ssl
^^^^^^^

There're enough tutorials out there if you want to configure mod_ssl on your apacher.
Maybe you want to take a look on the nginx configuration as well.

389 Directory Server
--------------------

If you really want/need you can also add SSL support to your LDAP Server

#.  First you must import your PEM File into the certutil certificate store (identical to apache with mod_nss)

    .. parsed-literal::

        # :command:`certutil -d /etc/dirsrv/slapd-kolab/ -A  -t "CT,," -n "StartCom Certification Authority" \\
            -i /etc/pki/tls/certs/startcom-ca.pem`
        # :command:`openssl pkcs12 -export -in /etc/pki/tls/certs/example.org.crt -inkey /etc/pki/tls/private/example.org.key \\
            -out /tmp/example.p12 -name Server-Cert -passout pass:foo`
        # :command:`echo "foo" > /tmp/foo`
        # :command:`pk12util -i /tmp/example.p12 -d /etc/dirsrv/slapd-kolab/ -w /tmp/foo -k /dev/null`
        # :command:`rm /tmp/foo`
        # :command:`rm /tmp/example.p12`

#.  Enable SSL Support

    Since all the configuration for 389ds is being done live, changing and adding ssl support will require some LDAP commands to modify the server configuration.

    .. parsed-literal::

        # :command:`ldapmodify -x -h localhost -p 389 -D "cn=Directory Manager" -w "$(grep ^bind_pw /etc/kolab/kolab.conf | cut -d ' ' -f3-)" << EOF
        dn: cn=encryption,cn=config
        changetype: modify
        replace: nsSSL3
        nsSSL3: on
        -
        replace: nsSSLClientAuth
        nsSSLClientAuth: allowed
        -
        add: nsSSL3Ciphers
        nsSSL3Ciphers: -rsa_null_md5,+rsa_rc4_128_md5,+rsa_rc4_40_md5,+rsa_rc2_40_md5,
         +rsa_des_sha,+rsa_fips_des_sha,+rsa_3des_sha,+rsa_fips_3des_sha,+fortezza,
         +fortezza_rc4_128_sha,+fortezza_null,+tls_rsa_export1024_with_rc4_56_sha,
         +tls_rsa_export1024_with_des_cbc_sha

        dn: cn=config
        changetype: modify
        add: nsslapd-security
        nsslapd-security: on
        -
        replace: nsslapd-ssl-check-hostname
        nsslapd-ssl-check-hostname: off
        -
        replace: nsslapd-secureport
        nsslapd-secureport: 636

        dn: cn=RSA,cn=encryption,cn=config
        changetype: add
        objectclass: top
        objectclass: nsEncryptionModule
        cn: RSA
        nsSSLPersonalitySSL: Server-Cert
        nsSSLToken: internal (software)
        nsSSLActivation: on
        EOF`

#.  Now you can restart the service and test the new ssl support of your ldap server

    .. parsed-literal::

        # :command:`service dirsrv restart`

#.  You can test if your ldaps is configured correctly either via openssl s_client or just making a query via ldapsearch

    Test non-ssl connection

    .. parsed-literal::

        # :command:`ldapsearch -x -H ldap://kolab.example.org -b "cn=kolab,cn=config" -D "cn=Directory Manager" \\
            -w "$(grep ^bind_pw /etc/kolab/kolab.conf | cut -d ' ' -f3-)"`

    Test ssl connection

    .. parsed-literal::

        # :command:`ldapsearch -x -H ldaps://kolab.example.org -b "cn=kolab,cn=config" -D "cn=Directory Manager" \\
            -w "$(grep ^bind_pw /etc/kolab/kolab.conf | cut -d ' ' -f3-)"`

Kolab Components
================

kolab-cli
---------

With the HTTP Service configured to force ssl communication you must add/update
your kolab-cli api url.

    .. parsed-literal::

        # :command:`sed -r -i \\
              -e '/api_url/d' \\
              -e "s#\\[kolab_wap\\]#[kolab_wap]\\napi_url = https://kolab.example.org/kolab-webadmin/api#g" \\
              /etc/kolab/kolab.conf`

Roundcube/Plugins
-----------------

Set correct ssl parameters for HTTP_Request2. This will ensure the kolab_files and
chawla can talk via ssl.

#.  Remove old-style ssl configuration parameters

    .. parsed-literal::

        # :command:`sed -i -e '/kolab_ssl/d' /etc/roundcubemail/libkolab.inc.php`

#.  Change chwala api url in the kolab_files plugin

    .. parsed-literal::

        # :command:`sed -i -e 's/http:/https:/' /etc/roundcubemail/kolab_files.inc.php`

#.  Lets remove the php-close tag line as a quick hack to make it easier for us
    to extend the :file:`/etc/roundcube/config.inc.php`:

    .. parsed-literal::

        # :command:`sed -i -e '/^\?>/d' /etc/roundcubemail/config.inc.php`

#.  Enable SSL verification against our extended ca-bundle.

    .. parsed-literal::

        # :command:`cat >> /etc/roundcubemail/config.inc.php << EOF
        \\$config['kolab_http_request'] = array(
                'ssl_verify_peer'       => true,
                'ssl_verify_host'       => true,
                'ssl_cafile'            => '/etc/pki/tls/certs/ca-bundle.crt'
        );
        EOF`

#.  Tell the webclient the ssl irony urls for caldav and carddav

    .. parsed-literal::

        # :command:`cat >> /etc/roundcubemail/config.inc.php << EOF
        # caldav/webdav
        \\$config['calendar_caldav_url']             = "https://kolab.example.org/iRony/calendars/%u/%i";
        \\$config['kolab_addressbook_carddav_url']   = 'https://kolab.example.org/iRony/addressbooks/%u/%i';
        EOF`

