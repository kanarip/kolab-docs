=============================================
:command:`setup-kolab` Command-Line Reference
=============================================

The :command:`setup-kolab` command allows each component it configures for you,
to be configured separately from the others. To view the list of components
:command:`setup-kolab`, execute :command:`setup-kolab help`.

.. parsed-literal::

    # :command:`setup-kolab help`
    freebusy                  - Setup Free/Busy.
    help                      - Display this help.
    imap                      - Setup IMAP.
    kolabd                    - Setup the Kolab daemon.
    ldap                      - Setup LDAP.
    mta                       - Setup MTA.
    mysql                     - Setup MySQL.
    php                       - Setup PHP.
    roundcube                 - Setup Roundcube.
    syncroton                 - Setup Syncroton.

[root@kolab ~]# setup-kolab --help
Usage: setup-kolab [options]

Options:
  -h, --help            show this help message and exit

  Runtime Options:
    -c CONFIG_FILE, --config=CONFIG_FILE
                        Configuration file to use
    -d DEBUGLEVEL, --debug=DEBUGLEVEL
                        Set the debugging verbosity. Maximum is 9, tracing
                        protocols like LDAP, SQL and IMAP.
    -l LOGLEVEL         Set the logging level. One of info, warn, error,
                        critical or debug
    --logfile=LOGFILE   Log file to use
    -q, --quiet         Be quiet.
    -y, --yes           Answer yes to all questions.

  LDAP Options:
    --fqdn=FQDN         Specify FQDN (overriding defaults).
    --allow-anonymous   Allow anonymous binds (default: no).
    --without-ldap      Skip setting up the LDAP server.
    --with-openldap     Setup configuration for OpenLDAP compatibility.
    --with-ad           Setup configuration for Active Directory
                        compatibility.

  PHP Options:
    --timezone=TIMEZONE
                        Specify the timezone for PHP.
    --with-php-ini=PHP_INI_PATH
                        Specify the path to the php.ini file used with the
                        webserver.

PyKolab is a Kolab Systems product. For more information about Kolab or
PyKolab, visit http://www.kolabsys.com
