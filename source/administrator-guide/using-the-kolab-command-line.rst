============================
Using the Kolab Command-Line
============================

acl-cleanup
-----------

Iterate over all mailboxes and clean up the ACL. Useful in deployments where
any ACI may be used with setting the ACE, because identifier verification is
disabled or otherwise unavailable.

It is important to appreciate that an ACE for 'doe@example.org' is not removed
when the user 'doe@example.org' is removed -- when a new user is created with a
:term:`result attribute` value of 'doe@example.org', this user implicitly has
the access specified by the ACE.

add-domain
----------

This command adds a new domain name space to Kolab Groupware.

.. rubric:: Command-Line Options

.. program:: add-domain

.. option:: domain

    The domain to add.

.. option:: --alias domain

    Add the domain as an alias for the domain.

add-group-admin
---------------

Not yet implemented.

add-group-member
----------------

Not yet implemented.

add-user
--------

Not yet implemented.

create-mailbox (cm)
-------------------

Create a mailbox or mail folder.

.. rubric:: Command-Line Options

.. program:: create-mailbox

.. option:: mailbox

    The mailbox to create.

.. option:: --metadata KEY=VALUE

    Set the metadata KEY for the mailbox or mail folder to VALUE. Specify once
    for each pair of KEY=VALUE.

.. rubric:: Example Usage

Create a new mail folder for user John Doe:

    .. parsed-literal::

        # :command:`kolab create-mailbox` "user/john.doe/New@example.org"

Create a new calendar for user John Doe:

    .. parsed-literal::

        # :command:`kolab create-mailbox` \\
            --metadata=/shared/vendor/kolab/folder-type=event \\
            "user/john.doe/New Calendar@example.org"

delete-domain
-------------

Not yet implemented.

delete-group-admin
------------------

Not yet implemented.

delete-group-member
-------------------

Not yet implemented.

delete-mailbox (dm)
-------------------

Delete a mailbox.

delete-mailbox-acl (dam)
------------------------

Delete an ACE for a mailbox.

.. rubric:: Command-Line Options

.. program:: delete-mailbox-acl

.. option:: pattern

    Delete the ACE from mailboxes matching the specified pattern.

.. option:: aci

    Delete the ACE for this ACI.

delete-user
-----------

Not yet implemented.

edit-group
----------

Not yet implemented.

edit-user
---------

Not yet implemented.

list-deleted-mailboxes
----------------------

.. rubric:: Command-Line Options

.. option:: pattern

    List deleted mailboxes matching the specified pattern.

.. option:: --server server

    Connect to the IMAP server at address <SERVER> instead of the configured
    IMAP server.

list-mailbox-acl (lam)
----------------------

.. rubric:: Command-Line Options

.. option:: pattern

    List the ACL for mailboxes matching the specified pattern.

list-mailbox-metadata
---------------------

.. rubric:: Command-Line Options

.. option:: --user user

    List the mailbox metadata logged in as the user, enabling the examination of
    the /private metadata namespace in addition to the /shared namespace.

list-mailboxes (lm)
-------------------

.. rubric:: Command-Line Options

.. option:: --server server

    Connect to the IMAP server at address <SERVER> instead of the configured
    IMAP server.

list-user-subscriptions
-----------------------

.. rubric:: Command-Line Options

.. program:: list-user-subscriptions

.. option:: user

    The user identifier to list the (un)subscribed folders for.

.. option:: --unsubscribed

    List folders the user is not subscribed to, instead of subscribed folders.

rename-mailbox
--------------

set-mailbox-acl (sam)
---------------------

set-mailbox-metadata
--------------------

.. rubric:: Command-Line Options

.. option:: --user user

    Set the mailbox metadata logged in as the user, enabling the modification of
    the /private metadata namespace annotation values.

summarize-quota-allocation (sqa)
--------------------------------

Summarize all quota allocation for all mailboxes.

.. rubric:: Command-Line Options

.. option:: --server server

    Connect to the IMAP server at address <SERVER> instead of the configured
    IMAP server.

transfer-mailbox
----------------

.. program:: transfer-mailbox

.. option:: pattern

    Transfer mailboxes matching the specified pattern.

.. option:: server

    Transfer mailboxes to this server.

.. .. option:: --server server
..
..     When initially connecting to list the mailboxes matching
..     :option:`transfer-mailbox pattern`, connect to the server specified, instead
..     of the configured IMAP server.

undelete-mailbox
----------------

user-info
---------

Sieve Operations
================

list
----

put
---

refresh
-------
