=============================
Frequently Answered Questions
=============================

.. _faq-no-add-user-button-or-link:

No "Add User" Button or Link
============================

If this link is not there (you would also not have been presented with a form),
you do not have permissions, you did not configure SELinux the way it was
documented, firewall, DNS.

Log Messages
============

.. seealso::

    *   :ref:`admin_faq_email-blocked-spamhaus`

Unable to open /etc/sasldb2
---------------------------

No :file:`user_deny.db`
-----------------------

.. parsed-literal::

  IOERROR: opening /var/lib/imap/user_deny.db: No such file or directory

No authentication
------------------

.. parsed-literal::

    TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits new) no authentication

Debug level information, can be ignored. You can reduce verbosity by
settings ``debug: 0`` in in :file:`imapd.conf` by not includeing debug messages
on the mail facility in syslog.

Unable to setsocketopt
-----------------------

.. parsed-literal::

    unable to setsocketopt(IP_TOS) service ptloader/unix: Operation not supported

Informational message issued on startup. Not critical.

Anti-Spam
=========

No ``X-Spam`` Headers
---------------------

.. _admin_faq_email-blocked-spamhaus:

Email Blocked Using zen.spamhaus.org
------------------------------------

You are seeing the following in :file:`/var/log/maillog` (line breaks added for
legibility):

.. parsed-literal::

    NOQUEUE: reject: RCPT from unknown[3.2.1.0]: 554 5.7.1 Service \\
    unavailable; Client host [3.2.1.0] blocked using zen.spamhaus.org; \\
    from=<something@domain.tld>

This message indicates your SMTP server, receiving a message from the Internet,
has refused the message.

The sending host (at IP address 3.2.1.0) is blocked using a centralized,
external service (spamhaus.org), that keeps track of hosts and networks on the
Internet with a reputation of spamming.

For more information on this service, see http://www.spamhaus.org/zen/.

You will want to continue performing these checks, but just in case you do not
want to, the relevant setting in Postfix is:

.. parsed-literal::

    # postconf smtpd_sender_restrictions

It is the responsibility of the sending host to notify the original sender the
message was not delivered.
