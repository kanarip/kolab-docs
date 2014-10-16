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
