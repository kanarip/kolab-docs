================================
HOWTO: Secure all Kolab Services
================================

This HOWTO is based on Centos 6.4.

The configuration on Debian(-based distributions) is similar, but the base path
for the certifcates storage is different, and Debian already has a group called
``ssl-cert`` to which the user accounts for applications like Cyrus IMAP or
Postfix are added by default.

On CentOS, this group is called ``mail``.

Prerequisites
=============

Prepare your certificates! You'll need your certificate, your key, the CA and
intermediate CA certificates. This tutorial is based on the StartCom SSL CA.
Feel free to use any other Certificate Authority to your liking.

In this case the certificate is a wildcard \*.example.org certificate, which
makes it easier to cover various hostnames (like ``smtp.example.org``,
``imap.example.org`` and ``webmail.example.org``).

#.  Copy your personal SSL certificates on your new Kolab server.

    On Debian the default location is :filename:`/etc/ssl/` instead of
    :filename:`/etc/pki/tls/`.

    .. parsed-literal::

        # :command:`scp example.org.key kolab.example.org:/etc/pki/tls/private/`
        # :command:`scp example.org.crt kolab.example.org:/etc/pki/tls/certs/`

#.  You should have obtained a CA certificate or CA certificate chain from your
    SSL certificate issuer.

    If you have not, obtain the root and chain certificates from your
    certification authority. Make sure the source of the certificate is
    verifiable and trusted.

    For example:

    .. parsed-literal::

        # :command:`wget https://www.startssl.com/certs/ca.pem \\
            -O /etc/pki/tls/certs/startcom-ca.pem`

        # :command:`wget https://www.startssl.com/certs/sub.class2.server.ca.pem \\
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

#.  Add an SSL group. Only members of this group should be able to access your
    private key, etc.

    On Debian the usergroup is not needed.

    .. parsed-literal::

        # :command:`chmod 640 /etc/pki/tls/private/* \\
            /etc/pki/tls/certs/*`

        # :command:`chown root:mail /etc/pki/tls/private/example.org.key`

#.  Add the CA to system's CA bundle.

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

#.  Configure SSL certificates

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

Apache offers 2 modules that provide SSL support. The wildly used **mod_ssl**,
and **mod_nss**. Since **mod_nss** was already installed and loaded through some
dependency I'll cover this. Feel free to use **mod_ssl**.

mod_nss
^^^^^^^

I configures mod_nss because it was already installed. If you prefer mod_ssl nobody stops you.

#.  Import your CA into NSS Cert Database for Apache

    .. parsed-literal::

        # :command:`certutil -d /etc/httpd/alias -A  -t "CT,," \\
            -n "StartCom Certification Authority" \\
            -i /etc/pki/tls/certs/startcom-ca.pem`

#.  Convert and import your personal certificate into NSS DB

    .. parsed-literal::

        # :command:`openssl pkcs12 -export \\
            -in /etc/pki/tls/certs/example.org.crt \\
            -inkey /etc/pki/tls/private/example.org.key \\
            -out /tmp/example.p12 -name Server-Cert -passout pass:foo`

        # :command:`echo "foo" > /tmp/foo`
        # :command:`pk12util -i /tmp/example.p12 -d /etc/httpd/alias -w /tmp/foo -k /dev/null`
        # :command:`rm /tmp/foo`
        # :command:`rm /tmp/example.p12`

#.  You should now be able to see all the imported certificates

    .. parsed-literal::

        # :command:`certutil -L -d /etc/httpd/alias`
        # :command:`certutil -V -u V -d /etc/httpd/alias -n "Server-Cert"`

#.  Move mod_nss from port 8443 to 443 and configure the certificate that
    mod_nss should use.

    .. parsed-literal::

        # :command:`sed -i -e 's/8443/443/' /etc/httpd/conf.d/nss.conf`
        # :command:`sed -i -e 's/NSSNickname.*/NSSNickname Server-Cert/' \\
            /etc/httpd/conf.d/nss.conf`

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

There're enough tutorials out there if you want to configure **mod_ssl** on your
Apache. Maybe you want to take a look on the nginx configuration as well.

389 Directory Server
--------------------

If you really want/need you can also add SSL support to your LDAP Server

#.  First you must import your PEM File into the certutil certificate store
    (identical to Apache with **mod_nss**)

    .. parsed-literal::

        # :command:`certutil -d /etc/dirsrv/slapd-kolab/ -A  -t "CT,," \\
            -n "StartCom Certification Authority" \\
            -i /etc/pki/tls/certs/startcom-ca.pem`

        # :command:`openssl pkcs12 -export \\
            -in /etc/pki/tls/certs/example.org.crt \\
            -inkey /etc/pki/tls/private/example.org.key \\
            -out /tmp/example.p12 -name Server-Cert -passout pass:foo`

        # :command:`echo "foo" > /tmp/foo`
        # :command:`pk12util -i /tmp/example.p12 -d /etc/dirsrv/slapd-kolab/ \\
            -w /tmp/foo -k /dev/null`
        # :command:`rm /tmp/foo`
        # :command:`rm /tmp/example.p12`

#.  Enable SSL Support

    Since all the configuration for 389ds is being done live, changing and adding SSL support will require some LDAP commands to modify the server configuration.

    .. parsed-literal::

        # :command:`passwd=$(grep ^bind_pw /etc/kolab/kolab.conf | cut -d '=' -f2- | sed -e 's/\s*//g')`
        # :command:`ldapmodify -x -h localhost -p 389 \\
            -D "cn=Directory Manager" -w "${passwd}" << EOF
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

#.  Next, restart the LDAP service:

    .. parsed-literal::

        # :command:`service dirsrv restart`

#.  You can test if your LDAP over SSL is configured correctly via the
    ``openssl s_client -connect localhost:636`` command, or just making a query
    using ``ldapsearch``:

    Test non-SSL connection

    .. parsed-literal::

        # :command:`ldapsearch -x -H ldap://kolab.example.org \\
            -b "cn=kolab,cn=config" -D "cn=Directory Manager" \\
            -w "${passwd}"`

    Test SSL connection

    .. parsed-literal::

        # :command:`ldapsearch -x -H ldaps://kolab.example.org \\
            -b "cn=kolab,cn=config" -D "cn=Directory Manager" \\
            -w "${passwd}"`

Kolab Components
================

kolab-cli
---------

With the HTTP Service configured to force SSL communication you must add/update
your kolab-cli API url.

    .. parsed-literal::

        # :command:`sed -r -i \\
              -e '/api_url/d' \\
              -e "s#\\[kolab_wap\\]#[kolab_wap]\\napi_url = https://kolab.example.org/kolab-webadmin/api#g" \\
              /etc/kolab/kolab.conf`

Roundcube/Plugins
-----------------

Set correct SSL parameters for HTTP_Request2. This will ensure the
``kolab_files`` plugin and Chwala can talk over HTTPS.

#.  Remove old-style SSL configuration parameters

    .. parsed-literal::

        # :command:`sed -i -e '/kolab_ssl/d' /etc/roundcubemail/libkolab.inc.php`

#.  Change Chwala API url in the ``kolab_files`` plugin configuration:

    .. parsed-literal::

        # :command:`sed -i -e 's/http:/https:/' /etc/roundcubemail/kolab_files.inc.php`

#.  Lets remove the php-close tag line as a quick hack to make it easier for us
    to extend the :file:`/etc/roundcubemail/config.inc.php`:

    .. parsed-literal::

        # :command:`sed -i -e '/^\?>/d' /etc/roundcubemail/config.inc.php`

#.  Enable SSL verification against our extended CA bundle.

    .. parsed-literal::

        # :command:`cat >> /etc/roundcubemail/config.inc.php << EOF
        \\$config['kolab_http_request'] = array(
                'ssl_verify_peer'       => true,
                'ssl_verify_host'       => true,
                'ssl_cafile'            => '/etc/pki/tls/certs/ca-bundle.crt'
        );
        EOF`

#.  Tell the webclient the SSL iRony URLs for CalDAV and CardDAV:

    .. parsed-literal::

        # :command:`cat >> /etc/roundcubemail/config.inc.php << EOF
        # caldav/webdav
        \\$config['calendar_caldav_url']             = "https://kolab.example.org/iRony/calendars/%u/%i";
        \\$config['kolab_addressbook_carddav_url']   = 'https://kolab.example.org/iRony/addressbooks/%u/%i';
        EOF`

