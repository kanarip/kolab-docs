===================
Tweaking Cyrus IMAP
===================

Synchronous File Operations
===========================

A default Kolab Groupware installation comes with a set of settings
suitable for the vast majority of our users -- mostly home users and
other small(er) deployments.

It is typical for these installations to **not** have battery-backed I/O
controllers, and/or some other form of enterprise-level storage.

To prevent data from being corrupted during a power outage, the default
for our Cyrus IMAP packages is to ensure the mail spool
(:file:`/var/spool/imap/`) and configuration directory
(:file:`/var/lib/imap/`) and all files contained therein have the
*synchronous* filesystem flag set.

To gain performance, execute the following:

#.  Remove the synchronous flag from the directories and files:

    .. parsed-literal::

        :command:`chattr -RV -S /var/lib/imap/ /var/spool/imap/`

#.  In :file:`/etc/sysconfig/cyrus-imapd` (or
    :file:`/etc/default/cyrus-imapd`), change the following:

    .. parsed-literal::

        CHATTRSYNC=1

    to:

    .. parsed-literal::

        CHATTRSYNC=0
