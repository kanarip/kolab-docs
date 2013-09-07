========================
Upgrading from Kolab 3.0
========================

This chapter contains the upgrade notes for moving forward from Kolab 3.0 to
Kolab 3.1.

ChangeLog
=========

Kolab 3.1 compared to Kolab 3.0 ships the following additional components:

#.  **iRony**

    A DAV access provider for groupware, including WebDAV with help of the
    **chwala** API, and CardDAV and CalDAV.

#.  **chwala**

    A properly designed and integrated file storage management layer, primarily
    for integration in to other web applications through it's self-reliant
    UI component builder functions (JavaScript) obtaining information from its
    own API.

#.  ``kolab_files`` for **roundcubemail-plugins-kolab**

    One implementation of the integration of **chwala** in to the Roundcube
    web client.

Further software updates address the following issues:

#.  The Kolab Web Administration Panel has been enhanced to address duplicate
    surname issues, which in Kolab 3.0 would generate duplicate ``uid``
    attributes.

#.  The way the ``uid`` is composed can now be configured with the introduction
    of a ``policy_uid`` setting in the ``[kolab_wap]`` section of
    :manpage:`kolab.conf(5)`.

#.  The **postfix** MTA is now configured to strip the ``Received from:``
    headers that could otherwise disclose a user's geographical location.

#.  The **postfix** MTA is now configured to reject inbound email traffic that
    already has headers set to indicate a spam message.

#.  The **postfix** MTA is now configured to strip additional ``Received from:
    localhost [127.0.0.1] headers`` from emails that pass through Amavis.

#.  A new annotation ``/vendor/kolab/displayname`` was introduced to provide a
    compatibility layer with CardDAV and CalDAV access layers, neither of which
    understand IMAP folder hierarchy.

#.  A new annotation ``/vendor/kolab/uniqueid`` was introducted to provide a
    compatibility layer with CardDAV and CalDAV access layers, neither of which
    would have otherwise allowed an IMAP folder to be renamed or relocated in
    the IMAP folder hierarchy.

    .. NOTE::

        This annotation is only used if ``/vendor/cmu/cyrus-imapd/uniqueid`` is
        not available. This Cyrus IMAP annotation became available in Cyrus IMAP
        2.5.

#.  The ``kolab_auth`` plugin for Roundcube was enhanced to allow the use of a
    placeholder ``%dc`` to be substituted by the root dn for a supplied domain
    name.

    This enhances the Hosted Kolab Groupware deployment capabilities
    significantly.

#.  The **kolab-webadmin** software was enhanced to allow input of *KB*, *MB*
    and *GB* input for ``mailQuota``.

#.  The **kolab-webadmin** software was enhanced to allow *Shared Folders* to be
    created through the web administration panel.

#.  The **kolab-webadmin** software was enhanced to allow the configuration of
    *Dynamic Mail-enabled Distribution Groups*.

Updates to Cyrus IMAP
=====================

Updates to the Cyrus IMAP configuration can be applied automatically, by
executing:

.. parsed-literal::

    # :command:`setup-kolab imap`

.. WARNING::

    Executing the aforementioned command assumes you had not made any changes to
    :manpage:`cyrus.conf(5)` nor :manpage:`imapd.conf(5)`.

    If you had, either read the sections for
    :ref:`admin_upgrade-3.0_cyrus.conf` and
    :ref:`admin_upgrade-3.0_imapd.conf` or re-apply the changes you need after
    executing the aforementioned setup command.

.. _admin_upgrade-3.0_cyrus.conf:

:manpage:`cyrus.conf(5)` (at :file:`/etc/cyrus.conf`)
-----------------------------------------------------

Underscores in START, SERVICES and EVENTS Item Names
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The version of Cyrus IMAP shipped with Kolab 3.1 is incompatible with the use of
underscore ('_') characters in the names for the START, SERVICES and EVENTS
items.

The EVENTS section in **cyrus.conf(5)** may have looked as follows:

.. parsed-literal::

    EVENTS {
        # this is required
        checkpoint  cmd="ctl_cyrusdb -c" period=30

        # this is only necessary if using duplicate delivery suppression,
        # Sieve or NNTP
        duplicate_prune cmd="cyr_expire -E 3" at=0400

        # Expire data older then 69 days. Two full months of 31 days
        # each includes two full backup cycles, plus 1 week margin
        # because we run our full backups on the first sat/sun night
        # of each month.
        delete_prune cmd="cyr_expire -E 4 -D 69" at=0430
        expunge_prune cmd="cyr_expire -E 4 -X 69" at=0445

        # this is only necessary if caching TLS sessions
        tlsprune    cmd="tls_prune" at=0400

        # Create search indexes regularly
        squatter    cmd="squatter -s -i" at=0530
    }

This will need to become:

.. parsed-literal::

    EVENTS {
        # this is required
        checkpoint  cmd="ctl_cyrusdb -c" period=30

        # this is only necessary if using duplicate delivery suppression,
        # Sieve or NNTP
        **duplicateprune** cmd="cyr_expire -E 3" at=0400

        # Expire data older then 69 days. Two full months of 31 days
        # each includes two full backup cycles, plus 1 week margin
        # because we run our full backups on the first sat/sun night
        # of each month.
        **deleteprune** cmd="cyr_expire -E 4 -D 69" at=0430
        **expungeprune** cmd="cyr_expire -E 4 -X 69" at=0445

        # this is only necessary if caching TLS sessions
        tlsprune    cmd="tls_prune" at=0400

        # Create search indexes regularly
        squatter    cmd="squatter -s -i" at=0530
    }

The Use of Squatter
^^^^^^^^^^^^^^^^^^^

Squatter is used to periodically create full-text indexes for messages in
mailboxes.

At the time of this writing, however, headers that are relevant for Kolab
Groupware data searches are not included in such indexes.

To circumvent this problem, remove running squatter from the EVENTS section in
:file:`/etc/cyrus.conf`.

To prevent existing squatter indexes from getting in the way, remove all files
named **cyrus.squat** from your IMAP spools:

.. parsed-literal::

    # for partition in \`grep ^partition /etc/imapd.conf | awk '{print $2}'\`; do
            find $partition -type f -name cyrus.squat -delete
        done

.. _admin_upgrade-3.0_imapd.conf:

:manpage:`imapd.conf(5)` (at :file:`/etc/imapd.conf`)
-----------------------------------------------------

A few additional settings are needed for Cyrus IMAP to feature message traffic
directly in to shared folders.

If not already set, add the following setting to :file:`/etc/imapd.conf`:

.. parsed-literal::

    postuser: shared

New Features in Cyrus IMAP
--------------------------

*   Event notifications. See the architecture and design document on Bonnie.
*   Multi-master replication

Removing old and Adding new Plugins for Roundcube
=================================================

The following plugins are no longer included:

* ``kolab_core``

.. todo::

    Is this list complete?

The following plugins are new:

* ``kolab_files``

.. todo::

    Is this list complete?

