==================================
HOWTO: Use NGINX as the Web Server
==================================

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

            location ~ /roundcubemail/.*\.php\$ {
                if (\$fastcgi_script_name ~ /roundcubemail(/.*\.php)\$) {
                    set \$valid_fastcgi_script_name \$1;
                }
                fastcgi_pass    unix:/var/run/php-fpm/php-fpm.sock;
                fastcgi_index   index.php;
                fastcgi_param   SCRIPT_FILENAME    /usr/share/roundcubemail\$valid_fastcgi_script_name;
                include         fastcgi_params;
            }

            location /kolab-webadmin {
                alias //usr/share/kolab-webadmin/public_html;
                index index.php;
            }

            location ~ /kolab-webadmin/.*\.php\$ {
                if (\$fastcgi_script_name ~ /kolab-webadmin(/.*\.php)\$) {
                    set \$valid_fastcgi_script_name \$1;
                }
                fastcgi_pass    unix:/var/run/php-fpm/php-fpm.sock;
                fastcgi_index   index.php;
                fastcgi_param   SCRIPT_FILENAME /usr/share/kolab-webadmin/public_html\$valid_fastcgi_script_name;
                include         fastcgi_params;
            }

            location ~ /kolab-webadmin/api/.*\$ {
                rewrite ^/kolab-webadmin/api/([a-z-_]+)\.([a-z-_]+).*\$ /kolab-webadmin/api/index.php?service=\$1&method=\$2 last;
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
