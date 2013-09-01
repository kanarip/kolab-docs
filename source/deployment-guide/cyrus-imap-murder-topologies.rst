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

The Cyrus IMAP Murder Use-Case
------------------------------

.. todo::

    Document what exactly a Cyrus IMAP Murder offers in terms of features.

Other Scaling Options with Cyrus IMAP
-------------------------------------

.. todo::

    Insert the NGINX proxy use case and put it in light of the murder use-case.

Discrete Murder
---------------

A Cyrus IMAP Discrete Murder topology separates frontends from backends.

The Mail User Agent (MUA) connects to a frontend, and is proxied to *backend1*
for the user's own mailbox, or *backend2* for a shared mailbox that resides on
that server.

.. graphviz::

    digraph murder_discrete {
            "MUA" -> "frontend" [ label = "client connection" ];
            "frontend" -> "INBOX" [ label = "proxied connection" ];
            "frontend" -> "shared/memo" [ label = "proxied connection" ];
        }

Unified Murder
--------------

In a Unified Cyrus IMAP Murder, all systems perform both the frontend as well as
the backend function. This means a user may connect to any backend, and be
proxied to other backends as needed.

.. graphviz::

    digraph murder_unified {
            rankdir=LR;
            "MUA" -> "john.doe@example.org" [ label = "client connection" ];
            "john.doe@example.org" -> "john.doe@example.org" [ label = "INBOX is local" ];
            "john.doe@example.org" -> "shared/memo" [ label = "proxied connection" ];
        }

A large unified murder is often fronted by NGINX IMAP proxies, so that the user
is initially proxied to the backend that holds the user's INBOX.

.. todo:: Write more about fronting a murder with NGINX IMAP proxies.

Replicated Murder
-----------------

.. todo:: Include a topology diagram for a Cyrus IMAP replicated murder topology

