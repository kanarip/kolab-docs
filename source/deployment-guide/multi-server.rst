====================================
Kolab Deployment on Multiple Servers
====================================

This deployment scenario spreads components over multiple servers for the
purpose of load-balancing, implicitly including a level of high-availability.

Each functional component in Kolab Groupware can be scaled up, and scaled down,
independent from the other components.

A single server deployment provides the following services:

*   LDAP
*   MTA
*   Storage
*   IMAP
*   Web Client Interfaces

These services can be spread out over multiple systems:

.. graphviz::

    digraph {
            "Web Server" -> "IMAP Server", "LDAP Server", "MTA Server", "Database Server" [dir=none];
            "IMAP Server" -> "LDAP Server", "Storage Server" [dir=none];
            "MTA Server" -> "LDAP Server" [dir=none];
        }

.. _deployment_multi-server-with-combined-services:

Multiple Servers with Multiple Services Each
""""""""""""""""""""""""""""""""""""""""""""

Alternatively, some services can run on one server, while other services run on
another:

.. graphviz::

    digraph {
            subgraph cluster_1 {
                    label="Kolab Server #1";
                    "Web", "Database", "MTA";
                }

            subgraph cluster_2 {
                    label="Kolab Server #2";
                    "IMAP", "LDAP", "Storage";
                }

            "Web" -> "IMAP", "LDAP", "MTA", "Database" [dir=none];
            "IMAP" -> "LDAP", "Storage" [dir=none];
            "MTA" -> "LDAP" [dir=none];
        }

.. _deployment_multi-server-for-each-service:

Multiple Servers for Each Service
"""""""""""""""""""""""""""""""""

Services can also be spread out even more, and duplicated for extra processing
power, load-balacing, redundancy and/or high-availability:

.. graphviz::

    digraph {
            subgraph cluster_1 {
                    label="Web Cluster";
                    "Web #1", "Web #2";
                }

            subgraph cluster_2 {
                    label="Database Cluster";
                    "Database #1", "Database #2";
                }

            subgraph cluster_3 {
                    label="MTA Cluster";
                    "MTA #1", "MTA #2";
                }

            subgraph cluster_4 {
                    label="LDAP Cluster";
                    "LDAP #1", "LDAP #2";
                }

            subgraph cluster_5 {
                    label="IMAP Cluster";
                    "IMAP #1", "IMAP #2";
                }

            subgraph cluster_6 {
                    label="Storage Cluster";
                    "Storage #1", "Storage #2";
                }

            "Web #1", "Web #2" -> "Database #1", "Database #2" [dir=none];
            "Web #1", "Web #2" -> "MTA #1", "MTA #2" [dir=none];
            "Web #1", "Web #2" -> "LDAP #1", "LDAP #2" [dir=none];
            "Web #1", "Web #2" -> "IMAP #1", "IMAP #2" [dir=none];

            "IMAP #1", "IMAP #2" -> "LDAP #1", "LDAP #2" [dir=none];
            "IMAP #1", "IMAP #2" -> "Storage #1", "Storage #2" [dir=none];

            "MTA #1", "MTA #2" -> "LDAP #1", "LDAP #2" [dir=none];
        }

While the :ref:`and_intro` chapter in the :ref:`and` document included a
high-level overview of functional components, in this chapter we can zoom in a
little and define the functional components by their role:

*   LDAP

    *   (write) master
    *   (read) slave
    *   (read) proxy

*   Web services

    *   Application
    *   Asset
    *   Proxy

*   Data Storage Layer
*   Databases

    *   (write) master
    *   (read) slave

*   Mail Exchangers

    *   Backend Mail Exchanger
    *   External Mail Exchanger
    *   Internal Mail Exchanger

.. To illustrate how this would look like when put into a diagram:
..
.. .. graphviz::
..
..     digraph {
..
..             "LDAP Master #1" -> "LDAP Master #2" [dir=both];
..             "LDAP Master #1", "LDAP Master #2" -> "LDAP Slave #1", "LDAP Slave #2";
..             "LDAP Slave #1", "LDAP Slave #2" -> "LDAP Proxy #1", "LDAP Proxy #2";
..
..             "LDAP Proxy #1", "LDAP Proxy #1" -> "External MX #1", "External MX #2", "Internal MX #1", "Internal MX #2", "Web Application #1", "Web Application #2", "IMAP Backend #1", "IMAP Backend #2", "IMAP Frontend #1", "IMAP Frontend #2", "IMAP Proxy #1", "IMAP Proxy #2";
..
..             "Web Application #1", "Web Application #2" -> "Database Master #1", "Database Master #2", "LDAP Master #1", "LDAP Master #2";
..             "Web Application #1", "Web Application #2" -> "Database Slave #1", "Database Slave #2";
..
..             "Client" -> "IMAP Proxy #1", "IMAP Proxy #2", "Internal MX #1", "Internal MX #2", "Web Proxy #1", "Web Proxy #2", "LDAP Proxy #1", "LDAP Proxy #2";
..
..             "Web Proxy #1", "Web Proxy #2" -> "Web Asset #1", "Web Asset #2";
..
..             "IMAP Proxy #1", "IMAP Proxy #2" -> "IMAP Frontend #1", "IMAP Frontend #2";
..
..             "IMAP Frontend #1", "IMAP Frontend #2" -> "IMAP Backend #1", "IMAP Backend #2";
..
..             "IMAP Backend #1", "IMAP Backend #2" -> "Storage Node #1", "Storage Node #2", "Storage Node #3";
..         }

Scaling LDAP Servers
====================

.. graphviz::

    digraph {
            "LDAP Write Master(s)" -> "LDAP Read Slave(s)";
            "MUA" -> "LDAP Read Slave(s)";
            "Mail Exchangers" -> "LDAP Read Slave(s)";
        }

.. graphviz::

    digraph {
            "LDAP Write Master(s)" -> "LDAP Read Slave(s)";
            "LDAP Read Slave(s)" -> "LDAP Caching Proxy(s)";
            "MUA" -> "LDAP Caching Proxy(s)";
            "Mail Exchangers" -> "LDAP Caching Proxy(s)";
        }

Scaling Web Services
====================

Role(s) for Mail Exchangers
===========================

Backend Mail Exchanger

    A backend mail exchanger is also a Cyrus IMAP backend.

    Internal mail exchangers use LDAP to look up which Cyrus IMAP backend server
    system the user's mailbox or shared folder resides on. They then relay the
    message to the backend mail exchanger for final delivery, using SMTP.

    Kolab Groupware uses SMTP by default, while using networked LMTP is another
    option.

    .. todo::

        We probably need to explain why we choose to use SMTP rather than LMTP.

        State something about pre-authorizing LMTP, it happening over the
        network, murder topologies and LMTP proxying, the use of LDAP holding
        the mailHost attribute, accounting, etc.

Internal Mail Exchanger

    *   Responsible for internal routing of email, including;

        *   Relay outbound messages to the external mail exchanger(s),
        *   Relay inbound messages to the appropriate backend mail exchanger(s),
        *   Relay messages to appropriate third party groupware or services,
        *   Expansion of distribution groups into its individual member
            recipient addresses,

    *   Optionally responsible for the application of anti-virus.

        .. NOTE::

            It is probably the responsibility of the external mail exchanger(s)
            to scan for spam messages. The internal mail exchanger(s) receive
            mail from the internal network, and from the external mail
            exchanger(s).

External Mail Exchanger

    *   Responsible for external mail routing

Splitting External & Internal Mail Exchangers
---------------------------------------------

The following diagram illustrates the split of roles for mail exchangers, and
their involvement in a deployment.

.. graphviz::

    digraph {
            "Internet" -> "External Mail Exchanger" [dir=both];
            "External Mail Exchanger" -> "Internal Mail Exchanger" [dir=both];
            "Internal Mail Exchanger" -> "Backend Mail Exchanger" [dir=both];
            "MUA" -> "Internal Mail Exchanger";
        }

In this deployment scenario, each of the roles can be fulfilled by one or more
servers. To illustrate, here's a diagram for a deployment scenario that expects
to be hammered by probably illegitimate or unsollicited mail, and does not
expect that much traffic internally:

.. graphviz::

    digraph {
            "Internet" -> "External Mail Exchanger #1";
            "Internet" -> "External Mail Exchanger #2";
            "Internet" -> "External Mail Exchanger #3";
            "External Mail Exchanger #1" -> "Internal Mail Exchanger";
            "External Mail Exchanger #2" -> "Internal Mail Exchanger";
            "External Mail Exchanger #3" -> "Internal Mail Exchanger";
            "Internal Mail Exchanger" -> "Backend Mail Exchanger";
        }

Responsibilities of an External Mail Exchanger
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The responsibilities of an external mail exchanger typically include at least:

#.  Check whether the message is supposed to be delivered within the local
    environment - at least at the domain level.
#.  Check whether the sender is trustworthy.
#.  Filtering for spam.
#.  Scanning for virusses.

In addition, the external mail exchanger may be made responsible for an initial
check on whether the intended recipient is a valid local recipient. We recommend
considering, however:

    An external mail exchanger is typically positioned in a perimeter network.

    Checking the validity of recipient addresses in the perimeter network
    implies a (fractional) copy of the LDAP directory tree is available to the
    external mail exchanger.

    Allowing nodes in a perimiter network to directly query internal LDAP
    servers is an attack vector, and you should thus consider creating a slave
    replica LDAP server in the perimeter network.

    You should consider making this replica a purposeful fractional replica, as
    to make available in the perimeter network the absolute least amount of
    information necessary for the external mail exchanger.

    Use different bind credentials on the external mail exchanger, and make sure
    no internal service accounts are replicated.

    You should, subsequently, also consider removing unnecessary indexes from
    the LDAP databases, and reduce the indexes for recipient mail address
    attributes (*mail*, for example, has an index for presence, substring
    presence and equality, with the substring presence being unnecessary).

Balancing Client Connections to Services
========================================

Aside from a number of appliances to this purpose, one can implement
load-balancing with implied high-availability if the Kolab Groupware functional
components or roles are each installed on at least two systems.

Multiple functional components may be installed on a single system.

.. CAUTION::

    Most appliances, like this solution based on keepalived, will need the
    clients connected on failover or failback to reconnect to the new system to
    which the service IP address in use is attached.

1.  Two LDAP servers are installed in multi-master replication mode:

    * Server #1 has a system IP address of **192.168.122.1**.
    * Server #2 has a system IP address of **192.168.122.2**.

2.  Both systems run **keepalived**.

    *   Server #1 is the designated master for the **192.168.122.3** service IP
        address (with priority 200 over 100), and
    *   Server #2 is the designated master for the  **192.168.122.4** service IP
        address (with priority 200 over 100).

3.  The **keepalived** service has been configured to check the health of the
    local system's LDAP service, and substract 101 from its priority should its
    health check fail.

In a normal situation, Server #1 holds the .3 service IP address, while Server
#2 holds the .4 service IP address.

4.  DNS for ``example.org`` has been configured to hold two IN A records for
    ``ldap.example.org``:

    *   192.168.122.3
    *   192.168.122.4

5.  The client system requests the IN A for ``ldap.example.org``:

    .. graphviz::

        digraph {
                rankdir=LR;
                "Client" -> "DNS Server" [label="IN A ldap.example.org"];
                "DNS Server" -> "Client" [label="192.168.122.3, 192.168.122.4"];
            }

6.  The client connects to one (semi-randomly selected) of the resulting IP
    addresses:

    .. graphviz::

        digraph {
                rankdir=LR;
                "Client" -> "192.168.122.3";
            }

7.  Which server this connection ends up with depends on the health of Server #1
    and #2.

    In a normal situation:

    .. graphviz::

        digraph {
                rankdir=LR;
                "Client" -> "192.168.122.3 @ Server #1";
            }

    and:

    .. graphviz::

        digraph {
                rankdir=LR;
                "Client" -> "192.168.122.4 @ Server #2";
            }

    Should Server #1 fail (its local LDAP service health check(s)):

    .. graphviz::

        digraph {
                rankdir=LR;
                "Client" -> "192.168.122.3 @ Server #2";
            }

    and:

    .. graphviz::

        digraph {
                rankdir=LR;
                "Client" -> "192.168.122.4 @ Server #2";
            }
