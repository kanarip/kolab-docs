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

.. rubric:: Synopsis

.. parsed-literal::

    kolab add-domain [options] <domain>

.. rubric:: Command-Line Options

.. program:: add-domain

.. option:: domain

    The domain to add.

.. option:: --alias domain

    Add the domain as an alias for the domain specified as ``--alias``.

.. seealso::

.. add-group-admin
.. ---------------
..
.. Not yet implemented.
..
.. add-group-member
.. ----------------
..
.. Not yet implemented.
..
.. add-user
.. --------
..
.. Not yet implemented.

cm
--

Short-hand for :ref:`admin_cli_create-mailbox`.

.. _admin_cli_create-mailbox:

create-mailbox
--------------

Create a mailbox or mail folder.

.. rubric:: Synopsis

.. parsed-literal::

    kolab create-mailbox [options] <mailbox>

.. rubric:: Command-Line Options

.. program:: create-mailbox

.. option:: mailbox

    The mailbox to create.

.. option:: --metadata KEY=VALUE

    Set the metadata KEY for the mailbox or mail folder to VALUE. Specify once
    for each pair of KEY=VALUE.

    See :file:`/etc/imapd.annotations.conf` for valid KEYs, the permissions
    required to set them, namespaces and the format of the VALUE.

.. option:: --partition=PARTITION

    .. versionadded:: pykolab-0.6.11

    Specify the Cyrus IMAP partition on which to create the mailbox. If not
    specified, uses the ``defaultpartition`` configured in
    :manpage:`imapd.conf(5)`.

.. rubric:: Example Usage

Create a new mail folder for user John Doe:

.. parsed-literal::

    # :command:`kolab create-mailbox` "user/john.doe/New@example.org"

Create a new calendar for user John Doe:

.. parsed-literal::

    # :command:`kolab create-mailbox` \\
        --metadata=/shared/vendor/kolab/folder-type=event \\
        "user/john.doe/New Calendar@example.org"

Create a new default calendar folder for user John Doe.

.. NOTE::

    Only one default calendar folder may exist.

.. parsed-literal::

    # :command:`kolab create-mailbox` \\
        --user john.doe@example.org \\
        --metadata=/private/vendor/kolab/folder-type=event.default \\
        "New Calendar"

.. seealso::

    *   :ref:`admin_cli_subscribe-user`

dam
---

Short-hand for :ref:`admin_cli_delete-mailbox-acl`

.. delete-domain
.. -------------
..
.. Not yet implemented.
..
.. delete-group-admin
.. ------------------
..
.. Not yet implemented.
..
.. delete-group-member
.. -------------------
..
.. Not yet implemented.

delete-mailbox (dm)
-------------------

Delete a mailbox.

.. rubric:: Synopsis

.. parsed-literal::

    kolab delete-mailbox <pattern>

.. rubric:: Command-Line Options

.. program:: delete-mailbox

.. option:: pattern

    Delete all mailboxes matching :term:`pattern`.

.. rubric:: Example Usage

Delete a mail folder for user John Doe:

.. parsed-literal::

    # :command:`kolab delete-mailbox` "user/john.doe/Trash/Oops@example.org"

Delete all non-INBOX folders for user John Doe:

.. parsed-literal::

    # :command:`kolab delete-mailbox` "user/jane.doe/%@example.org"

.. _admin_cli_delete-mailbox-acl:

delete-mailbox-acl
------------------

Delete an ACE for a mailbox.

.. rubric:: Command-Line Options

.. program:: delete-mailbox-acl

.. option:: pattern

    Delete the ACE from mailboxes matching the specified :term:`pattern`.

.. option:: subject

    Delete the ACE for this subject.

.. seealso::

    *   :ref:`admin_cli_list-mailbox-acl`
    *   :ref:`admin_cli_set-mailbox-acl`

.. delete-user
.. -----------
..
.. Not yet implemented.
..
.. edit-group
.. ----------
..
.. Not yet implemented.
..
.. edit-user
.. ---------
..
.. Not yet implemented.
..
lam
---

Short-hand for :ref:`admin_cli_list-mailbox-acl`

list-deleted-mailboxes
----------------------

.. rubric:: Synopsis

.. parsed-literal::

    kolab list-deleted-mailboxes [pattern]

.. rubric:: Command-Line Options

.. program:: list-deleted-mailboxes

.. option:: pattern

    List deleted mailboxes matching the specified :term:`pattern`.

.. option:: --server server

    Connect to the IMAP server at address <SERVER> instead of the configured
    IMAP server.

.. _admin_cli_list-mailbox-acl:

list-mailbox-acl
----------------

.. rubric:: Command-Line Options

.. program:: list-mailbox-acl

.. option:: pattern

    List the ACL for mailboxes matching the specified :term:`pattern`.

.. seealso::

*   :ref:`admin_cli_delete-mailbox-acl`
*   :ref:`admin_cli_set-mailbox-acl`
*   :ref:`admin_imap-access-rights-reference`

list-mailbox-metadata
---------------------

.. rubric:: Command-Line Options

.. program:: list-mailbox-metadata

.. option:: --user user

    List the mailbox metadata logged in as the user, enabling the examination of
    the /private metadata namespace in addition to the /shared namespace.

list-mailboxes (lm)
-------------------

.. rubric:: Command-Line Options

.. program:: list-mailboxes

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

sam
---

Short-hand for :ref:`admin_cli_set-mailbox-acl`

.. _admin_cli_set-mailbox-acl:

set-mailbox-acl
---------------

Sets an access control entry (ACE) for a given subject.

.. rubric:: Synopsis

.. parsed-literal::

    kolab set-mailbox-acl <pattern> <subject> <rights>

.. rubric:: Command-Line Options

.. program:: set-mailbox-acl

.. option:: pattern

    Apply the ACE to mailboxes matching the specified :term:`pattern`.

.. option:: subject

    Set the ACE for the subject specified.

.. option:: rights

    The ACE subject is getting these rights.

    In addition to the regular IMAP access right identifiers, the kolab command-
    line takes the following rights:

    **all**

        Full rights, including administration. The IMAP equivalent is
        ``lrswipkxtecda``.

    **read-only**

        Read-only rights, with the IMAP equivalent being ``lrs``.

    **read-write**

        Permissions most suitable for access to a (shared) groupware folder.

        The rights allow a subject to modify groupware contents, such as marking
        tasks as completed.

        The IMAP equivalent is ``lrswited``.

    **semi-full**

        Allow the subject to insert new message (copies), such as groupware
        content, and flag current messages as deleted.

        Also allow the subject to maintain flags other than the system flags
        ``\Seen`` and ``\Deleted`` (such as ``\Flagged``).

        Note that the rights do not include the right to EXPUNGE the folder,
        meaning that messages therein remain available.

        The IMAP equivalent is ``lrswit``.

    **full**

        Everything but administrator rights, so that the subject cannot modify
        the access control on the folder.

.. rubric:: Example Usage

Set the access rights for ``john.doe@example.org`` to administer a folder
``shared/contacts@example.org``:

.. parsed-literal::

    # :command:`kolab sam shared/contacts@example.org john.doe@example.org all`

Give access to ``jane.doe@example.org`` to read and write contacts in a folder
``shared/contacts@example.org``:

.. parsed-literal::

    # :command:`kolab sam shared/contacts@example.org jane.doe@example.org read-write`

.. seealso::

    *   :ref:`admin_cli_list-mailbox-acl`
    *   :ref:`admin_cli_delete-mailbox-acl`
    *   :ref:`admin_imap-access-rights-reference`

set-mailbox-metadata
--------------------

.. rubric:: Command-Line Options

.. program:: set-mailbox-metadata

.. option:: --user user

    Set the mailbox metadata logged in as the user, enabling the modification of
    the /private metadata namespace annotation values.

.. _admin_cli_subscribe-user:

subscribe-user
--------------

.. rubric:: Synopsis

.. parsed-literal::

    kolab subscribe-user <user> <pattern>

.. rubric:: Command-Line Options

.. program:: subscribe-user

.. option:: user

    Subscribe the specified user.

    .. NOTE::

        The user will be subscribed only of the user also has rights to the
        folder.

.. option:: pattern

    Subscribe the user specified to mailboxes matching the specified
    :term:`pattern`.

summarize-quota-allocation (sqa)
--------------------------------

Summarize all quota allocation for all mailboxes.

.. rubric:: Command-Line Options

.. program:: summarize-quota-allocation

.. option:: --server server

    Connect to the IMAP server at address <SERVER> instead of the configured
    IMAP server.

transfer-mailbox
----------------

Transfer a mailbox from the server it is currently on, to the server you
specify.

.. WARNING::

    Transferring mailboxes may take quite a bit of time, depending on the
    connection speed between the two IMAP servers, and the size of a mailbox
    (tree).

    Make sure that despite your workstation's session possibly being
    interrupted, the command can continue, by using :manpage:`screen(1)` for
    example.

.. rubric:: Synopsis

.. parsed-literal::

    kolab transfer-mailbox <mailbox> <server>

.. rubric:: Command-Line Options

.. program:: transfer-mailbox

.. option:: mailbox

    Transfer the mailbox specified, such as ``user/john.doe@example.org``.

.. option:: server

    Transfer the mailboxes to the server specified.

.. rubric:: Example Usage

Transfer mailbox ``user/john.doe@example.org`` currently on IMAP server
``imap1.example.org`` over to IMAP server ``imap2.example.org``:

.. parsed-literal::

    # :command:`kolab transfer-mailbox user/john.doe@example.org imap2.example.org`

.. .. option:: --server server
..
..     When initially connecting to list the mailboxes matching
..     :option:`transfer-mailbox pattern`, connect to the server specified, instead
..     of the configured IMAP server.

undelete-mailbox
----------------

user-info
---------

This command retrieves information about a user from the Web Administration
Panel API (places a ``user.info`` API call), and prints all attributes for the
corresponding user type.

.. rubric:: Synopsis

.. parsed-literal::

    kolab user-info <address>

.. rubric:: Command-Line Options

.. program:: user-info

.. option:: address

    The primary or secondary recipient email address for the user, that is
    globally unique, such as ``john.doe@example.org``.

Sieve Operations
================

list
----

put
---

refresh
-------
