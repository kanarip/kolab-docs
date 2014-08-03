.. _admin-config:

======================================
Configuring the Kolab Groupware Server
======================================

.. _admin_rcpt-policy:

Recipient Policy
================

Kolab Groupware features the automated application of user metadata,
such as a user's given-, surname and user ID, to form
:term:`recipient email addresses` for the user.

This is called the :term:`recipient policy`, and serves the following
important purposes:

#.  :ref:`admin_rcpt-policy_naming-conventions` (should they exist) are
    applied automatically and consistently,

#.  :ref:`admin_rcpt-policy_locale-transliteration` of non-ASCII
    characters in names is applied to form valid email addresses,

#.  :ref:`admin_rcpt-policy_globally-unique-addresses` are automatically
    guaranteed.

.. _admin_rcpt-policy_naming-conventions:

Naming Conventions
------------------

The recipient policy aids deployments in achieving a level of
consistency throughout their recipient database by applying a naming
convention, avoiding the need for Kolab Groupware administrators to need
to understand and consistently apply naming convention rules.

Consistency is important when considering global address book listings
and searches in different contexts, and when anticipating what a valid
recipient address for a given user may be -- noted that most email users
do not have access to your global address book to verify a recipient
address is valid, and it is likely that most communications will take
place with those users.

.. _admin_rcpt-policy_locale-transliteration:

Locale-specific Transliteration
-------------------------------

Names can contain non-ASCII characters -- for example *Marie Möller* --,
while recipient email addresses may not contain such characters (i.e.
*marie.möller@example.org* is an invalid email address).

Without locale specific transliteration, the email address would become
*marie.moller@example.org*. This is considered inadequate, as many users
will experience this inappropriate, inconsiderate and/or awkward -- it
is the user's native tongue after all and transliteration is used in
every-day life. Kolab Groupware should therefor also be able to apply
the same transliteration rules specific to the user's native tongue.

With the (presumably correct) transliteration rules for German applied,
the email address would become *marie.moeller@example.org*.

The recipient policy takes the value(s) of a number of attributes from
an entry, and executes the recipient policy for primary and secondary
recipient email addresses with help of the attribute names (referred to
in the policy) and their values.

It will set the primary email address attribute to a singular value,
though the LDAP schema allows multiple values for the default primary
mail attribute mail.

The secondary email address attribute (alias by default) is set to the
value(s) returned by the recipient policy as well.

.. _admin_rcpt-policy_globally-unique-addresses:

Globally Unique Recipient Email Addresses
-----------------------------------------

Furthermore, the recipient policy allows these automatically recipient
email addresses to be globally unique.

The primary email address attribute value is, by default, used to
determine a user's mailbox name. Further using the previous example,
user *Marie Möller <marie.moeller@example.org>* would get a user mailbox
of ``user/marie.moeller@example.org``.

It is important to realize that, should a second user also receive a
primary email address attribute value of *marie.moeller@example.org*,
two important things would happen:

#.  Possibly only one of the two, but likely neither user would be able
    to authenticate,

#.  The user's mailbox and authorization ID would no longer uniquely
    correspond to either user.

Unless intentionally so, it is also important to avoid entries holding
the same secondary email address attribute value(s).

To this end, for each generated value of either primary or secondary
mail address attributes, a check is performed and -- if the address is
already in use -- an integer is appended and incremented if necessary.

For three people named *Marie Möller* for example, this would end up as:

*   ``user/marie.moeller@example.org``
*   ``user/marie.moeller2@example.org``
*   ``user/marie.moeller3@example.org``

Components that Apply the Recipient Policy
------------------------------------------

By default, the recipient policy is applied by two separate
applications:

#.  The optional Kolab Web Administration Panel, often used for
    inputting new users and editing existing ones, so that this
    interface reflects the results to be expected,

#.  The Kolab daemon (the **kolabd** service) is the primary component
    to apply the recipient policy.

Both components use the configuration settings ``primary_mail`` and
``secondary_mail`` as their policy configuration.

To prevent the Kolab daemon from applying the recipient policy, add the
following setting to :manpage:`kolab.conf(5)`:

.. parsed-literal::

    [kolab]
    daemon_rcpt_policy = False

Having added this setting, the Kolab Web Administration Panel could be
re-configured so that the ``mail`` attribute for user entries becomes
``Generated`` instead of ``Generated (read-only)``.

These configuration items consist of a Python notation for string
formatting, along with a limited number of string operations.

The ``primary_mail`` setting contains a singular basestring to be used
in simplistic string formatting, while the ``secondary_mail`` setting
contains a numerically ordered list of singular basestrings to be used
in string formatting, and additionally allow the opportunity to execute
some additional string operations such as converstion to substrings and
capitalization.

Application of the Default Recipient Policy Example
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If an example.org user is created with given name John and surname Doe,
the default recipient policy will set the primary email address to
john.doe@example.org and the secondary email addresses to
j.doe@example.org and doe@example.org.

.. IMPORTANT::

    By default, the primary recipient email address is used as a
    globally unique identifier involving authentication (allowing login
    by email address), the user's mailbox name, mail delivery
    configuration, access control and the storage of user profiles.

    It is therefore very important that no two entries share a single
    primary recipient email address.

The primary recipient email address for an ``example.org`` domain user
with given name *Marie*, surname *Möller* and preferred language of
*en_US* is (incidentally **wrongly**, see further down for the "correct"
way) composed as follows:

#.  The ``sn`` attribute is transliterated using the specified preferred
    language for the user, with the equivalent of:

    .. parsed-literal::

        # :command:`echo "Möller" | \\
            LANG=en_US /usr/bin/iconv -f UTF-8 -t ASCII//TRANSLIT -s`

    and stored as the value to key ``surname`` (now "Moller").

#.  The recipient policy is obtained from the ``primary_mail`` setting.

    By default, this setting is set to:

    .. parsed-literal::

        [example.org]
        primary_mail = %(givenname)s.%(surname)s@%(domain)s

    .. NOTE::

        The attribute name for a user's surname (family name) is ``sn``.
        The use of ``surname`` in the configuration is to indicate that
        the transliterated version of the original (``sn``) should be
        used.

#.  The equivalent of the following Python is then executed:

    >>> primary_mail = "%(givenname)s.%(surname)s@%(domain)s" % {
                "givenname": "Maria",
                "surname": "Moller",
                "preferredlanguage": "en_US"
            }

    >>> primary_mail
    maria.moller@example.org

#.  This return value is checked against the existing user database for
    global uniqueness, and appended an integer to, which starts at 2,
    and is incremented by 1 for each recipient address that would not be
    globally unique.

The same routine applied with a preferred language of *de_DE* though:

#.  The ``sn`` attribute is transliterated using the specified preferred
    language for the user, with the equivalent of:

    .. parsed-literal::

        # :command:`echo "Möller" | \\
            LANG=de_DE /usr/bin/iconv -f UTF-8 -t ASCII//TRANSLIT -s`

    and stored as the value to key ``surname`` (now "Moeller").

#.  The recipient policy is obtained from the ``primary_mail`` setting.

    By default, this setting is set to:

    .. parsed-literal::

        [example.org]
        primary_mail = %(givenname)s.%(surname)s@%(domain)s

    .. NOTE::

        The attribute name for a user's surname (family name) is ``sn``.
        The use of ``surname`` in the configuration is to indicate that
        the transliterated version of the original (``sn``) should be
        used.

#.  The equivalent of the following Python is then executed:

    >>> primary_mail = "%(givenname)s.%(surname)s@%(domain)s" % {
                "givenname": "Maria",
                "surname": "Moeller",
                "preferredlanguage": "de_DE"
            }
    >>> primary_mail
    maria.moeller@example.org

#.  This return value is checked against the existing user database for
    global uniqueness, and appended an integer to, which start at 2, and
    is incremented by 1 for each recipient address that would not be
    globally unique.

Secondary Email Address Recipient Policy Example
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The secondary recipient email address for an example.org user with given
name *Marie*, surname *Möller* and preffered language *de_DE*, is
composed as follows:

#.  The ``sn`` attribute is transliterated using the specified preferred
    language for the user, with the equivalent of:

    .. parsed-literal::

        # :command:`echo "Möller" | \\
            LANG=de_DE /usr/bin/iconv -f UTF-8 -t ASCII//TRANSLIT -s`

    and stored as the value to key ``surname`` (now "Moeller").

#.  The recipient policy is obtained from the i``secondary_mail``
    setting. By default, this configuration setting is set to:

    .. parsed-literal::

        [example.org]
        secondary_mail = {
                0: {
                        "{0}.{1}@{2}": "format('%(givenname)s'[0:1].capitalize(), '%(surname)s', '%(domain)s')"
                    },
                1: {
                        "{0}@{1}": "format('%(uid)s', '%(domain)s')"
                    },
                2: {
                        "{0}@{1}": "format('%(givenname)s.%(surname)s', '%(domain)s')"
                    }
            }

    As the configuration indicates, the attributes for the user that
    will be used are the given name, the surname and the uid.

#.  Using Python's string formatting, the resulting primary recipient
    email address would become:

    >>> secondary_mail = [
                "{0}.{1}@{2}".format('Maria'[0:1].capitalize(), 'Moeller', 'example.org'),
                "{0}@{1}".format('moeller', 'example.org'),
                "{0}@{1}".format('maria.moeller', 'example.org'),
            ]
    >>> secondary_mail
    [ 'm.moeller@example.org', 'moeller@example.org', 'maria.moeller@example.org' ]

#.  Any secondary email address that ends up being a duplicate of the
    established primary email address is removed,

#.  The remainder addresses are checked against the existing user
    database for global uniqueness, and appended an integer to, which
    starts at 2, and is incremented by 1 for each recipient address that
    would not be globally unique.

Configuring the Recipient Policy
--------------------------------

Setting Primary Recipient Email Address
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The primary recipient email address can be changed to reflect your
naming convention through this procedure:

#.  Edit :file:`/etc/kolab/kolab.conf` and replace the value of the
    ``primary_mail`` setting in the applicable domain section.

    For example, set the policy to ``%(givenname)s@%(domain)s`` to get
    email addresses like ``john@example.org`` and ``jane@example.org``.

#.  Edit the user types for any user that matches the filter used by the
    kolab daemon to determine which users are kolab users. For example,
    "Kolab Users" and "Mail-enabled POSIX users" both include
    "objectclass=kolabinetorgperson" (the default ``kolab_user_filter``)
    and therefore the Kolab daemon would apply the recipient policy to
    these objects.

    For each of these user_types, make sure that the auto_form_field
    configuration for the primary recipient email (``mail``) attribute
    include all attributes needed to compose the address.

    If, for example, you seek to apply a recipient policy containing
    ``%(initials)s``, so that a user *John Frank Doe* may have an email
    address of ``john.f.doe@example.org``, the ``initials`` attribute
    will need to be added to the ``data`` list in the
    ``auto_form_field`` definition for the ``mail`` attribute.

Setting the Secondary Recipient Email Address
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The secondary recipient email addresses can be changed to reflect your
naming convention through this procedure:

#.  Edit :file:`/etc/kolab/kolab.conf` and replace the value of the
    ``secondary_mail`` setting in the applicable domain section.

    For example, set a policy item to
    ``'{0}@{1}': "format('%(givenname)s', '%(domain)s')"``
    to get email addresses like ``john@example.org`` and
    ``jane@example.org``.

#.  Edit the user types for any user that matches the filter used by the
    kolab daemon to determine which users are kolab users. For example,
    "Kolab Users" and "Mail-enabled POSIX users" both include
    "objectclass=kolabinetorgperson" (the default ``kolab_user_filter``)
    and therefore the Kolab daemon would apply the recipient policy to
    these objects.

    For each of these user_types, make sure that the auto_form_field
    configuration for the secondary recipient email (``alias``)
    attribute include all attributes needed to compose the addresses.

Controlling the Primary and Secondary Recipient Email Address Attributes
------------------------------------------------------------------------

The attribute names that contain the primary and secondary recipient
email addresses are controlled by the ``mail_attrs`` setting in the
``[$domain]`` section of :file:`/etc/kolab/kolab.conf`.

Should no such section or setting exist, then the fallback in the
``[$auth_mechanism]`` section is used, where *$auth_mechanism* is the
authentication mechanism configured using the ``auth_mechanism`` setting
in the ``[kolab]`` section.

.. NOTE::

    Note that only 'ldap' is currently supported as an authentication
    mechanism.

This setting is a comma- and/or comma-space separated list of attribute
names.

By default, ``mail_attrs`` is set to ``mail, alias``.

The first item in the list will be used as the attribute to use for
primary recipient email addresses.

The second item in the list will be used as the attribute to use for
secondary recipient email addresses.

No policy applies to any further values in this list, should they exist.

Disabling the Recipient Policy
------------------------------

The following procedure describes how to disable the recipient policy.

Disabling the Recipient Policy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#.  Edit :file:`/etc/kolab/kolab.conf` and navigate to the section
    applicable for your domain (named ``[$domain]``).

#.  Remove the settings primary_mail and secondary_mail.

#.  Restart the Kolab daemon:

    .. parsed-literal::

        # :command:`service kolabd restart`

#.  Copy
    :file:`/usr/share/doc/kolab-webadmin-*/sample-insert-user_types.php`
    to :file:`/usr/share/kolab-webadmin/`:

    .. parsed-literal::

        # :command:`cp /usr/share/doc/kolab-webadmin-*/sample-insert-user_types.php \\
            /usr/share/kolab-webadmin/`

#.  Open :file:`/usr/share/kolab-webadmin/sample-insert-user_types.php`
    in an editor of your choice.

#.  Remove the values of ``$attributes['auto_form_fields']['mail']`` and
    ``$attributes['auto_form_fields']['alias']``.

    The corresponding lines should look as follows:

    .. parsed-literal::

        "alias" => Array(
                "type" => "list",
                "data" => Array(
                        "givenname",
                        "preferredlanguage",
                        "sn",
                    ),
            ),

    and:

    .. parsed-literal::

        "mail" => Array(
                "data" => Array(
                        "givenname",
                        "preferredlanguage",
                        "sn",
                    ),
            ),

#.  Edit the value of ``$attributes['form_fields']['alias']`` and add
    ``$attributes['form_fields']['alias']['type'] => "list"``:

    .. parsed-literal::

        "alias" => Array(
                "optional" => true,
                "type" => "list"
            ),

#.  Add a new value ``$attributes['form_fields']['mail']`` with the
    following contents:

        "mail" => Array(
                "optional" => true
            ),

.. IMPORTANT::

    Remember to remove the aforementioned
    ``$attributes['auto_form_fields']`` and add or chance the
    ``$attributes['form_fields']` for all user types that have mail
    attributes.

#.  Exit the editor, saving your changes, and check the PHP syntax:

    .. parsed-literal::

        # :command:`cd /usr/share/kolab-webadmin/`
        # :command:`php -l sample-insert-user_types.php`

#.  Apply the changes to the database:

    .. parsed-literal::

        # :command:`php sample-insert-user_types.php`

    .. NOTE::

        You may have to log out and log back in of the Kolab Web
        Administration Panel for the changes to take effect.

Storage Tiering of the IMAP Spool
=================================

Using Cyrus IMAP partitions, a single IMAP server can hold multiple
spools in which mailboxes reside.

A deployment can choose to have, for example, the INBOX and additional
folders on fast, expensive storage, while an Archive folder may need to
reside on slow, cheap storage.

The configuration in :manpage:`imapd.conf(5)` would look like:

.. parsed-literal::

    (...)
    defaultpartition: default
    partition-default: /path/to/fast/storage
    partition-archive: /path/to/slow/storage
    (...)

To have Archive folders for new users be created on the archive
partition, use the ``autocreate_folders`` setting in
:manpage:`kolab.conf(5)` and adjust:

.. parsed-literal::

    autocreate_folders = {
            'Archive': {
                    'quota': 0
                },
            (...)
        }

to:

.. parsed-literal::

    autocreate_folders = {
            'Archive': {
                    'quota': 0,
                    'partition': 'archive'
                },
            (...)
        }

Adding Domains
==============

Kolab Groupware allows a single-domain setup to easily become a
multi-domain setup, by adding additional domain name spaces through the
web administration panel.

Two types of additional domain name spaces exist;

#.  An alias domain name space, that is an additional namespace for an
    existing domain name space.

    This type of domain name space is useful for additional domain name
    spaces that should end up with the same organization or group of
    accounts that already exists.

    For example, a company with domain name space "example.us" as its
    primary domain may want to allow email addresses for the domain name
    space "example.com" (alias) to be used as well.

#.  A new domain name space, that can be viewed as a new organization or
    group of accounts.

    This type of domain name space creates a new, isolated space in
    which the accounts for the domain name space(s) are to exist. It is
    isolated in the sense that none of the accounts in the new domain
    name space will (typically) ever know about any of the accounts in
    any of the other isolated domain name spaces (unless you make it
    specifically so).

    For example, a company "redhat.com" is definitively a different
    organization from "sco.com", and no information or accounts should
    leak across the boundaries of each respective realm.

Adding an Alias Domain Name Space
---------------------------------

#.  Login to the web administration panel as a global LDAP administrator
    (for example, as "cn=Directory Manager", but you may have delegated
    this authority).

#.  Navigate to "Domains".

#.  From the left-hand pane -- the list of current parent domain name
    spaces --, select the domain to add an alias domain name space to.

#.  In the "Domain name(s)" field, click the "[+]" to append a form
    field to the list.

#.  Supply the new domain name space to add in the new form field
    appended to the list.

#.  Press "[Submit]".

Adding a Parent Domain Name Space
---------------------------------

When a new domain needs to be completely isolated from the existing domain,
please be aware additional configuration is necessary in a variety of locations.

See :ref:`admin_organizations-with-multiple-domain-namespaces` for more
information on additional configuration considerations.

#.  Login to the web administration panel as the Directory Manager user (login
    username "cn=Directory Manager").

#.  Navigate to "Domains".

    The "Add Domain" form should be displayed.

#.  Fill out the domain name space, for example: "mynewdomain.org".

#.  Click the "[Submit]" button.

The new domain has now been created in LDAP.

.. _admin_organizations-with-multiple-domain-namespaces:

Configuration Considerations for Multiple Domain Namespaces
===========================================================

Suppose the following diagram illustrates a number of domain names in a Kolab
deployment for a single organization.

.. graphviz::

    digraph tree
    {

        charset="latin1";
        fixedsize=true;
        node [style="rounded", width=0, height=0, shape=box, concentrate=true]

        "cn=kolab,cn=config" [shape=box] {
                rank=same
                "path-point-holding.inc" [shape=point]
                "dc=holding,dc=inc" [color=blue];
                "associateddomain=holding.inc" -> "dc=holding,dc=inc" [color=blue]
            }

        "cn=kolab,cn=config" -> "path-point-holding.inc" [arrowhead=none]

        "path-point-holding.inc" -> "associateddomain=holding.inc"

        "associateddomain=holding.inc" {
                rank=same
                "path-point-foo.inc" [shape=point]
                "associateddomain=foo.inc"
            }

        "associateddomain=holding.inc" -> "path-point-foo.inc" [arrowhead=none]
        "path-point-foo.inc" -> "associateddomain=foo.inc" {
                rank=same
                "path-point-bar.inc" [shape=point]
                "associateddomain=bar.inc"
            }

        "path-point-foo.inc" -> "path-point-bar.inc" [arrowhead=none]
        "path-point-bar.inc" -> "associateddomain=bar.inc"
    }

This deployment has been set up to serve ``holding.inc``, to which the
additional alias domain name spaces ``foo.inc`` and ``bar.inc`` have been added
later.

Holding corporation **Holding, Inc.** clearly uses three domain name spaces:

#. ``holding.inc``
#. ``foo.inc``
#. ``bar.inc``

Using the Postfix LDAP lookup tables configured by default, all recipient
addresses in these domain namespaces are validated against
``dc=holding,dc=inc``.

Now consider three different organizations use the same Kolab Groupware
environment, such as might be the case with hosted, or in case **Holding, Inc.**
wishes to maintain different, isolated trees for its subsidiaries.

.. graphviz::

    digraph tree
    {

        charset="latin1";
        fixedsize=true;
        node [style="rounded", width=0, height=0, shape=box, concentrate=true]

        "cn=kolab,cn=config" [shape=box] {
                rank=same
                "path-point-farmer.inc" [shape=point]
                "dc=farmer,dc=inc" [color=blue]
                "associateddomain=farmer.inc" -> "dc=farmer,dc=inc" [color=blue]
            }

        "cn=kolab,cn=config" -> "path-point-farmer.inc" [arrowhead=none]

        "path-point-farmer.inc" -> "associateddomain=farmer.inc" {
                rank=same
                "path-point-baker.inc" [shape=point]
                "dc=baker,dc=inc" [color=blue]
                "associateddomain=baker.inc" -> "dc=baker,dc=inc" [color=blue]
            }

        "path-point-farmer.inc" -> "path-point-baker.inc" [arrowhead=none]

        "path-point-baker.inc" -> "associateddomain=baker.inc" {
                rank=same
                "path-point-butcher.inc" [shape=point]
                "dc=butcher,dc=inc" [color=blue]
                "associateddomain=butcher.inc" -> "dc=butcher,dc=inc" [color=blue]
            }

        "path-point-baker.inc" -> "path-point-butcher.inc" [arrowhead=none]
        "path-point-butcher.inc" -> "associateddomain=butcher.inc"
    }

While the LDAP lookup table for domain name spaces will succeed as expected,
local recipient maps will not, as they have initially been configured to query
the primary domain (and the primary domain only).

Default :file:`local_recipient_maps.cf` LDAP lookup table for ``example.org``
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

.. parsed-literal::

    server_host = localhost
    server_port = 389
    version = 3
    **search_base = dc=example,dc=org**
    scope = sub

    domain = ldap:/etc/postfix/ldap/mydestination.cf

    bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
    bind_pw = pass

    query_filter = (&(\|(mail=%s)(alias=%s))(\|(objectclass=kolabinetorgperson)(...)))
    result_attribute = mail

This is intentional - the alternative scenario creates a potentially disruptive
amount of overhead, and eliminates option value for customers.

If the number of parent domain name spaces hosted is relatively static, we
recommend considering the use of configured lookup tables per parent domain
name space.

If the number of parent domain name spaces hosted in relatively dynamic, we
recommend the use of dynamic search bases.

Using a Dynamic Search Base for LDAP Lookup Tables
""""""""""""""""""""""""""""""""""""""""""""""""""

Should you choose to use a dynamic configuration value for search bases, please
take on the following points:

*   A search base template needs to be specified for all levels of domains and
    sub-domains.

    The ``example.org`` domain name space can be resolved to
    ``dc=example,dc=org`` using a search base template of ``dc=%2,dc=%1``, but
    ``example.org.uk`` can not be resolved to ``dc=example,dc=org,dc=uk`` using
    that same template.

*   The search base template sets a standard format for root dns, that will
    therefore need to apply to all domains throughout the environment. If, for
    example, an organization **Plumbers, Inc.** wants you (the service provider)
    to synchronize their in-house LDAP tree with root dn ``o=plumbers,c=de``,
    you will need to provide an extra set of custom lookup tables.

*   To reduce overhead, the ``domain`` setting should include only relevant and
    applicable domains (for the search base template to work).

    With domains ``example.org.uk`` and ``example.org``, the triplet should be
    queried first, with ``domain`` being restricted to use a filter of:

    .. parsed-literal::

        (&(associateddomain=%s)(associateddomain=*.*.*))

.. rubric:: Example Templated Search Base

The following depicts an example
:file:`/etc/postfix/ldap/hosted_triplet_local_recipient_maps.cf`:

.. parsed-literal::

    server_host = localhost
    server_port = 389
    version = 3
    **search_base = dc=%3,dc=%2,dc=%1**
    scope = sub

    domain = ldap:/etc/postfix/ldap/hosted_triplet_mydestination.cf

    bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
    bind_pw = pass

    query_filter = (&(\|(mail=%s)(alias=%s))(\|(objectclass=kolabinetorgperson)(...)))
    result_attribute = mail

The following depicts an example
:file:`/etc/postfix/ldap/hosted_duplet_local_recipient_maps.cf`:

.. parsed-literal::

    server_host = localhost
    server_port = 389
    version = 3
    **search_base = dc=%2,dc=%1**
    scope = sub

    domain = ldap:/etc/postfix/ldap/hosted_duplet_mydestination.cf

    bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
    bind_pw = pass

    query_filter = (&(\|(mail=%s)(alias=%s))(\|(objectclass=kolabinetorgperson)(...)))
    result_attribute = mail

.. rubric:: Example Postfix Configuration

.. parsed-literal::

    # :command:`postconf local_recipient_maps`
    local_recipient_maps = \\
        ldap:/etc/postfix/ldap/hosted_triplet_local_recipient_maps.cf \\
        ldap:/etc/postfix/ldap/hosted_dupplet_local_recipient_maps.cf
