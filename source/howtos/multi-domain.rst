====================================
HOWTO: Multi-Domain Support in Kolab
====================================

Before You Start
================

For environments that could possibly end up hosting a lot of domains, it is
recommended to set up a **domain_base_dn** that is contained within a database,
as opposed to the default *cn=kolab,cn=config*.

For environments seeking to host system administrator account information and
group membership in a centralized fashion, the use of a :term:`management
domain` -- the use of the primary domain as a management domain -- is
recommended. Note that such a management domain can hold an organizational unit
to hold the domain name spaces hosted, such as ``ou=Domains,$root_dn``.

Environments that seek to provide highly available (multi-master) replicated
LDAP environments for many domains should realize the default maximum number of
semaphore sets is 128.

.. seealso::

    *   A description of a typical :ref:`deployment_hosted-kolab`
    *   Deployment considerations for
        :ref:`deployment_organizations-with-multiple-domain-namespaces`, as they
        impact functionality
    *   :ref:`admin_ldap_increasing-max-open-fds` so LDAP can continue to accept
        connections
    *   :ref:`admin_ldap_7bit-password-check` to not confuse too many users at
        once
    *   :ref:`admin_ldap_configure-vlv` and :ref:`admin_ldap_configure-sss` for
        larger LDAP trees

Amavisd Changes
===============

Amavis wishes to determine whether the email passed to it (through it) is to be
received by a local recipient. However, it does not support lookups against LDAP
-- to see if domain name spaces are indeed locally hosted.

Only for (inbound or internal) traffic -- to domain name spaces considered
locally hosted -- will Amavisd add the ``X-Spam-*`` headers. As such, it is
necessary to tell Amavis what the local domain name spaces are, in order to
retain any spam headers.

#.  Edit ``/etc/amavisd/amavisd.conf``, setting ``@local_domains_maps``.

    **For dynamic environments**, ...

        consider replacing the ``@local_domains_maps``, with a default of:

        .. parsed-literal::

            @local_domains_maps = ( [".$mydomain"] );

        for the following wildcard expression:

        .. parsed-literal::

            $local_domains_re = new_RE( qr'.*' );

        This will simply match all domains, including outgoing traffic.

    **For (relatively) static environments,** ...

        you can maintain a list of domain name spaces in
        ``@local_domains_maps``, noted that you'll have to restart the
        **amavisd** service after each change.

        This would end up looking like:

        .. parsed-literal::

            @local_domains_maps = ( [
                    ".$mydomain",
                    ".example.org",
                    ".holding.inc"
                ] );

        .. NOTE::

            You will need to add parent domain name spaces **as well as** alias
            domain name spaces to this list as separate items.

#.  Restart the service:

    .. parsed-literal::

        # :command:`service amavisd restart`

Cyrus IMAP Changes
==================

Cyrus IMAP has, by default, been configured to allow users to login with a
``uid``, ``mail`` or ``alias`` login username, translating that login username
to the intended mailbox using a process called :term:`canonification`.

For multi-domain deployments, additional configuration is added to make the
process multi-domain aware (Kolab 3.2 and later), or avoid executing the process
altogher (Kolab 3.1 and earlier).

.. WARNING:: Cyrus IMAP 2.5 (Kolab 3.2 and later)

    Cyrus IMAP 2.5 ships with a patch created by Kolab Systems, and submitted
    and accepted upstream, that allows the parent domain DIT root dn to be
    discovered.

Add the following settings to :manpage:`imapd.conf(5)` as needed, and restart
the ``cyrus-imapd`` service:

**ldap_domain_base_dn** ``""``

    The base dn to search for domain name spaces. In a default Kolab Groupware
    setup, the appropriate default is ``cn=kolab,cn=config`` -- however we do
    not ship Cyrus IMAP with that as a default configuration value.

    If this configuration option is not set, ptloader will not perform any
    discovery.

**ldap_domain_filter** ``(&(objectclass=domainrelatedobject)(associateddomain=%s))``

    The filter to use when searching for a domain name space.

    For default Kolab Groupware setups, the default configuration value works as
    intended.

**ldap_domain_name_attribute** ``associatedDomain``

    The attribute to use when attempting to find the parent domain name space.

    For default Kolab Groupware setups, the default configuration value works as
    intended.

**ldap_domain_scope** ``sub``

    The scope to use when searching. One of "sub", "one", "base".

    For default Kolab Groupware setups, the default configuration value works as
    intended.

**ldap_domain_result_attribute** ``inetdomainbasedn``

    The attribute name of which to use the value, if the attribute is at all
    present on entries found, that contains the domain name space DIT root dn.

    For default Kolab Groupware setups, the default configuration value works as
    intended.

.. WARNING:: Cyrus IMAP 2.4

    The following changes are needed only for Kolab Groupware product streams
    that ship Cyrus IMAP 2.4. At the time of this writing, that includes Kolab
    3.1 and earlier versions, and Kolab Enterprise 13 and earlier versions of
    the enterprise edition.

This is not (yet) available for multi-domain deployments.

Execute the following sequence to remove the canonification process:

.. parsed-literal::

    # :command:`sed -i \\
        -e 's/^auth_mech/#auth_mech/g' \\
        -e 's/^pts_module/#pts_module/g' \\
        -e 's/^ldap_/#ldap_/g' \\
        -e 's/auxprop saslauthd/saslauthd/' \\
        -e '/ptloader/d' \\
        /etc/cyrus.conf \\
        /etc/imapd.conf`

    # :command:`service cyrus-imapd restart`

Postfix Changes
===============

Postfix has originally been configured to use the primary domain's DIT root dn
for LDAP lookups. So, for a system setup for ``example.org``, all LDAP lookup
tables are configured to lookup entries in ``dc=example,dc=org``.

The relevant lookup tables have been written out to :file:`/etc/postfix/ldap/`,
and added to the relevant Postfix configuration settings (in order of
application):

**mydestination**

    Check if the SMTP server is supposed to be receiving email for the
    recipient domain.

    This map (Kolab default: ``ldap:/etc/postfix/ldap/mydestination.cf``) can
    remain largely unchanged, but we need two copies of it:

    #.  Copy :file:`/etc/postfix/ldap/mydestination.cf` twice:

        .. parsed-literal::

            # :command:`cp /etc/postfix/ldap/mydestination.cf \\
                /etc/postfix/ldap/hosted_duplet_mydestination.cf`

            # :command:`cp /etc/postfix/ldap/mydestination.cf \\
                /etc/postfix/ldap/hosted_triplet_mydestination.cf`

    #.  Edit :file:`/etc/postfix/ldap/hosted_duplet_mydestination.cf` and
        change the ``query_filter`` setting to:

        .. parsed-literal::

            query_filter = (&(objectclass=domainrelatedobject)(associateddomain=%s)(associateddomain=*.*)(!(associateddomain=*.*.*)))

        This map will be used to look up whether a domain name is a duplet of
        components (i.e. ``example.org``, but not ``example.org.uk``). This is
        needed for the templated search base we are going to use in other maps.

    #.  Edit :file:`/etc/postfix/ldap/hosted_triplet_mydestination.cf` and
        change the ``query_filter`` setting to:

        .. parsed-literal::

            query_filter = (&(objectclass=domainrelatedobject)(associateddomain=%s)(associateddomain=*.*.*))

        This map will be used to look up whether a domain name is a triplet of
        components (i.e. ``example.org.uk``, but not ``example.org``). This is
        needed for the templated search base we are going to use in other maps.

**local_recipient_maps**

    Check if the recipient is a valid local recipient.

    The original map is at :file:`/etc/postfix/ldap/local_recipient_maps.cf`.

    #.  Copy :file:`/etc/postfix/ldap/local_recipient_maps.cf` twice:

        .. parsed-literal::

            # :command:`cp /etc/postfix/ldap/local_recipient_maps.cf \\
                /etc/postfix/ldap/hosted_duplet_local_recipient_maps.cf`

            # :command:`cp /etc/postfix/ldap/local_recipient_maps.cf \\
                /etc/postfix/ldap/hosted_triplet_local_recipient_maps.cf`

    #.  Edit :file:`/etc/postfix/ldap/hosted_duplet_local_recipient_maps.cf`,
        and replace the following two settings:

        #.  **search_base**::

                search_base = dc=%2,dc=%1

        #.  **domain**::

                domain = ldap:/etc/postfix/ldap/hosted_duplet_mydestination.cf

    #.  Edit :file:`/etc/postfix/ldap/hosted_triplet_local_recipient_maps.cf`,
        and replace the following two settings:

        #.  **search_base**::

                search_base = dc=%3,dc=%2,dc=%1

        #.  **domain**::

                domain = ldap:/etc/postfix/ldap/hosted_triplet_mydestination.cf

    #.  Adjust the Postfix **local_recipient_maps** setting to match the new
        lookup tables (line breaks for legibility):

        .. parsed-literal::

            # :command:`postconf -e local_recipient_maps=\\
                ldap:/etc/postfix/ldap/hosted_triplet_local_recipient_maps.cf,\\
                ldap:/etc/postfix/ldap/hosted_duplet_local_recipient_maps.cf`

**virtual_alias_maps**

    Translate original recipient address in to one or more target recipient
    addresses.

    This applies to, for example, a user john.doe@example.org with a secondary
    mail address of doe@example.org. **virtual_alias_maps** are responsible for
    making sure inbound traffic for doe@example.org ends up in the mailbox for
    john.doe@example.org.

    The **virtual_alias_maps** lookup tables are configured such that individual
    users, mail addresses to be forwarded elsewhere [#]_, mail-enabled
    distribution groups (static and dynamic), shared folders and possibly
    catchall addresses [#]_ are delivered to the correct mailbox(es).

    #.  Copy the original virtual alias maps lookup tables twice, each:

        .. parsed-literal::

            # for map in virtual_alias_maps \\
                    virtual_alias_maps_mailforwarding \\
                    virtual_alias_maps_sharedfolders \\
                    mailenabled_distgroups \\
                    mailenabled_dynamic_distgroups \\
                    virtual_alias_maps_catchall; do

                [ ! -f "/etc/postfix/ldap/${map}.cf" ] && continue

                cp /etc/postfix/ldap/${map}.cf \\
                    /etc/postfix/ldap/hosted_duplet_${map}.cf

                sed -r -i \\
                    -e 's|^search_base = .*$|search_base = dc=%2,dc=%1|g' \\
                    -e 's|^domain = .*$|domain = ldap:/etc/postfix/ldap/hosted_duplet_mydestination.cf|g' \\
                    /etc/postfix/ldap/hosted_duplet_${map}.cf

                cp /etc/postfix/ldap/${map}.cf \\
                    /etc/postfix/ldap/hosted_triplet_${map}.cf

                sed -r -i \\
                    -e 's|^search_base = .*$|search_base = dc=%3,dc=%2,dc=%1|g' \\
                    -e 's|^domain = .*$|domain = ldap:/etc/postfix/ldap/hosted_triplet_mydestination.cf|g' \\
                    /etc/postfix/ldap/hosted_triplet_${map}.cf

            done

    #.  Adjust the Postfix **virtual_alias_maps** setting to match the new
        lookup tables (line breaks for legibility):

        .. parsed-literal::

            # :command:`postconf -e virtual_alias_maps=\\$alias_maps,\\
                ldap:/etc/postfix/ldap/hosted_triplet_virtual_alias_maps.cf,\\
                ldap:/etc/postfix/ldap/hosted_duplet_virtual_alias_maps.cf,\\
                ldap:/etc/postfix/ldap/hosted_triplet_virtual_alias_maps_mailforwarding.cf,\\
                ldap:/etc/postfix/ldap/hosted_duplet_virtual_alias_maps_mailforwarding.cf,\\
                ldap:/etc/postfix/ldap/hosted_triplet_virtual_alias_maps_sharedfolders.cf,\\
                ldap:/etc/postfix/ldap/hosted_duplet_virtual_alias_maps_sharedfolders.cf,\\
                ldap:/etc/postfix/ldap/hosted_triplet_mailenabled_distgroups.cf,\\
                ldap:/etc/postfix/ldap/hosted_duplet_mailenabled_distgroups.cf,\\
                ldap:/etc/postfix/ldap/hosted_triplet_mailenabled_dynamic_distgroups.cf,\\
                ldap:/etc/postfix/ldap/hosted_duplet_mailenabled_dynamic_distgroups.cf,\\
                ldap:/etc/postfix/ldap/hosted_triplet_virtual_alias_maps_catchall.cf,\\
                ldap:/etc/postfix/ldap/hosted_duplet_virtual_alias_maps_catchall.cf`

**transport_maps**

    Use the outcome of **virtual_alias_maps** to determine the final delivery
    protocol and target.

    For local mailboxes, and in a default Kolab Groupware setup, this tends to
    be :file:`lmtp:unix:/var/lib/imap/socket/lmtp`.

    #.  Copy the original transport maps lookup table twice:

        .. parsed-literal::

            # :command:`cp /etc/postfix/ldap/transport_maps.cf \\
                    /etc/postfix/ldap/hosted_duplet_transport_maps.cf`

            # :command:`cp /etc/postfix/ldap/transport_maps.cf \\
                    /etc/postfix/ldap/hosted_triplet_transport_maps.cf`

    #.  Replace the same settings **search_base** and **domain**:

        .. parsed-literal::

            # :command:`sed -r -i \\
                -e 's|^search_base = .*$|search_base = dc=%2,dc=%1|g' \\
                -e 's|^domain = .*$|domain = ldap:/etc/postfix/ldap/hosted_duplet_mydestination.cf|g' \\
                /etc/postfix/ldap/hosted_duplet_transport_maps.cf`

            # :command:`sed -r -i \\
                -e 's|^search_base = .*$|search_base = dc=%3,dc=%2,dc=%1|g' \\
                -e 's|^domain = .*$|domain = ldap:/etc/postfix/ldap/hosted_triplet_mydestination.cf|g' \\
                /etc/postfix/ldap/hosted_triplet_transport_maps.cf`

            done

    #.  Adjust the Postfix **virtual_alias_maps** setting to match the new
        lookup tables (line breaks for legibility):

        .. parsed-literal::

            # :command:`postconf -e transport_maps=hash:/etc/postfix/transport,\\
                ldap:/etc/postfix/ldap/hosted_triplet_transport_maps.cf,\\
                ldap:/etc/postfix/ldap/hosted_duplet_transport_maps.cf`

        .. NOTE::

            Note that ``hash:/etc/postfix/transport`` is used to map shared@
            email addresses to the LMTP socket for local delivery, while
            the default option for **local_transport** remains
            ``local:$myhostname`` (meaning local delivery to
            :file:`/var/spool/mail/$user`).

Alias Domain Name Spaces for Hosted Kolab Domains
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For each parent domain that holds an alias domain name space, you are required
to create a copy of each of the configured mydestination, local_recipient_maps,
virtual_alias_maps and transport_maps lookup tables, and adjust its settings to
match the parent domain name space and alias domain name spaces.

If you don't, a hosted_duplet lookup for ``example.org`` might succeed if the
root dn for the organizations directory information tree is indeed
``dc=example,dc=org``, but a lookup for alias domain name spaces that also need
to be looked up against ``dc=example,dc=org`` will fail -- an alias domain name
space of ``example.com`` would end up as occurring against
``dc=example,dc=com``, which may not exist, but is definitely not the same tree.

.. NOTE::

    Please note that developments are underway to configure referrals for this
    type of setup.

A set of tables for a parent domain name space of ``example.org`` holding
alias domain name spaces ``example.com`` and ``example.de`` for example would
look as follows (three sample files included):

``/etc/postfix/ldap/example.org/mydestination.cf``::

    server_host = localhost
    server_port = 389
    version = 3
    search_base = cn=kolab,cn=config
    scope = sub

    bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
    bind_pw = Welcome2KolabSystems

    query_filter = (&(associatedDomain=%s)(associatedDomain=example.org))
    result_attribute = associateddomain

``/etc/postfix/ldap/example.org/local_recipient_maps.cf``::

    server_host = localhost
    server_port = 389
    version = 3
    search_base = cn=kolab,cn=config
    scope = sub

    domain = ldap:/etc/postfix/ldap/example.org/mydestination.cf

    bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
    bind_pw = Welcome2KolabSystems

    query_filter = (&(|(mail=%s)(alias=%s))(|(objectclass=kolabinetorgperson)(|(objectclass=kolabgroupofuniquenames)(objectclass=kolabgroupofurls))(|(|(objectclass=groupofuniquenames)(objectclass=groupofurls))(objectclass=kolabsharedfolder))(objectclass=kolabsharedfolder)))
    result_attribute = mail

``/etc/postfix/ldap/example.org/virtual_alias_maps.cf``::

    server_host = localhost
    server_port = 389
    version = 3
    search_base = cn=kolab,cn=config
    scope = sub

    domain = ldap:/etc/postfix/ldap/example.org/mydestination.cf

    bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
    bind_pw = Welcome2KolabSystems

    query_filter = (&(|(mail=%s)(alias=%s))(objectclass=kolabinetorgperson))
    result_attribute = mail

Roundcube Changes
=================

Roundcube too, by default, is configured to only operate against the primary
domain.

The settings most relevant to allowing authentication to succeed is in
:file:`/etc/roundcubemail/kolab_auth.inc.php`. At or near line 11, the
**base_dn** settings for the **kolab_auth_addressbook** needs to be configured
such that it uses the ``%dc`` placeholder (that Roundcube will substitute for
the correct root dn for the domain), using the added **domain_\*** settings:

.. parsed-literal::

    $config['kolab_auth_addressbook'] = Array(
            (...snip...)
            'base_dn'                   => 'ou=People,%dc',
            (...snip...)
            'groups'                    => Array(
                    'base_dn'           => 'ou=Groups,%dc',
            (...snip...)
            'domain_base_dn'            => 'cn=kolab,cn=config',
            'domain_filter'             => '(&(objectclass=domainrelatedobject)(associateddomain=%s))',
            'domain_name_attr'          => 'associateddomain',
            (...snip...)

You should perform the same for the **ldap_public** address book configuration
in :file:`/etc/roundcubemail/config.inc.php`.

.. rubric:: Footnotes

.. [#]

    mail forwarding

.. [#]

    catchall addresses
