.. _admin_kolab-freebusy-settings:

=========================================
Kolab Freebusy Servcie Settings Reference
=========================================

The web service is configured using a single settings file in .ini format
located in ``/etc/kolab-freebusy/config.ini``.

The configuration is divided into the following static sections and a list
**directory** sections defining the list of directories used to search
for freebusy for the requested user or resource. The directories are iterated
from to to bottom in the order as they appear in the config file. The iteration
stops once a directory can provide valid freebusy data.


Basic Configuration
===================

[httpauth]
----------

Access to the web service can be protected with basic HTTP authentication.
This section controls the authentication with the following options:

``type``
^^^^^^^^
Either one of 'static' or 'ldap'.

'static' provides a simple authentication with a static username/password pair.

'ldap' will perform an LDAP login with the provided username and password.
Only users who can authenticate on LDAP will be granted access to the service.

``username``
^^^^^^^^^^^^
Static username used with type 'static'.

``password``
^^^^^^^^^^^^
Static password used with type 'static'.

``host``
^^^^^^^^
Fully qualified URI to the LDAP server, including protocol and port.

Example: ``ldap://localhost:389``

``bind_dn``
^^^^^^^^^^^
DN for binding to the LDAP service. Should be an unprivileged
user with read-only access.

Example: ``uid=kolab-service,ou=Special Users,dc=example,dc=org``

``bind_pw``
^^^^^^^^^^^
Password for binding to the LDAP service. 

``filter``
^^^^^^^^^^
Optional. Filter used to first resolve the username against LDAP.
``%s`` is replaced by the username.

Example: ``(&(|(mail=%s)(alias=%s)(uid=%s))(objectclass=inetorgperson))``


[trustednetworks]
-----------------

Allow privileged access from these IPs and skip HTTP authentication
in case httpauth is configured.

Privileged access means that instead of a dummy freebusy data block,
a 404 error is returned if a user or resource could not be resolved.

``allow``
^^^^^^^^^

A list of IPs, subnets or patterns which are considered trusted.

Examples:

.. code-block:: ini

    allow = 127.0.0.1,
      192.168.0.0/16,
      10.10.*,
       ::1

.. _admin_kolab-freebusy-settings-log:

[log]
-----

Logging configuration.

``driver``
^^^^^^^^^^
Supported drivers are 'file' and 'syslog'

``path``
^^^^^^^^
Local filesystem path to a directory where log files will be created.

``name``
^^^^^^^^
Filename or syslog identifier.

``level``
^^^^^^^^^
The general log level. Possible values are:

* 100 = Debug
* 200 = Info
* 300 = Warn
* 400 = Error
* 500 = Critical



Directories and Sources
=======================

Directories are defined as named sections like

.. code-block:: ini

    [directory "local"]

and use the following options depending on the specified type:

``type``
--------

Either one of 'static' or 'ldap'.

'static' denotes a simple directory with an optional ``filter``
option providing a regular expression to matching the requested user name.

'ldap' directories perform an LDAP query to validate the requested user name
and to provide additional attributes used for retrieving freebusy data from
the linked source. This type uses the following configuration options:

* host
* bind_dn
* bind_pw
* base_dn
* filter
* attributes
* attributes_lc (optional)


``filter``
----------

Optional. String denoting a regular expression matched against the user name.

See `PHP PCRE Manual <http://php.net/manual/en/reference.pcre.pattern.syntax.php>`_
for the allowed regex syntax.


``host``
--------

Fully qualified URI to the LDAP server, including protocol and port.

Example: ``ldap://localhost:389``

``bind_dn``
-----------

DN for binding to the LDAP service. Should be an unprivileged
user with read-only access.

Example: ``uid=kolab-service,ou=Special Users,dc=example,dc=org``

``bind_pw``
-----------

Password for binding to the LDAP service. 

``filter``
----------
Filter used to find the given user in LDAP. ``%s`` is replaced by the user name.

Example: ``"(&(objectClass=kolabInetOrgPerson)(|(uid=%s)(mail=%s)(alias=%s)))"``

``attributes``
--------------

List of attributes which should be fetched from the matching LDAP entry.
These will then replace placeholders in the ``fbsource`` URI.

Example: ``mail, sn``

``lc_attributes``
-----------------

List of entry attributes which are read form LDAP and are converted into lower-case
characters.


``mail_attributes``
-------------------

List of entry attributes which denote the user's email address(es).

Only used in conjunction with an 'imap' source.

These attributes are used to determine whether events from shared calendars
affect the user's availability. Email addresses from all these attributes
are matched against the list of event attendees.


``fbsource``
------------

This option defines the **Source** where freebusy data for the matching user
is fetched from. The value is a fully qualified URI with the protocol identifier
denoting the type of the source.

Example: ``file:/var/lib/kolab-freebusy/%mail.ifb``

The follwing source types are supported:

``file``
^^^^^^^^

.. code-block:: ini

    fbsource = file:/var/lib/kolab-freebusy/%mail.ifb
    
``%mail`` is a placeholder for the ``mail`` attribute from LDAP.


``http(s)``
^^^^^^^^^^^

.. code-block:: ini

    fbsource = https://<user>:<password>@externalhost.com/free-busy/%s.ics

``%s`` is replaced with the user name from the request.

``imap``
^^^^^^^^

.. code-block:: ini
    
    ;; read data from a users calendars (all) using IMAP proxy authentication
    fbsource = "imap://%mail:<admin-pass>@localhost/?proxy_auth=cyrus-admin"

    ;; read data from a shared IMAP folder with cyrus-admin privileges
    fbsource = "imap://cyrus-admin:<admin-pass>@localhost/%kolabtargetfolder?acl=lrs"

``%mail`` and ``%kolabtargetfolder`` are placeholders for attributes from LDAP.

The ``proxy_auth`` URL parameter performs a proxy authentication using the given
admin username (parameter value) and the admin password.

The ``acl`` URL parameter will set the defined ACLs to the target IMAP folder
in order to let the admin user read its contents.


``fbdaemon``
^^^^^^^^^^^^

.. code-block:: ini

    ;; trigger kolab-freebusyd daemon to aggregate data from a user's calendars
    fbsource = "fbdaemon://localhost:<port>?user=%mail"

    ;; trigger kolab-freebusyd to fetch data from a shared folder (i.e. for resources)
    fbsource = "fbdaemon://localhost:<port>?folder=%kolabtargetfolder"

``%mail`` and ``%kolabtargetfolder`` are placeholders for attributes from LDAP.

The ``user`` URL parameter specifies the command for accessing IMAP on behalf of
this user (proxy authentication) and to collect data from all the calendar folders
this user has access to.

The ``folder`` parameter instructs the daemon to collect event data from the given
IMAP mailbox.

.. seealso::

    *   Architecture & Design, Kolab Freebusy Service, :ref:`and_kolab-freebusy-directory-types`


``cacheto``
-----------

An absolute path to the local file system where freebusy data collected from the configured
fbsource is cached for future requests. Can contain placeholders for LDAP attributes or
``%s`` for the requested user name.


``expires``
-----------

Defines the cache expiration time. Can contain numeric values with a unit indicator such as
``h``, ``m``, or ``s``.

Example: ``10m`` for 10 minutes


``loglevel``
------------

Log level for this directory. See :ref:`admin_kolab-freebusy-settings-log`
for possible values.



Examples
========

The `config.ini.sample <http://git.kolab.org/kolab-freebusy/tree/config/config.ini.sample>`_
file provides a full overview of possible configuration options.


Sample Directory for Kolab Users
--------------------------------

.. code-block:: ini

    [directory "kolab-users"]
    type = ldap
    host = ldap://localhost:389
    bind_dn = "uid=kolab-service,ou=Special Users,dc=example,dc=org"
    bind_pw = "<service-bind-pw>"
    base_dn = "ou=People,dc=example,dc=org"
    filter = "(&(objectClass=kolabInetOrgPerson)(|(uid=%s)(mail=%s)(alias=%s)))"
    attributes = mail
    lc_attributes = mail
    fbsource = file:/var/lib/kolab-freebusy/%mail.ifb


Sample Directory for Resources
------------------------------

.. code-block:: ini

    [directory "kolab-resources"]
    type = ldap
    host = ldap://localhost:389
    bind_dn = "uid=kolab-service,ou=Special Users,dc=yourdomain,dc=com"
    bind_pw = "<service-bind-pw>"
    base_dn = "ou=Resources,dc=yourdomain,dc=com"
    filter = "(&(objectClass=kolabsharedfolder)(mail=%s))"
    attributes = mail, kolabtargetfolder
    fbsource = "fbdaemon://localhost:<port>?folder=%kolabtargetfolder"
    timeout = 10    ; abort after 10 seconds
    cacheto = /var/cache/kolab-freebusy/%mail.ifb
    expires = 10m
    loglevel = 100  ; Debug

