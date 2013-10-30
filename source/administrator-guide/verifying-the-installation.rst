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

