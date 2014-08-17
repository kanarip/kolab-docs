==================================
HOWTO: Use NGINX as the Web Server
==================================

This HOWTO consists of two separate approaches.

Simple Installation
===================

#.  Install NGINX and PHP FPM:

    .. parsed-literal::

        # :command:`yum -y install nginx php-fpm`

#.  Configure **php-fpm** to listen on a local UNIX socket:

    .. parsed-literal::

        # :command:`sed -r -i \\
            -e 's|^listen = 127\.0\.0\.1.*$|listen = /var/run/php-fpm/php-fpm.sock|g' \\
            /etc/php-fpm.d/www.conf`

#.  Replace the contents of :file:`/etc/nginx/conf.d/default.conf`:

    .. parsed-literal::

        # :command:`cat > /etc/nginx/conf.d/default.conf` << EOF
        server {
            listen              8080 default_server;

            server_name         localhost:8080;
            access_log          /var/log/nginx/kolab.example.org-access_log;
            error_log           /var/log/nginx/kolab.example.org-error_log;

            location /roundcubemail {
                alias //usr/share/roundcubemail;
                index index.php;
            }

            location ~ /roundcubemail/.*\\.php\\$ {
                if ($fastcgi_script_name ~ /roundcubemail(/.*\\.php)\\$) {
                    set $valid_fastcgi_script_name \\$1;
                }
                fastcgi_pass    unix:/var/run/php-fpm/php-fpm.sock;
                fastcgi_index   index.php;
                fastcgi_param   SCRIPT_FILENAME    /usr/share/roundcubemail\\$valid_fastcgi_script_name;
                include         fastcgi_params;
            }

            location /kolab-webadmin {
                alias //usr/share/kolab-webadmin/public_html;
                index index.php;
            }

        }
        EOF

#.  Start the **php-fpm** service and configure the service to start on boot:

    .. parsed-literal::

        # :command:`service php-fpm start`
        # :command:`chkconfig php-fpm on`

#.  Start the **nginx** service and configure the service to start on boot:

    .. parsed-literal::

        # :command:`service nginx start`
        # :command:`chkconfig nginx on`

More Complex Installation
=========================

.. WARNING::

    This HOWTO uses ports 8080 and 8443 as it is intended to demonstrate running
    Kolab Groupware under NGINX. Because of the use of ports not the standard
    ports for the related protocols, more changes are required to various
    configuration files.

    This creates a conflict with some mod_nss configuration for httpd, which (by
    default) is also configured to listen on port 8443. To correct this problem,
    issue the following commands:

    .. parsed-literal::

        # :command:`sed -i -e 's/^/#/g' /etc/httpd/conf.d/nss.conf`
        # :command:`service httpd reload`

#.  Install NGINX and PHP FPM:

    .. parsed-literal::

        # :command:`yum -y install nginx php-fpm`

#.  Remove the default **php-fpm** configuration:

    .. parsed-literal::

        # :command:`rm -rf /etc/php-fpm.d/www.conf`

#.  Create and set ownership on the following directories:

    *   :file:`/var/lib/nginx/fastcgi/`
    *   :file:`/var/lib/nginx/fastcgi/tmp/`

    .. parsed-literal::

        # :command:`mkdir -p /var/lib/nginx/fastcgi/tmp/`
        # :command:`chown -R nginx:nginx /var/lib/nginx/fastcgi/`
        # :command:`chmod 700 /var/lib/nginx/fastcgi/ \\
            /var/lib/nginx/fastcgi/tmp/`

#.  Replace the contents of :file:`/etc/nginx/conf.d/default.conf`:

    .. parsed-literal::

        # :command:`cat > /etc/nginx/conf.d/default.conf` << EOF
        fastcgi_cache_path /var/lib/nginx/fastcgi/ levels=1:2 keys_zone=kolab.example.org:16m max_size=256m inactive=1d;
        fastcgi_temp_path /var/lib/nginx/fastcgi/tmp 1 2;
        fastcgi_cache_key "\\$scheme\\$request_method\\$host\\$request_uri";
        fastcgi_cache_use_stale error timeout invalid_header http_500;

        server {
            listen                      8080 default_server;
            server_name                 kolab.example.org;
            rewrite                     ^ https://\\$server_name\\$request_uri permanent;  # enforce https
        }

        server {
            listen                      8443 ssl;
            server_name                 kolab.example.org;

            access_log                  /var/log/nginx/kolab.example.org-access_log;
            error_log                   /var/log/nginx/kolab.example.org-error_log;

            ssl                         on;
            ssl_certificate             /etc/pki/tls/certs/localhost.pem;
            ssl_certificate_key         /etc/pki/tls/certs/localhost.pem;

            open_file_cache             max=1024 inactive=1m;
            open_file_cache_valid       90s;
            open_file_cache_min_uses    2;

            fastcgi_param HTTPS on;
            fastcgi_keep_conn on;
            fastcgi_cache kolab.example.org;
            fastcgi_cache_valid 200 302 304 10m;
            fastcgi_cache_valid 301 1h;
            fastcgi_cache_min_uses 2;
            fastcgi_buffers 256 4k;
            fastcgi_busy_buffers_size 8k;
            fastcgi_temp_file_write_size 8k;

            ##
            ## Chwala
            ##
            location /chwala {
                index index.php;
                alias /usr/share/chwala/public_html;

                client_max_body_size 30M; # set maximum upload size

                # enable php
                location ~ \\.php\\$ {
                    include fastcgi_params;
                    fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_chwala.sock;
                    fastcgi_param SCRIPT_FILENAME \\$request_filename;
                    # Without this, PHPSESSION is replaced by webadmin-api X-Session-Token
                    fastcgi_param PHP_VALUE "session.auto_start=0
                        session.use_cookies=0";
                    fastcgi_pass_header X-Session-Token;
                }
            }

            ##
            ## iRony
            ##
            location /iRony {
                alias  /usr/share/iRony/public_html/index.php;

                client_max_body_size 30M; # set maximum upload size

                # Make Apple Calendar.app and Contacts.app happy:
                rewrite ^/.well-known/caldav / last;
                rewrite ^/.well-known/carddav / last;

                # If Nginx was built with http_dav_module:
                dav_methods  PUT DELETE MKCOL COPY MOVE; # PROPFIND;
                # Required Nginx to be built with nginx-dav-ext-module:
                dav_ext_methods PROPFIND OPTIONS;

                include fastcgi_params;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_iRony.sock;
                fastcgi_param SCRIPT_FILENAME \\$request_filename;
            }

            ##
            ## Kolab Webclient
            ##
            location /roundcubemail {
                index index.php;
                alias //usr/share/roundcubemail;

                client_max_body_size 30M; # set maximum upload size for mail attachments

                # Deny all attempts to access hidden files such as .htaccess, .htpasswd, .DS_Store (Mac).
                location ~ ^/roundcubemail/(README(.md)?|INSTALL|LICENSE|CHANGELOG|UPGRADING)\\$ {
                    deny all;
                }

                location ~ ^/roundcubemail/(bin|SQL|config|logs)/ {
                    deny all;
                }

                location ~ ^/roundcubemail/program/(include|lib|localization|steps)/ {
                    deny all;
                }

                # enable php
                location ~ \\.php\\$ {
                    include fastcgi_params;
                    fastcgi_split_path_info ^(.+\\.php)(/.*)\\$;
                    fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_roundcubemail.sock;
                    fastcgi_param SCRIPT_FILENAME \\$request_filename;
                }
            }

            ##
            ## Kolab Web Administration Panel (WAP) and API
            ##
            location /kolab-webadmin {
                index index.php;
                alias /usr/share/kolab-webadmin/public_html;
                try_files \\$uri \\$uri/ @kolab-wapapi;

                # enable php
                location ~ \\.php\\$ {
                    include fastcgi_params;
                    fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_kolab-webadmin.sock;
                    fastcgi_param SCRIPT_FILENAME \\$request_filename;
                    # Without this, PHPSESSION is replaced by webadmin-api X-Session-Token
                    fastcgi_param PHP_VALUE "session.auto_start=0
                        session.use_cookies=0";
                    fastcgi_pass_header X-Session-Token;
                }
            }

            # kolab-webadmin api
            location @kolab-wapapi {
                rewrite ^/kolab-webadmin/api/(.*)\\.(.*)\\$ /kolab-webadmin/api/index.php?service=\\$1&method=\\$2 last;
            }

            ##
            ## Kolab syncroton ActiveSync
            ##
            location /Microsoft-Server-ActiveSync {
                alias  /usr/share/kolab-syncroton/index.php;

                client_max_body_size 30M; # set maximum upload size for mail attachments

                include fastcgi_params;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_kolab-syncroton.sock;
                fastcgi_param SCRIPT_FILENAME /usr/share/kolab-syncroton/index.php;
            }

            ##
            ## Kolab Free/Busy
            ##
            location /freebusy {
                alias  /usr/share/kolab-freebusy/public_html/index.php;

                include fastcgi_params;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_kolab-freebusy.sock;
                fastcgi_param SCRIPT_FILENAME /usr/share/kolab-freebusy/public_html/index.php;
            }
        }
        EOF

#.  Create the PHP FPM Pools:

    .. parsed-literal::

        # :command:`cat > /etc/php-fpm.d/kolab.example.org_chwala.conf` << EOF
        [kolab.example.org_chwala]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_chwala.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        EOF
        # :command:`cat > /etc/php-fpm.d/kolab.example.org_iRony.conf` << EOF
        [kolab.example.org_iRony]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_iRony.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        EOF
        # :command:`cat > /etc/php-fpm.d/kolab.example.org_kolab-freebusy.conf` << EOF
        [kolab.example.org_kolab-freebusy]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_kolab-freebusy.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        EOF
        # :command:`cat > /etc/php-fpm.d/kolab.example.org_kolab-syncroton.conf` << EOF
        [kolab.example.org_kolab-syncroton]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_kolab-syncroton.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        php_flag[suhosin.session.encrypt] = Off
        EOF
        # :command:`cat > /etc/php-fpm.d/kolab.example.org_kolab-webadmin.conf` << EOF
        [kolab.example.org_kolab-webadmin]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_kolab-webadmin.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        EOF
        # :command:`cat > /etc/php-fpm.d/kolab.example.org_roundcubemail.conf` << EOF
        [roundcubemail]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_roundcubemail.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        # Derived from .htaccess of roundcube
        php_flag[display_errors] = Off
        php_flag[log_errors] = On

        php_value[upload_max_filesize] = 30M
        php_value[post_max_size] = 30M

        php_flag[zlib.output_compression] = Off
        php_flag[magic_quotes_gpc] = Off
        php_flag[magic_quotes_runtime] = Off
        php_flag[zend.ze1_compatibility_mode] = Off
        php_flag[suhosin.session.encrypt] = Off

        php_flag[session.auto_start] = Off
        php_value[session.gc_maxlifetime] = 21600
        php_value[session.gc_divisor] = 500
        php_value[session.gc_probability] = 1

        # http://bugs.php.net/bug.php?id=30766
        php_value[mbstring.func_overload] = 0
        EOF

#.  For this demonstrative configuration, make sure the following setting is in
    :file:`/etc/roundcubemail/config.inc.php`:

    .. parsed-literal::

        $config['file_api_url'] = 'https://kolab.example.org:8443/chwala/api/';

#.  Ensure, if you are using HTTPS, that the Chwala URL (``kolab_files_url``)
    in :file:`/etc/roundcubemail/kolab_files.inc.php` is also set to
    ``https`` rather than ``http``,  or most browsers will be unable to access
    the files component in Roundcube.

#.  For configurations that use SSL, make sure to work around a known issue in
    PHP pear module HTTP_Request2, and include in
    :file:`/etc/roundcubemail/config.inc.php`:

    .. parsed-literal::

        $config['ssl_verify_host'] = false;
        $config['ssl_verify_peer'] = false;

#.  Start the **php-fpm** service and configure the service to start on boot:

    .. parsed-literal::

        # :command:`service php-fpm start`
        # :command:`chkconfig php-fpm on`

#.  Start the **nginx** service and configure the service to start on boot:

    .. parsed-literal::

        # :command:`service nginx start`
        # :command:`chkconfig nginx on`
