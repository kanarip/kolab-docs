======================================================
Archival, Backup, Data-Loss Prevention and e-Discovery
======================================================

Different challenges could potentially be resolved by implementing a
single solution, providing each of the functional aspects in an
integrated fashion.

A brief overview of the functional components:

**Archival**

    Archival is the retention of business records, in a fashion that
    allows them to be used as evidence.

    Many archival solutions only include actual communications that
    descend over an SMTP server that can keep the archival solution in
    the loop.

**Backup**

    Backup is the lesser part to the ability to restore, a frequently
    occuring, everyday event.

    It is often requested backup happens on a per-mailbox or even
    per-message level.

**Data-Loss Prevention**

**e-Discovery**

    Maintenance of a changelog on object entries that can change state
    (email read/deleted), or are volatile (changes to an appointment).

Functional Requirements
=======================

**Audit Trail**

**Item Changelog**

    A per-item changelog, of whom changed what, to what item, and when.

**Queue ID Chasing**

    Chase so-called Queue IDs for messages being exchanged with the
    outside world, and internally between systems throughout the
    deployment.

Functional Design
=================

Functional Components
---------------------

**Dealer**

    A dealer is a script executed once for each event notification, used
    to receive the initial event notification from Cyrus IMAP 2.5, and
    broadcast the event on to the message bus or queue.

    The dealer awaits confirmation of a broker having received the
    event notification.

**Broker**

    A broker retrieves the notifications from the message bus or queue,
    and acknowledges having received the event notification.

    The event notification is put in to a persistent queue, awaiting
    workers to become ready for handling the event notification.

**Worker**

    The worker is where the processing happens -- one can have as many
    workers as necessary, or as few as required.

    The worker announces its presence to the broker, which subsequently
    assigns jobs to the worker [#]_.

    The worker may require additional information to be obtained, such
    as the message payload [#]_.

**Collector**

    The collector daemon is an optional component subscribing to
    requests for additional information that can only reliably be
    obtained from a Cyrus IMAP backend spool directory.

**System Log Centralization**

    The centralization of system log files such as
    :file:`/var/log/maillog` aids in tracing the exchange of messages as
    they descend across infrastructure, and helps in associating, for
    example, a Login event to an IMAP frontend with the corresponding
    web server session [#]_.

Operational Requirements
========================

    .. graphviz::

        digraph {
                rankdir = LR;
                splines = true;
                overlab = prism;

                edge [color=gray50, fontname=Calibri, fontsize=11];
                node [shape=record, fontname=Calibri, fontsize=11];

                subgraph cluster_broker {
                        label="broker";

                        "client_router";
                        "collector_router";
                        "worker_router";
                        "controller_router";

                        "queue";

                        "client_router" -> "queue" -> "controller_router" -> "worker_router";
                    }

                subgraph cluster_worker {
                        label="worker";

                        "worker";
                        "controller";
                    }

                subgraph cluster_imap {
                        label="imap server";
                        "collector";
                        "dealer";
                    }

                "client_router" -> "*:5570";
                "collector_router" -> "*:5569";
                "worker_router" -> "*:5560";
                "controller_router" -> "*:5561";

                "*:5560" -> "worker" [dir=back];
                "*:5561" -> "controller" [dir=back];

                "*:5569" -> "collector" [dir=back];
                "*:5570" -> "dealer" [dir=back];
            }



.. _and-bonnie-broker-worker-interaction:

Broker -- Worker Interaction
============================

When the broker starts up, it creates three listener sockets:

#.  A client router,

    used for incoming event notifications from IMAP servers.

#.  A worker router,

    used to exchange job information with workers.

#.  A control router,

    used to exchange worker and job state information.

When the worker starts, it connects to both the control router and
worker router.

#.  Using the controller channel, the worker let's the broker know it is
    ready to receive a job.

    .. graphviz::

        digraph {
                rankdir = LR;
                splines = true;
                overlab = prism;

                edge [color=gray50, fontname=Calibri, fontsize=11];
                node [shape=record, fontname=Calibri, fontsize=11];

                "broker" -> "worker" [label="READY",dir=back];
            }

    *   The broker adds the worker to its list of workers.

    *   The broker will continue to receive occasional messages from the
        worker to allow it to determine whether or not it is still
        available.

#.  The broker, maintaining a queue of jobs to assign to workers, let's
    the worker know about a job -- again using the controller channel.

    .. graphviz::

        digraph {
                rankdir = LR;
                splines = true;
                overlab = prism;

                edge [color=gray50, fontname=Calibri, fontsize=11];
                node [shape=record, fontname=Calibri, fontsize=11];

                "broker" -> "worker" [label="TAKE $ID"];
            }

#.  The worker internally triggers the retrieval of the job using the
    worker channel.

    .. graphviz::

        digraph {
                rankdir = LR;
                splines = true;
                overlab = prism;

                edge [color=gray50, fontname=Calibri, fontsize=11];
                node [shape=record, fontname=Calibri, fontsize=11];

                "broker" -> "worker" [label="GET $ID",dir=back];
            }

#.  The worker is now in state BUSY and must respond within a set
    interval or the broker will set the job back in to PENDING state,
    and mark the worker as unavailable.

.. _and-bonnie-worker-design:

Worker Design
=============

The worker is built out of plugins, that subscribe to an event type,
where event types available are listed in
:ref:`and-bonnie-event-notification-types`.

Each event type individually may require handling -- for example, a
logout event is associated with the corresponding login event.

The following components will be pluggable and configurable:

*   subscribing to a message bus or queue, as ``inputs``, initially
    including only ``zmq``.

*   event handling, as ``handlers``, initially including only
    ``changelog``, ``freebusy``, and one handler per event notification
    type.

*   result output, as ``output``, initially including only
    ``elasticsearch``.

*   storage for transactions pending, as ``storage``, initialy including
    only ``elasticsearch``.

Assuming an installation path of :file:`bonnie/worker/`, the following
depicts its tree layout:

.. parsed-literal::

    handlers/
        `-  changelog/
        `-  freebusy/
        `-  mailboxcreate.py
    inputs/
        `-  zmq_input.py
    outputs/
        `-  elasticsearch_output.py
    storage/
        `-  elasticsearch_storage.py
    constants.py

To take the changelog and freebusy handlers as an example, the following
event notification types may need to be subscribed to.

:ref:`and-bonnie-event-mailboxcreate`

    A new mailbox that is an event folder may have been created.

    The initial event is handled by the base handler for the event
    notification type.

    Passing this event right through to the changelog handler would make
    it require obtaining the ``/shared/vendor/kolab/folder-type`` and/or
    ``/private/vendor/kolab/folder-type`` metadata value(s) in order to
    determine whether the folder indeed is an event folder.

    However, the setting of metadata is an event separate from the
    mailbox creation, and at the moment the handler receives the initial
    event notification, the metadata may not have been set yet.

    .. NOTE::

        At the time of this writing, no separate event notification for
        setting folder-level METADATA exists.

:ref:`and-bonnie-event-mailboxdelete`

    A mailbox that was an event folder may have been deleted.

:ref:`and-bonnie-event-mailboxrename`

    A mailbox that was an event folder may have been renamed.

:ref:`and-bonnie-event-messageappend`

    Only applicable to event folders, this depicts a new or updated
    version of an existing event has been appended.

:ref:`and-bonnie-event-messagecopy`

    One or more events may have been copied from an event folder into
    another event folder.

:ref:`and-bonnie-event-messagemove`

    One or more events may have been moved from one event folder into
    another event folder.

.. NOTE::

    Plugins that are interested in the vendor/kolab/folder-type METADATA
    value(s) of a folder should register a hook into the various mailbox
    related event handlers, which can then be made responsible of
    retrieving the associated information and issuing a callback.

.. graphviz::

    digraph event_notification_flow {
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [shape=record, fontname=Calibri, fontsize=11];

            "bus/queue" -> "worker" -> "thread pool";
            "thread pool" -> "thread" -> "non-base handlers" [label="register_hooks()"];
            "non-base handlers" -> "thread";
            "thread" -> "base handlers" [label="handle_event()"]
            "base handlers" -> "thread";
        }

.. _and-bonnie-event-notification-types:

Event Notification Types
========================

Event types available include, in alphabetical order:

#.  :ref:`and-bonnie-event-flagsclear`
#.  :ref:`and-bonnie-event-flagsset`
#.  :ref:`and-bonnie-event-login`
#.  :ref:`and-bonnie-event-logout`
#.  :ref:`and-bonnie-event-mailboxcreate`
#.  :ref:`and-bonnie-event-mailboxdelete`
#.  :ref:`and-bonnie-event-mailboxrename`
#.  :ref:`and-bonnie-event-mailboxsubscribe`
#.  :ref:`and-bonnie-event-mailboxunsubscribe`
#.  :ref:`and-bonnie-event-messageappend`
#.  :ref:`and-bonnie-event-messagecopy`
#.  :ref:`and-bonnie-event-messageexpire`
#.  :ref:`and-bonnie-event-messageexpunge`
#.  :ref:`and-bonnie-event-messagemove`
#.  :ref:`and-bonnie-event-messagenew`
#.  :ref:`and-bonnie-event-messageread`
#.  :ref:`and-bonnie-event-messagetrash`
#.  :ref:`and-bonnie-event-quotaexceeded`
#.  :ref:`and-bonnie-event-quotawithin`
#.  :ref:`and-bonnie-event-quotachange`

.. _and-bonnie-event-flagsclear:

FlagsClear
----------

This event notification type indicates one or more messages have had its
flags cleared.

Flags having been cleared may include ``\Seen``, but also ``\Deleted``,
and any custom other flag on an IMAP message.

Subscribe to this notification for:

*   Backup/Restore
*   e-Discovery

.. _and-bonnie-event-flagsset:

FlagsSet
--------

Subscribe to this notification for:

*   Backup/Restore
*   e-Discovery

.. _and-bonnie-event-login:

Login
-----

Additional information to obtain for this event notification type:

*   The persistent unique attribute for the user object.
*   Additional LDAP object attributes.

Information storage:

*   This event needs to be stored until it can be associated with a
    :ref:`and-bonnie-event-logout` event notification type.

Subscribe to this notification for:

*   e-Discovery

.. _and-bonnie-event-logout:

Logout
------

Subscribe to this notification for:

*   e-Discovery

.. _and-bonnie-event-mailboxcreate:

MailboxCreate
-------------

Additional information to obtain

.. _and-bonnie-event-mailboxdelete:

MailboxDelete
-------------

.. _and-bonnie-event-mailboxrename:

MailboxRename
-------------

.. _and-bonnie-event-mailboxsubscribe:

MailboxSubscribe
----------------

.. _and-bonnie-event-mailboxunsubscribe:

MailboxUnsubscribe
------------------

.. _and-bonnie-event-messageappend:

MessageAppend
-------------

.. _and-bonnie-event-messagecopy:

MessageCopy
-----------

.. _and-bonnie-event-messageexpire:

MessageExpire
-------------

.. _and-bonnie-event-messageexpunge:

MessageExpunge
--------------

.. _and-bonnie-event-messagemove:

MessageMove
-----------

.. _and-bonnie-event-messagenew:

MessageNew
----------

.. _and-bonnie-event-messageread:

MessageRead
-----------

.. _and-bonnie-event-messagetrash:

MessageTrash
------------

.. _and-bonnie-event-quotaexceeded:

QuotaExceeded
-------------

.. _and-bonnie-event-quotawithin:

QuotaWithin
-----------

.. _and-bonnie-event-quotachange:

QuotaChange
-----------

An Integrated Solution
======================

The following aspects of an environment need to be tracked;

*   Logs such as ``/var/log/maillog``, which contain the information
    about exchange of messages between internal and external systems and
    software (Postfix/LMTP -> Cyrus IMAP).

*   Cyrus IMAP 2.5 Events broadcasted.

.. graphviz::

    digraph {
            subgraph cluster_imap {
                    width = 7.0;
                    "IMAP #" [shape=rectangle];
                    "IMAP 2" [shape=rectangle];
                    "IMAP 1" [shape=rectangle];
                }

            "Message Bus" [shape=rectangle,width=7.0];

            "IMAP #" -> "Message Bus";
            "IMAP 2" -> "Message Bus";
            "IMAP 1" -> "Message Bus";

            subgraph cluster_subscribers {
                    width = 7.0;
                    "Archival" [shape=rectangle];
                    "Backup" [shape=rectangle];
                    "Data-Loss Prevention" [shape=rectangle];
                    "e-Discovery" [shape=rectangle];
                }

            "Message Bus" -> "Archival";
            "Message Bus" -> "Backup";
            "Message Bus" -> "Data-Loss Prevention";
            "Message Bus" -> "e-Discovery";

            "NoSQL Storage" [shape=rectangle,width=3.0];
            "SQL Storage" [shape=rectangle,width=3.0];

            "Archival", "Backup", "Data-Loss Prevention", "e-Discovery" -> "NoSQL Storage", "SQL Storage";
        }

In this picture, IMAP (using Cyrus IMAP 2.5) issues so-called
:term:`event notifications` to a message bus, that can be picked up by the
appropriate subscribers.

Note that the subscribers are different components to plug in and enable, or
leave out -- not everyone has a need for Archival and e-Discovery capabilities.

As such, a component plugged in could announce its presence, and start working
backwards as well as start collecting the relevant subsets of data in a retro-
active manner.

.. graphviz::

    digraph event_notification {
            rankdir = LR;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [shape=record, fontname=Calibri, fontsize=11];

            "subscriber";
            "message bus" [height=2.0];
            "daemon";
            "publisher";

            "subscriber" -> "message bus" [label="announces presence"];
            "daemon" -> "message bus" [label="presence announcement", dir=back];
            "daemon" -> "message bus" [label="works backwards"];
            "publisher" -> "message bus" [label="event notifications"];

        }

To allow scaling, the intermediate medium is likely a message bus such
as ActiveMQ, AMQP, ZeroMQ, etc.

Between Cyrus IMAP 2.5 and the message bus must be a thin application
that is capable of:

*   Retrieving the payload of the message(s) involved if necessary,
*   Submit the remainder to a message bus.

This is because Cyrus IMAP 2.5:

#.  at the time of this writing, does not support submitting the event
    notifications to a message bus directly [#]_,

#.  the size of the message payload is likely to exceed the maximum size of an
    event notification datagram [#]_.

Processing of inbound messages must happen real-time or near-time, but should
also be post-processed:

*   e-Discovery requires post-processing to sufficiently associate the message
    in its context, and contains an audit trail.

*   Archival and Backup require payload, and may also use post-processing to
    facilitate Restore.

Event Notifications
===================

The following events trigger notifications:

.. code-block:: c

    /*
    * event types defined in RFC 5423 - Internet Message Store Events
    */
    enum event_type {
        EVENT_CANCELLED           = (0),
        /* Message Addition and Deletion */
        EVENT_MESSAGE_APPEND      = (1<<0),
        EVENT_MESSAGE_EXPIRE      = (1<<1),
        EVENT_MESSAGE_EXPUNGE     = (1<<2),
        EVENT_MESSAGE_NEW         = (1<<3),
        EVENT_MESSAGE_COPY        = (1<<4), /* additional event type to notify IMAP COPY */
        EVENT_MESSAGE_MOVE        = (1<<5), /* additional event type to notify IMAP MOVE */
        EVENT_QUOTA_EXCEED        = (1<<6),
        EVENT_QUOTA_WITHIN        = (1<<7),
        EVENT_QUOTA_CHANGE        = (1<<8),
        /* Message Flags */
        EVENT_MESSAGE_READ        = (1<<9),
        EVENT_MESSAGE_TRASH       = (1<<10),
        EVENT_FLAGS_SET           = (1<<11),
        EVENT_FLAGS_CLEAR         = (1<<12),
        /* Access Accounting */
        EVENT_LOGIN               = (1<<13),
        EVENT_LOGOUT              = (1<<14),
        /* Mailbox Management */
        EVENT_MAILBOX_CREATE      = (1<<15),
        EVENT_MAILBOX_DELETE      = (1<<16),
        EVENT_MAILBOX_RENAME      = (1<<17),
        EVENT_MAILBOX_SUBSCRIBE   = (1<<18),
        EVENT_MAILBOX_UNSUBSCRIBE = (1<<19)
    };

In addition, Kolab Groupware makes available the following event notifications:

.. code-block:: c

    enum event_type {
        (...)
        EVENT_MAILBOX_UNSUBSCRIBE = (1<<19),
        EVENT_ACL_CHANGE          = (1<<20)
    };

This means the following event notifications are lacking:

#.  METADATA change notification

It is possible to run Cyrus IMAP 2.5 notifications in a blocking fashion,
allowing the (post-)processing operation(s) to complete in full before the IMAP
session is allowed to continue / confirms the modification/mutation.

Application Logic and Database Design Considerations
====================================================

Database Technology
-------------------

NoSQL storing key value pairs, trick is to store as many keys as is necessary to
get to the related value.

Relationships problematic. Possibly for data only, use ORM for relationships.

Object Relationship Manager
---------------------------

*   User

    An individual human being with physical presence (in the here and now, past
    and/or future).

*   Group

    A group of individual User objects.

*   Role

    A role attached to one or more User objects, functionally the inverse of
    a Group.

*   IMAP Folder

    *   METADATA, including:

        *   Unique ID (persistent)
        *   Shared seen, important to Read/Unread status tracking,
        *

    *   ACL
    *   Payload

Change Recording in ORM
-----------------------

Rather than recording the changes to objects explicitly, it is more effective to
define the objects themselves as volatile objects, in such a way that updates to
them imply a changelog record be created.

In summary, it is better to reduce the processor's workload and code base from:

.. graphviz::

    digraph event_notification {
            rankdir = LR;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11]
            node [shape=record, fontname=Calibri, fontsize=11]

            "object record";
            "object changelog record";

            "change" -> "processor";

            "processor" -> "object record" [label="updates"];
            "processor" -> "object changelog record" [label="creates"];

        }

to:

.. graphviz::

    digraph event_notification {
            rankdir = LR;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11]
            node [shape=record, fontname=Calibri, fontsize=11]

            "object record";
            "object changelog record";

            "change" -> "processor";

            "processor" -> "object record" [label="updates"];
            "object record" -> "object changelog record" [label="record change implies creation of"];

        }

The basis of this implementation is simple (in Python):

*   Declare a class for individual change records,
*   Declare a declarative class inherited by individual object table
    definitions,
*   Use the declarative class in addition to the declarative base class in the
    definition of the individual object table class,
*   Use ``__setattr__()`` to catch any changes to existing objects,
*   Process the current value of the object that is being changed, if any,
*   Record the object name, object id, current value (if any), and the value it
    is about to change to,
*   Insert the new changelog record in to the current transaction.

.. code-block:: python

    class Change(DeclarativeBase):
        """
            This object represents an entry of a ChangeLog-type table.
        """

        __tablename__ = 'changes'

        # Depending on the size of these tables, adjust the following
        # table name that updates automatically. This example does so monthly.
        #
        # Note that this only affects every initialization of the engine.
        #

        #__tablename__ = eval(
        #        '"changes_%s"' % (
        #                datetime.strftime(datetime.utcnow(), "%Y_%m")
        #            )
        #    )

        id = Column(Integer, primary_key=True)
        object_name = Column(String(64))
        object_id = Column(Integer)
        value_from = Column(Text)
        value_to = Column(Text)

        # Add:
        #
        #   - who
        #   - when

    class ChangeRecordDeclarativeBase(object):
        """
            This abstract base class must be used for DeclarativeBase class
            definitions for which we want to record changes to individual entries.
        """

        def __setattr__(self, key, value):
            current_value = None

            if hasattr(self, key):
                current_value = getattr(self, key)

            if not current_value == None and not current_value == value:
                # Record the change
                change = Change()
                change.object_name = self.__class__.__name__
                change.object_id = self.id
                change.value_from = current_value
                change.value_to = value

                DBSession.add(change)

            DeclarativeBase.__setattr__(self, key, value)

    class Folder(ChangeRecordDeclarativeBase, DeclarativeBase):
        """
            An IMAP folder.
        """

        __tablename__ = 'folders'

        id = Column(Integer, primary_key=True)
        path = Column(Text, nullable=False)
        uniqueid = Column(String(16))
        created = Column(DateTime)

        _metadata = relation("FolderMetadata")
        _acl = relation("FolderACL")


Users are Volatile and Groups do not Exist
------------------------------------------

Usernames as issued by Cyrus IMAP 2.5 notifications are volatile, in that the
same physical human being (jane.gi@example.org) could change email addresses for
any of many unrelated causes (jane.doe@example.org).

It is therefore mandatory to:

*   resolve IMAP login usernames to canonified IMAP login usernames,

    User ``jdoe2`` could in fact be the same physical human being as
    ``j.doe2@example.org`` and ``jane.doe@example.org``.

*   relate canonified IMAP login usernames to persistent user attribute values,
*   relate mail folder names, paths and URIs in personal namespaces to
    persistent user attribute values,
*   resolve IMAP ACE subject entries to their persistent attribute values, for
    both users and groups,
*   store membership information about groups at the time of an event,
*   store roles attached to users.

This needs to happen in a timely fashion, for intermediate changes to the
authoritative, canonical user and group information database, in the period of
time between the event notification and the collection of information, could
invalidate the permanent record.

.. graphviz::

    digraph bonnie_user {
            splines = true;
            overlap = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11]
            node [shape=record, fontname=Calibri, fontsize=11]

            subgraph cluster_dbuser {
                    label = "User (Database)";
                    dbuser_id [label="ID", color=blue, fontcolor=blue];
                    dbuser_uniqueid [label="UniqueID", color=blue, fontcolor=blue];
                }

            subgraph cluster_ldapuser {
                    label = "User (LDAP)";
                    ldapuser_dn [label="Entry DN", color=blue, fontcolor=blue];
                    ldapuser_uniqueid [label="UniqueID", color=blue, fontcolor=blue];
                }

            subgraph cluster_dbdata {
                    label = "Database Data";
                    dbcolumn_dbuser_id [label="UserID", color=blue, fontcolor=blue];
                }

            dbuser_id -> dbuser_uniqueid [label="resolves to"];
            dbuser_id -> dbcolumn_dbuser_id [label="FOREIGN KEY",dir=back];
            dbuser_uniqueid -> ldapuser_uniqueid [label="equals"];
        }

Queries and Information Distribution
====================================

ZeroMQ
======

.. graphviz::

    digraph bonnie_zeromq {
            splines = true;
            overlap = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11]
            node [shape=record, fontname=Calibri, fontsize=11]

            subgraph cluster_broker {
                    label = "Broker";
                    "Client Router";
                    "Controller";
                    "Worker Router";
                }

            "Client-%d" -> "Client Router";
            "Worker-%d" -> "Worker Router";
            "Worker-%d" -> "Controller";
        }

Client <-> Broker <-> Worker Message Exchange
=============================================

Modelled after an article about tracking worker status at
http://rfc.zeromq.org/spec:14

.. graphviz::

    digraph bonnie_broker {
            rankdir = LR;
            splines = true;
            overlap = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11]
            node [shape=record, fontname=Calibri, fontsize=11]

            subgraph cluster_broker {
                    label = "Broker";

                    "Client Router";
                    "Job Queue";
                }

            subgraph cluster_clients {
                    label = "Clients";
                    "Client $x" [label="Client-%d"];
                    "Client $y" [label="Client-%d"];
                }

            "Client $x", "Client $y" -> "Client Router" [label="(1) Submit"];
            "Client Router" -> "Job Queue" [label="(2) Queue"];
            "Client $x", "Client $y" -> "Client Router" [label="(3) Acknowledge",dir=back];

        }

**Client - Broker Concerns**

    #.  The client is queuing without a high-water mark and without a local
        swap defined. It is only after the broker is available this queue is
        flushed. This could introduce a loss of notifications.

    #.  The client is not awaiting confirmation in the sense that it will replay
        the submission if needed, such as after the client has been restarted.
        This too could introduce a loss of notifications.

    #.  The client is certainly not awaiting confirmation from any worker that
        the notification had been submitted to for handling.

    #.  The client is a sub-process of the cyrus-imapd service, and should this
        service be restarted, is not handling such signals to preserve state.

**Broker Concerns**

    #.  The broker is keeping the job queue in memory.

.. graphviz::

    digraph bonnie_broker {
            rankdir = LR;
            splines = true;
            overlap = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11]
            node [shape=record, fontname=Calibri, fontsize=11]

            subgraph cluster_broker {
                    label = "Broker";

                    "Controller";
                    "Job Queue";
                    "Worker Router";
                    "Worker List";
                }

            subgraph cluster_workers {
                    label = "Workers";
                    "Worker $x" [label="Worker-%d"];
                    "Worker $y" [label="Worker-%d"];
                }

            "Worker $x", "Worker $y" -> "Controller" [label="(a) READY"];

            "Controller" -> "Job Queue" [label="(b) Find Job"];
            "Controller" -> "Worker List" [label="(c) Find Worker"];
            "Controller" -> "Worker $x", "Worker $y" [label="(d) Assign Job"];

            "Worker $x", "Worker $y" -> "Worker Router" [label="(e) Take Job"];
            "Worker Router" -> "Worker List" [label="(f) Mark BUSY"];
        }

.. graphviz::

    digraph bonnie_broker {
            rankdir = LR;
            splines = true;
            overlap = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11]
            node [shape=record, fontname=Calibri, fontsize=11]

            subgraph cluster_broker {
                    label = "Broker";

                    "Controller";
                    "Client Router";
                    "Job Queue";
                    "Worker Router";
                    "Worker List";
                }

            subgraph cluster_clients {
                    label = "Clients";
                    "Client $x" [label="Client-%d"];
                    "Client $y" [label="Client-%d"];
                }

            subgraph cluster_workers {
                    label = "Workers";
                    "Worker $x" [label="Worker-%d"];
                    "Worker $y" [label="Worker-%d"];
                }

            "Client $x", "Client $y" -> "Client Router" [label="(1) Submit"];
            "Client Router" -> "Job Queue" [label="(2) Queue"];
            "Client $x", "Client $y" -> "Client Router" [label="(3) Acknowledge",dir=back];

            "Worker $x", "Worker $y" -> "Controller" [label="(a) READY"];

            "Controller" -> "Job Queue" [label="(b) Find Job"];
            "Controller" -> "Worker List" [label="(c) Find Worker"];
            "Controller" -> "Worker $x", "Worker $y" [label="(d) Assign Job"];

            "Worker $x", "Worker $y" -> "Worker Router" [label="(e) Take Job"];
            "Worker Router" -> "Worker List" [label="(f) Mark BUSY"];
        }


.. rubric:: Footnotes

.. [#]

    The worker shall be a multi-threaded daemon (using
    multiprocessing.Pool), that is a pluggable application.

    .. seealso::

        *   :ref:`and-bonnie-worker-design`
        *   :ref:`and-bonnie-broker-worker-interaction`

.. [#]

    The worker shall determine based on functional features enabled, and
    existing data, whether or not it requires a copy of the original
    message payload.

.. [#]

    It is assumed we'll be working with RSyslog, Logstash and Elastic
    Search.

.. [#]

    http://git.cyrusimap.org/cyrus-imapd/tree/notifyd?id=8bdaeae3f891ba2a748ba91a4c324ee11346e292

.. [#]

    Needs further investigation, for the actual maximum size of a datagram may
    have ceased to be hard-coded. Yet, to submit a large message through the
    notification daemon while the notification target is eligible to pick up the
    message contents from the filesystem seems like duplication.
