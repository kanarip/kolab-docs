.. _deployment_imap_cyrus-imap-murder:

============================
Cyrus IMAP Murder Topologies
============================

A Cyrus IMAP Murder is an aggregate of multiple Cyrus IMAP servers, providing
transparent access to mailboxes throughout the murder.

For the purpose of this documentation, the following terminology needs to be
outlined:

frontend

    A Cyrus IMAP frontend is a functional component that receives connections
    from clients, and proxies those to the backend on which the relevant mailbox
    resides.

    .. NOTE::

        Please note that a frontend proxies the connection on a per-mailbox
        level (as needed). As such, the client connection is *terminated* at the
        frontend, the frontend *interprets* the protocol, and decides what
        backend to create a *new* connection to (if needed).

backend

    A Cyrus IMAP backend is the functional component that actually holds and
    maintains a mail spool containing mailboxes and messages.

mupdate

    To aggregate various backends, compose a single authoritative list of
    mailboxes available throughout the murder, and communicate these to the
    frontends, a Cyrus IMAP murder requires a server to be the mupdate master.

.. The Cyrus IMAP Murder Use-Case
.. ==============================
..
.. .. todo::
..
..     Document what exactly a Cyrus IMAP Murder offers in terms of features.
..
.. Other Scaling Options with Cyrus IMAP
.. =====================================
..
.. .. todo::
..
..     Insert the NGINX proxy use case and put it in light of the murder use-case.

Discrete Murder
===============

A Cyrus IMAP Discrete Murder topology separates frontends from backends.

As illustrated in the next diagram, the Mail User Agent (MUA) connects to a
frontend, and is proxied to *backend1* for the user's own mailbox, or *backend2*
for a shared mailbox that resides on that server.

.. graphviz::

    digraph murder_discrete {
            "MUA" -> "frontend" [ label = "client connection" ];
            "frontend" -> "INBOX" [ label = "proxied connection" ];
            "frontend" -> "shared/memo" [ label = "proxied connection" ];
        }

In such a deployment scenario, the daemon responsible for synchronizing changes
made to LDAP with IMAP, called **kolabd**, recognizes the topology of a murder
and assures the LDAP ``mailHost`` attribute is set to the correct value -- the
FQDN [#]_ of the backend system the mailbox is hosted on.

.. seealso::

    *   :ref:`deployment_discrete-cyrus-imapd-considerations`

.. Unified Murder
.. ==============
..
.. In a Unified Cyrus IMAP Murder, all systems perform both the frontend as well as
.. the backend function. This means a user may connect to any backend, and be
.. proxied to other backends as needed.
..
.. .. graphviz::
..
..     digraph murder_unified {
..             rankdir=LR;
..             "MUA" -> "john.doe@example.org" [ label = "client connection" ];
..             "john.doe@example.org" -> "john.doe@example.org" [ label = "INBOX is local" ];
..             "john.doe@example.org" -> "shared/memo" [ label = "proxied connection" ];
..         }
..
.. A large unified murder is often fronted by NGINX IMAP proxies, so that the user
.. is initially proxied to the backend that holds the user's INBOX.
..
.. .. todo:: Write more about fronting a murder with NGINX IMAP proxies.
..
.. Replicated Murder
.. =================
..
.. .. todo:: Include a topology diagram for a Cyrus IMAP replicated murder topology

.. _deployment_discrete-cyrus-imapd-considerations:

Deployment Considerations for a Discrete Cyrus IMAP Murder Topology
===================================================================

In a Cyrus IMAP Discrete Murder topology, inbound as well as outbound [#]_ email
messages need to be routed to and from the IMAP backend server, that hosts the
mailbox to which the email is to be delivered.

Similarly, backends need to be configured such that they do not find themselves
authoritative for the entire domain -- as part of the recipients is hosted on
other backends -- and use the ''smart'' internal MTA to relay messages to.

.. graphviz::

    digraph murder_discrete {
            subgraph cluster_backend1 {
                    label = "backend1";
                    "John";
                }

            subgraph cluster_backend2 {
                    label = "backend2";
                    "Jane";
                }

            "MTA (Internal)" -> "John", "Jane" [label="inbound"];
            "John", "Jane" -> "MTA (Internal)" [label="outbound"];
            "MTA (Internal)" -> "MTA (Internet)" [dir=both];
        }

The *MTA (Internal)* can use a lookup table for local recipients (valid
recipient addresses in any of the :term:`mydestination` or :term:`relay_domains`
domain name spaces), that routes (instead of delivers) the message through to
the correct backend (called a *transport map*), using the LDAP ``mailHost``
attribute value for entries.

To configure such transport map lookup table, adjust the contents of the
following snippet to suite your deployment and save it to
:file:`/etc/postfix/ldap/transport_maps.cf` -- this file could exist already,
likely with a ``result_attribute`` value of ``mail``, and a ``result_format``
value of ``lmtp:unix:/var/lib/imap/socket/lmtp``:

.. parsed-literal::

    server_host = ldap.example.org
    server_port = 389
    version = 3
    search_base = dc=example,dc=org
    scope = sub
    domain = example.org
    bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
    bind_pw = Welcome2KolabSystems
    query_filter = (&(mail=%s)(\|(objectclass=kolabinetorgperson)(objectclass=kolabsharedfolder)))
    result_attribute = mailHost
    result_format = smtp:[%s]:25

.. NOTE::

    By the time the *MTA (Internal)* queries the transport map, any secondary
    email address should have already been translated to a final recipient
    email address (primary email address), for which Kolab uses *virtual alias
    maps* by default.

The *MTA (Internal)* now needs to be configured to use this transport map:

.. parsed-literal::

    # postconf -e transport_maps=ldap:/etc/postfix/ldap/transport_maps.cf
    # service postfix reload

The *MTA (Internal)* will now attempt delivery for John to backend1, and for
Jane to backend2.

The backends' MTA now needs to be configured to consider part of
:term:`mydestination` local -- the local mailboxes -- and part of
:term:`mydestination` remote -- the mailboxes on the other backend(s). This
consists of three parts:

#.  Setting the **local_recipient_maps**, line-breaks for legibility:

    .. parsed-literal::

        server_host = ldap.example.org
        server_port = 389
        version = 3
        search_base = dc=example,dc=org
        scope = sub
        domain = example.org
        bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
        bind_pw = Welcome2KolabSystems

        query_filter = (& \\
                (\|(mail=%s)(alias=%s)) \\
                (\|(objectclass=kolabinetorgperson)(\|(objectclass=kolabgroupofuniquenames)(objectclass=kolabgroupofurls))(\|(\|(objectclass=groupofuniquenames)(objectclass=groupofurls))(objectclass=kolabsharedfolder))(objectclass=kolabsharedfolder)) \\
                (mailHost=<%= fqdn -%>) \\
            )

        result_attribute = mail

    .. NOTE::

        The most important to take away from this is to make local recipient
        maps for the backend only include those LDAP entries for which the
        ``mailHost`` attribute is the same value as the system's FQDN.

#.  Setting the **transport_maps**, in (for example) :file:`/etc/postfix/ldap/transport_maps.cf`:

    .. parsed-literal::

        server_host = ldap.example.org
        server_port = 389
        version = 3
        search_base = dc=example,dc=org
        scope = sub
        domain = example.org
        bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
        bind_pw = Welcome2KolabSystems
        query_filter = (&(\|(alias=%s)(mail=%s))(objectclass=kolabinetorgperson)(mailhost=<%= fqdn -%>))
        result_attribute = mail
        result_format = lmtp:unix:/var/lib/imap/socket/lmtp

    .. NOTE::

        Here too the most important part is to only transfer over the local LMTP
        socket, only those messages intended for recipients with mailboxes
        locally hosted -- Those LDAP entries for which the ``mailHost``
        attribute is the same value as the system's FQDN.

    For delivery to shared folders, an additional lookup table for transport
    maps is needed (save as :file:`/etc/postfix/transport`):

    .. parsed-literal::

        shared@example.org  lmtp:unix:/var/lib/imap/socket/lmtp

    Execute the following commands to activate:

    .. parsed-literal::

        # :command:`postmap /etc/postfix/transport`
        # :command:`postconf -e transport_maps=ldap:/etc/postfix/ldap/transport_maps.cf,hash:/etc/postfix/transport`
        # :command:`service postfix reload`

#.  Setting the **relayhost**, and redirect all mailboxes for locally hosted
    domains not hosted on the local server to the smart host(s):

    .. parsed-literal::

        # :command:`postconf -e local_transport=relay:[smtp.example.org]:25`
        # :command:`postconf -e relayhost=[smtp.example.org]`
        # :command:`service postfix reload`

.. rubric:: Footnotes

.. [#]

    It is actually not the FQDN of the system the mailbox is hosted on, but the
    value of the ``servername`` setting in :manpage:`imapd.conf(5)` that is
    used.

.. [#]

    *Outbound* messages in this context include vacation responses, forwards to
    colleagues, and such (automated) message traffic.

