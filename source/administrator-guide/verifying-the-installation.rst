============================================
Verifying the Installation & Troubleshooting
============================================

Authentication Failures
=======================

Symptoms include:

*   You are unable to login to Roundcube,
*   Desktop client cannot connect to / authenticate against IMAP,
*   You are unable to login to the web administration panel,
*   Mail cannot be sent and is not being received.

and possibly others.

#.  Does the following command work?

    .. parsed-literal::

        # :command:`kolab lm`

    This should give you a list of mailboxes.

#.  Is the **kolab-saslauthd** service running?

    .. parsed-literal::

        # :command:`service kolab-saslauthd status`

    .. NOTE::

        Some deployments with only a single parent domain name space may have
        elected to run the Cyrus SASL authentication daemon (the **saslauthd**
        service).

#.  Is it functional?

    .. parsed-literal::

        # :command:`testsaslauthd -u cyrus-admin -p <password>`

    You can obtain the value from *<password>* from
    :file:`/etc/kolab/kolab.conf`, in the ``[cyrus-imap]`` section, setting
    ``admin_password``.

#.  Is LDAP running?

    .. parsed-literal::

        # :command:`service dirsrv status`

IMAP Connections Reset or Timeout
=================================

Symptoms include:

*   A user, program or process seems to hang, and ultimately be disconnected,
*   :command:`kolab list-mailbox-metadata user/john.doe@example.org` may hang,
    and ultimately disconnect or be disconnected.

Possible causes:

*   Too many Cyrus IMAP processes hold locks on the mailbox index database.

Troubleshooting steps:

#.  Determine the users' folder that may be held too many locks on:

    .. parsed-literal::

        # :command:`kolab list-mailbox-metadata user/john.doe*@example.org`
        Folder user/john.doe@example.org

    The folder that too many locks are being held on will result in an apparent
    freeze, with no timely response.

#.  Tail :file:`/var/log/maillog` and grep for the relevant username:

    .. parsed-literal::

        # :command:`tail -n 0 -f /var/log/maillog | grep john.doe@example.org`

#.  In a new terminal, issue the ``kolab list-mailbox-metadata`` command again,
    and example the output of the tail command issued to determine the process
    ID:

    .. parsed-literal::

        (datetime) (hostname) imap[**22164**]: login: (from) [(ip)] john.doe@example.org PLAIN+TLS User logged in SESSIONID=<(fqdn)-(pid)-(timestamp)-1>

#.  Use :command:`strace` to determine the state of this process:

    .. parsed-literal::

        # :command:`strace -s 200 -p 22164`
        Process 22164 attached - interrupt to quit
        fcntl(13, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=0, len=0}) = ? ERESTARTSYS (To be restarted)

    This command too will not yield any additional output.

#.  The PIDs of the processes holding an open file pointer to the mailbox tree
    can be found using the following command:

    .. parsed-literal::

        # :command:`lsof -t +d $(/usr/lib/cyrus-imapd/mbpath user/john.doe@example.org)`

#.  At your discretion, opt to kill the processes that may be waiting for one
    another to release the lock:

    .. parsed-literal::

        # :command:`lsof -t +d $(/usr/lib/cyrus-imapd/mbpath user/john.doe@example.org) \\
            | xargs -n 1 kill -9`
        kill 24904: No such process
        (...)

    The "No such process" output comes from attempts to kill processes that have
    meanwhile already been ended.
