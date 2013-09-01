======================================
Configuring the Kolab Groupware Server
======================================

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

.. rubric:: Example local_recipient_maps.cf with Templated Search Base

.. parsed-literal::

    server_host = localhost
    server_port = 389
    version = 3
    **search_base = dc=%2,dc=%1**
    scope = sub

    domain = ldap:/etc/postfix/ldap/mydestination.cf

    bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
    bind_pw = pass

    query_filter = (&(\|(mail=%s)(alias=%s))(\|(objectclass=kolabinetorgperson)(...)))
    result_attribute = mail
