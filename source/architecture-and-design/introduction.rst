.. _and_intro:

============
Introduction
============

Kolab Groupware is a scalable, flexible and :term:`made-to-measure`
collaboration suite and groupware solution, designed with security, privacy and
integrity in mind.

Kolab Groupware is Free Software, uses other Free Software, and stores and
accesses information using Open Standards.

The design of Kolab distinguishes the following functional components to make up
the groupware environment:

#. An (centralized) :ref:`and_intro_authentication-and-authorization` database.
#. A :ref:`and_intro_mail-exchanger` for the exchange of messages.
#. A :ref:`and_intro_data-storage-layer`.
#. One or more (additional) :ref:`and_intro_storage-layer-access-protocols`.
#. One or more :ref:`and_intro_desktop-clients`.
#. One or more :ref:`and_intro_mobile-clients`.
#. One or more :ref:`and_intro_web-interfaces`.

.. #. Instant Messaging
.. #. Voice and Video (-Conferencing)

Furthermore, the Kolab Groupware environment offers functionality beyond the
exchange of regular email messages, such as calendaring, maintaining address
books, task management, journaling, and more.

All of this should be secure [#]_, scalable [#]_ and flexible [#]_. It must also
use Open Standards for protocols and storage formats to provide the user the
freedom to walk away with their data, respect the privacy of its users,
meanwhile protect organizations' interests.

Welcome to Kolab Groupware!

.. _and_intro_authentication-and-authorization:

Authentication and Authorization
================================

Kolab Groupware uses LDAP for authentication and authorization of users, while
it also includes user and group membership information.

The use of LDAP allows the structuring of information in such a way that it
enables the delegation of authority over its entries, can prevent users from
accessing certain attributes or entries, and allows the groupware solution to
scale to over several millions of users -- ideal for groupware environments.

Please note that at the very core of the Kolab Groupware design is that Kolab
**consumes** information in LDAP, but does not ship its own version of LDAP.

A default installation of Kolab Groupware includes LDAP schema extensions that
provide additional functionality such as delegation and mandatory SMTP Access
Policy enforcement, but does not require these extensions be loaded.

It should also be noted that Kolab, in principle, runs on a
:term:`sealed system`.

.. seealso::

    For more information on LDAP integration in Kolab Groupware, please refer to:

    *   :ref:`and_ldap_389-directory-server`
    *   :ref:`and_ldap_openldap`

.. _and_intro_mail-exchanger:

Mail Exchanger
==============

Integrated with the :ref:`and_intro_authentication-and-authorization` database,
the mail exchanger in Kolab Groupware is in charge of exchanging messages
between Kolab Groupware users, mailing lists and distribution groups, third
party groupware environments and the internet.

The mail exchanger component is also responsible for anti-spam and anti-virus
measures, protecting your environment against ill-intended distractions.

Kolab Groupware integrates `Postfix <http://postfix.org>`_ by default, and
provides it with additional security and integrity checks, such as the
:ref:`and_mta_kolab-smtp-access-policy`.

Kolab's default configuration of the mail exchanger includes the use of lookup
ables against the :ref:`and_intro_authentication-and-authorization` database.

.. seealso::

    *   :ref:`and_mta_postfix`
    *   :ref:`and_mta_kolab-smtp-access-policy`

.. _and_intro_data-storage-layer:

Data Storage Layer & Primary Access Protocol
============================================

A data storage layer for groupware environments must be fast, efficient,
scalable and secure.

A single system can only scale up as far as its local resources allow it to --
called vertical scaling -- not unlike physical matter, there can only be a
finite amount of resources in one place at any given one point in time.

It is therefore a pre-requisite the storage layer can be spread out over
multiple individual systems, while maintaining a transparent access methodology
for users - whom do not know what data is where, and even if they did, tend to
forget about it.

The data storage layer must also be accessible remotely. For this purpose, you
require a well defined, widely implemented network protocol that can deliver
fast synchronization of large amounts of data with its clients, understands the
concepts of folders and folder hierarchies, access control, quota, and can
handle parallel access.

In Kolab Groupware, this data storage layer is the IMAP spool, accessible by any
client software that speaks the IMAP protocol.

Kolab Groupware ships `Cyrus IMAP <http://cyrusimap.org>`_ by default, which,
with its so-called murder topology, provides the aforementioned transparent
access to IMAP spools spread out over multiple individual systems.

This optional murder topology allows users of an environment to share groupware
content amongst themselves, even though the content may reside on different
backend systems.

.. seealso::

    *   :ref:`deployment_imap_cyrus-imap-murder`

.. _and_intro_desktop-clients:

Desktop Clients
===============

Although the Kolab web client is powerful and fast, some users might want to use
native Desktop clients. There is a variety of Desktop clients compatible with the
Kolab Groupware solution. They include:

*   The Kolab Client `Kontact <http://kontact.org>`_

    *   Available for Microsoft Windows, GNU/Linux and Apple Mac OS X
    *   With full Off-line support
    *   Automatic Configuration
    *   Thousands of features
    *   Mobile edition for touchscreen devices available

*   `Thunderbird <http://thunderbird.org>`_ with Lightning

    *   Available for Microsoft Windows, Apple Mac OS X and GNU/Linux

.. versionadded:: Kolab 3.1

    *   Apple Mail, Address book and Apple Calendar (previously iCal)

*   Microsoft Outlook

.. versionadded:: Kolab 3.0

    *   using `Bynari connector <http://www.bynari.com>`_

.. versionadded:: Kolab 3.1, Outlook 2013

    *   ActiveSync

* Evolution

.. _and_intro_mobile-clients:

Mobile Clients
==============

All ActiveSync capable devices can be used to connect to Kolab and retrieve groupware data.
This includes Android and Apple as well as the latest Blackberry devices.

Special security features for mobile clients such as policy enforcement, credential separation
and remote wipe can be implemented with Kolab using ActiveSync.

If for some reason ActiveSync is not supported on the device, the CalDAV and CardDAV
protocols can be used instead as a fall back.


.. _and_intro_storage-layer-access-protocols:

Storage Layer Access Protocols
==============================

The following protocols provide access to the groupware data in a Kolab
Groupware environment:

*   POP3
*   IMAP4

.. versionadded:: Kolab 3.0

    *   ActiveSync

.. versionadded:: Kolab 3.1

    *   CalDAV
    *   CardDAV
    *   WebDAV

.. _and_intro_web-interfaces:

Web Interfaces
==============

* :ref:`and-kolab_wap_api`
* Kolab Web Client
* Hosted Kolab Customer Control Panel
* Chwala File Management
* Mobile Device Synchronization

.. _and_intro_overview-functional-components:

Overview of Functional Components
=================================

The following diagram provides a high-level overview of functional components
and their connections and interactions with one another. For a fully detailed
picture, we'll need to zoom in to the level of functional components themselves,
and their individual interactions with other functional components.

.. graphviz::

    digraph overview {
            "Desktop Client";
            "Mobile Device";
            "Web Client" [fontcolor=darkgreen];
            "Administration Panel" [color=red,fontcolor=darkgreen];
            "ActiveSync" [color=red,fontcolor=darkgreen];
            "DAV Access" [color=red,fontcolor=darkgreen];
            "IMAP" [fontcolor=darkgreen];
            "LDAP" [fontcolor=darkgreen];
            "MTA" [fontcolor=darkgreen];
            "Daemon" [color=red,fontcolor=darkgreen];
            "Resource Scheduler" [color=red,fontcolor=darkgreen];

            "User" -> "Desktop Client", "Desktop Browser", "Mobile Device";
            "Desktop Browser" -> "Web Client", "Administration Panel";
            "Mobile Device" -> "ActiveSync", "DAV Access", "IMAP";

            "Desktop Client" -> "IMAP", "LDAP", "MTA", "DAV Access" [color=purple];
            "DAV Access" -> "IMAP", "LDAP", "MTA" [color=pink];
            "Web Client" -> "IMAP", "LDAP", "MTA" [color=blue];
            "ActiveSync" -> "IMAP", "LDAP", "MTA" [color=yellow];
            "MTA" -> "LDAP", "IMAP";
            "LDAP" -> "Daemon" -> "IMAP";
            "Daemon" -> "LDAP";
            "MTA" -> "Resource Scheduler" -> "MTA", "LDAP", "IMAP";

            "Administration Panel" -> "LDAP";
        }

Legend:

*   The Red circles indicate components provided exclusively as part of Kolab
    Groupware.

*   Components in a Dark Green font color are server-side components.

.. NOTE::

    The web client -- Roundcube, to which Kolab Systems contributes
    substantially -- provides Kolab Groupware capabilities in addition to the
    Roundcube core capabilities through plugins.

.. NOTE::

    Desktop clients that Kolab Systems actively contributes to and supports
    include Kontact (KDE PIM).

.. rubric:: Footnotes

.. [#] **Security**

    **Beware of snake-oil vendors**, whom may tempt you to choose for a model
    that encrypts data on the server using a fundamentally flawed model,
    sometimes called *"the averting eyes promise"*, more clearly explained on
    http://arstechnica.com/security/2013/11/op-ed-a-critique-of-lavabit/.

.. [#] **Scalability**

    Both vertical as well as horizontal scalability are features of an elastic
    computing environment -- whether automatic (aka "cloud") or manual.

    The scaling of a deployed solution is best applied to each individual
    functional component separately, for the number of web servers your
    deployment needs at any given point does not directly correspond with the
    amount of mail exchangers your deployment needs (at that point or
    otherwise).

.. [#] **Flexibility**

    While, contrary to popular belief, most environments could run the majority
    of their infrastructure on standard systems and with standard applications,
    in contradiction not even two such standard environments are alike.

    A solution that is capable of adapting to the new environment is clearly
    much more flexible -- this does require a good understanding of the intended
    architecture of the solution, and a well-defined deployment use-case to
    adapt to.
