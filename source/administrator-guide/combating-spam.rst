Combating Spam
==============

Kolab Groupware includes SpamAssassin, a fast, well-established anti-spam
solution with a large community of supporters contributing not only to the code,
but to rulesets as well.

Combating spam is always a tricky situation. On the organizational level, a
strategy has to be formulated to combat spam in order to achieve the maximum
flexibility and effectiveness for individual users, separate organizations, and
the deployment as a whole.

A common deployment is to define deployment-wide user preferences and to use a
single, deployment-wide set of rules for SpamAssassin to operate with
-including Bayes database(s).

The problems start when individual users mark legitimate email as spam, most
notably the company newsletter or correspondation they have opted in some time
ago, but wish to no longer receive. Users tend to ignore the long-term effects
of marking these message as spam, if at all they are aware of any, and just want
such messages out of their way.

Common examples of the sort of messages that are often marked as spam while
being legitimate traffic include:

*   Newsletters, where users, rather then unsubscribe, mark legitimate messages
    as spam,

*   Notifications from social networks such as from Google+, Facebook, Twitter,
    etc., where users, rather then adjust their notification preferences, mark
    legitimate messages as spam,

*   Notifications from forums and/or services,

If enough users mark these messages as spam, the system will start to recognize
these messages as spam, and other users may be prevented from receiving the same
or similar messages in their INBOX.

Amavis, the default content filter performing anti-virus and anti-spam, wraps
around SpamAssassin to achieve this flexibility.

Separate Bayes database(s) can be created on a per-recipient and per-policy-bank
SpamAssassin configuration files and SQL Bayes usernames.

Without over-complicating things, a common scenario sufficiently serving the
anti-spam effort, includes the following aspects;

*   A shared/Spam folder is created, with permissions for all users to lookup,
    read, and insert messages. It is the intention users move or copy messages
    they think are spam into this folder.

    .. NOTE::

        Note that, optionally, the permissions for users to maintain the 'seen'
        state of messages could not be granted, which in combination with
        sharedseen could provide a mechanism that would allow users to view
        which messages have been learned as spam in the past.

Learning About New Spam
-----------------------

Optionally, find all folders named "Spam" or "Junk"::

    $ find /var/spool/imap/ -type d -name "Spam" -o -name "Junk"
    $ sa-learn --spam /path/to/folder/[0-9]*.

.. NOTE::

    SpamAssassin will not learn about messages it has learned about before.
    There's no requirement of purging or deleting the messages that SpamAssassin
    has learned about already, and purging or deleting those messages only
    helps to speed up the learning process run.

.. WARNING::

    Do **NOT** delete the messages from the filesystem directly. Please refer
    to Section 6.6, “Expiring Messages from Spam/Ham (Shared) Folders” for ways
    to purge, expire and/or delete messages from spam folders in a sustainable
    way.

Preseeding the Bayes Database
-----------------------------

As Bayes is only effective after it has learned about 200 messages, it is
recommended to preseed the Bayes database with some high-quality ham and spam.
Preseeding the Bayes database with some ham, and some spam, is done using the
SpamAssassin Public Corpus. The public corpus consists of many messages
qualified as ham and spam, collected from a variety of sources.

The SpamAssassin Public Corpus can be found at http://spamassassin.apache.org/publiccorpus/.

Preseeding the Bayes Database using SpamAssassin Public Corpus
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.  Obtain the ham and spam archives::

    # mkdir -p /tmp/salearn
    # cd /tmp/salearn
    # wget --recursive --timestamping --no-directories --level=1 --reject=gif,png,html,=A,=D http://spamassassin.apache.org/publiccorpus/

2.  Extract the archives::

    # for archive in `ls -1 *.tar.bz2`; do tar jxf $archive; done

3.  For all files in the ham directories, learn those messages as ham::

    # sa-learn --progress --ham *ham*/*

4.  For all files in the spam directories, learn those messages as spam::

    # sa-learn --progress --spam *spam*/*

Trapping Massive Amounts of Spam
--------------------------------

To learn about spam quickly, allow the Cyrus IMAP postuser to post into a shared
folder that will be included in the regular sa-learn run.

Setting a Trap for Spam
^^^^^^^^^^^^^^^^^^^^^^^

1.  Set up the Cyrus IMAP postuser, using the postuser setting in
    **imapd.conf(5)**.

    If, for example, the postuser is set to *bb* (short for bulletin-board?),
    the mail to bb+shared/blah@example.org will be delivered to the
    shared/blah@example.org folder.

    .. NOTE::

        Take into account the use of unixhierarchysep in imapd.conf(5). If it
        is not enabled, the recipient address should be
        bb+shared.blah@example.org for the folder shared.blah@example.org.

2.  Create a shared folder such as shared/Spam@example.org

3.  Set permissions::

    # kolab sam shared/Spam@example.org <postuser> p

4.  Submit / subscribe to known spam aggregators (search Google for 'free email
    offers')

5.  Optionally, set the luser_relay option in Postfix, to trap all messages sent
    to non-existent recipients.

Tweaking Bayes' Scores
----------------------

Bayes\' score is dependent on the probability Bayes attaches of a message being
spam. The rules used to match a message's probability of being spam are
systematically prefixed with ``BAYES_``, followed by the percentage of
likelihood of the message being spam.

Because there is rarely a 100% certainty of a message being spam, the highest
percentage is 99%. By default, the configuration attaches a 3.5 score to this
probability. Depending on the configuration value for $sa_tag2_level_deflt
supplied in the Amavis configuration file, 6.31 by default, it is unlikely spam
will reach the cut-off point of actually being marked as spam solely on the
basis of Bayes' probability score.

It is therefor recommended to increase the score attached to messages with a 99%
probability of being spam to at least 6.308, if not simply 6.31. Using 6.308,
you configure spam to be tagged not solely on the basis of Bayes' 99%
probability score, but request that in addition the message is recognized to be
in HTML (and HTML only), and perhaps uses a big font –or similar patterns with a
very small 0.01 score.

Some spam has been submitted through systems listed at http://dnswl.org, a
collaborative false positive protection mechanism, a default score of 1 is
substracted from the total score. If this spam reaches you, consider increasing
the score on BAYES_99 with another one point.

Adjusting the Score for BAYES_99
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.  Edit /etc/mail/spamassassin/local.cf, and make sure the following line is
    present::

    .. parsed-literal::

        score BAYES_99 7.308

2.  Reload or restart the amavisd-new service::

    # service amavisd-new restart

Learning about Ham
------------------

It is important to not just learn about spam, but learn about ham, legitimate
email messages, as well. When not learning about ham, the anti-spam system will
become heavily biased towards spam, and ultimately classify all email messages
as such.

Learning about ham follows a slightly different doctrine then learning about
spam. Most importantly, ham is not to be posted to a shared folder that everyone
else can read the contents from. It is most commonly a "Not Junk" or "Ham"
folder in one's personal namespace users are instructed to copy or move messages
to, that have been classified as spam but are actually ham.

It is recommended users are both instructed to use ham folders, as well as
create them by default —regardless whether they are called "Ham" or "Not Junk"
or equivalent localized version of such.

Alternatively, you could learn about ham from people's INBOX folders.

Expiring Messages from Spam/Ham (Shared) Folders
------------------------------------------------

When you share folders to which users can move or copy ham and/or spam messages,
it is sensible to purge the contents of those folders regularly, or the folder
size continues to increase indefinitely. Run the expiry after sa-learn has been
run.

.. NOTE::

    Running ipurge to purge mail folder messages occurs independent from setting
    expunge_mode, and independent from the expire annotation as well.

    Using the expire annotation is sufficient to purge the contents of the
    folder, as, with or without the expunge_mode setting having been set to
    delayed, rather then immediate, the Bayes database will only be updated with
    messages Bayes has not learned about before.

To purge the contents of a mailfolder, run ipurge::

    $ /usr/lib/cyrus-imapd/ipurge -d 1 user/folder/name@domain.tld
    (...output abbreviated...)
    $ /usr/lib/cyrus-imapd/ipurge -i -d 1 user/folder/name@domain.tld

Updating the Spam Rules
-----------------------

As part of the SpamAssasin package, a utility is provided to update the rulesets
from channels configured.

For systems on which either of the SpamAssassin daemon or Amavis daemon is
running, the software packages automatically install a nightly cronjob to ensure
the rules are updated frequently.

The spam rulesets are updated using the sa-update command, supplying one or more
--channel options specifying the names of the ruleset channels to update, and
(optionally) one or more --gpgkey options specifying the Pretty Good Privacy
keys to allow signatures on the rulesets to have been signed with.

The cronjob that is installed by default, executes sa-update for all channels
defined in ``/etc/mail/spamassassin/channels.d/`` with one file per channel.

Bayes SQL Database for Distributed Systems
------------------------------------------

If more then one system needs to make use of the Bayes database, consider using
a network SQL Bayes database.

Setting Up the Bayes Database
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.  Create the database:

    .. parsed-literal::

        # mysql -e 'create database kolab_bayes;'

2.  Create a user and grant the appropriate privileges::

        # mysql -e "GRANT ALL PRVILEGES ON kolab_bayes.* TO
            'kolab_bayes'@'%' IDENTIFIED BY PASSWORD 'password';"

3.  Reload the privileges:

    .. parsed-literal::

        # mysql -e 'FLUSH PRIVILEGES;'

4.  Download the latest Bayes Database SQL schema file from bayes_mysql.sql
    (when using MySQL):

    .. parsed-literal::

        # wget http://svn.apache.org/repos/asf/spamassassin/trunk/sql/bayes_mysql.sql

5.  Insert this schema into the database::

        # mysql kolab_bayes < bayes_mysql.sql

Migrating Existing Bayes Database(s)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.  First, export any existing Bayes databases, run the following command (on
    each server with a Bayes database)::

        # sa-learn --backup > /path/to/sa_backup.txt

2.  A recommended step, but completely optional, is to expire the current copy
    of the database::

        # sa-learn --clear

3.  Modify /etc/mail/spamassassin/local.cf to contain the following settings::

        bayes_store_module          Mail::SpamAssassin::BayesStore::SQL
        bayes_sql_dsn               DBI:mysql:database[11]:server[12]
        bayes_sql_username          username[13]
        bayes_sql_password          password[14]
        bayes_sql_override_username root

4.  Import the exported Bayes database(s)::

        # sa-learn --restore /path/to/sa_backup.txt

Ensuring Availability of Messages' Spam Score
---------------------------------------------

For the purpose of troubleshooting, or in deployments with clients that have
spam filtering capabilities, it is sensible to always insert the spam headers
into email messages, both to avoid clients scanning the message again, as well
as troubleshooting why mail may or may not have been filtered.

To always insert the spam score into the message headers, find the line in
/etc/amavisd/amavisd.conf that starts with $sa_tag_level_deflt and replace it
with::

    $sa_tag_level_deflt  = -10;

While the score is available from the log files should the level of logging
verbosity have been increased, in some scenarios it is necessary to include the
spam score regardless of the traffic being inbound or outbound. An example is a
mail gateway for an unknown number of, or regularly changing, or dynamic, or
large list of domain name spaces with both inbound and outbound traffic, which
needs to be protected senders as well as receivers from spam.

Normally only inbound traffic is tagged –if at all–, by recognizing the
recipient domain name space as local. The setting @local_domains or, in later
versions of Amavis, @local_domains_acl is used.

In a default Kolab Groupware installation, the recipients are looked up in LDAP,
and if an entry is found, Amavisd will also classify the domain as local –
regardless of any @local_domains and/or @local_domains_acl setting.

Adding Spam Headers to All Messages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To recognize all domain name spaces as local, edit /etc/amavisd/amavisd.conf and
make sure the following settings are not configured::

    @local_domains,
    @local_domains_acl, and
    any read_hash(\%local_domains) setting.

Ensure that the following setting is configured like so::

    $local_domains_re = new_RE( qr'.*' );

Also disable the LDAP lookups, by removing the following settings::

    $enable_ldap
    $default_ldap

Default Amavisd Behaviour
-------------------------

The default behaviour shown in a Kolab Groupware deployment depends on the
default settings that come with the packages delivered mostly through native,
distribution-specific software repositories. This chapter documents various
aspects of the behaviour Kolab Groupware will show referring to the appropriate
settings that will allow a system administrator to modify the behaviour.

.. rubric:: Adding Spam Information Headers

Amavisd, by default, adds spam information headers only to messages that;

*   Are intended for delivery to local recipients,
*   Get a spam score over 2.0 from SpamAssassin.
*   The related setting is $sa_tag_level_deflt in /etc/amavisd/amavisd.conf.

.. rubric:: Spam Kill Level

The spam kill level controls which score spam must have been marked with before
Amavisd considers the message to not be delivered to the intended recipient(s).

Depending on your platform, the default for this score is 6.31 or 6.9. When a
message is marked with a spam score higher than or equal to this level, Amavisd
will take "evasive action". See :ref:`admin_combat-spam_amavis-evasive-action`
for more information on configuring evasive actions.

.. _admin_combat-spam_amavis-evasive-action:

Configuring Amavis Evasive Action
---------------------------------

You can control what "evasive action" Amavisd takes using the
**$final_spam_destiny** and **$final_virus_destiny** settings in
``/etc/amavisd/amavisd.conf``. The default is usually to discard the message,
but the following options are available:

D_PASS

    The message is accepted for delivery to the intended recipient(s), despite
    having been scored passed the kill or cutoff level, and regardless of bad
    content.

    If a quarantine address has been configured, the quarantine address will
    receive a copy of the email. See Configuring Quarantine to learn how to
    configure the quarantine address.

D_BOUNCE

    The message is not accepted for delivery to the intended recipient(s). A
    Delivery Status Notification stating delivery failure is sent out to the
    sender.

    If a quarantine address has been configured, the quarantine address will
    receive a copy of the email. See Configuring Quarantine to learn how to
    configure the quarantine address.

D_REJECT

    The message is rejected by Amavisd, and while Amavisd sends out a 550 SMTP
    response to the Mail Transfer Agent, said Mail Transfer Agent is responsible
    for sending out the Delivery Status Notification, if any.

    If a quarantine address has been configured, the quarantine address will
    receive a copy of the email. See Configuring Quarantine to learn how to
    configure the quarantine address.

D_DISCARD

    The message is simply discarded by Amavisd. The sending Mail Transfer Agent
    will receive a positive SMTP delivery response, and Amavisd sends out no
    Delivery Status Notification, nor does it forward the message for delivery
    to the intended recipients.

    If a quarantine address has been configured, the quarantine address will
    receive a copy of the email. See Configuring Quarantine to learn how to
    configure the quarantine address.

Configuring Quarantine
----------------------

Two separate quarantine forwarding addresses can be configured. One is for
messages labeled as spam, another for messages suspected to contain a virus.

A catchall address for spam can be configured by setting the
**$spam_quarantine_to** setting to a valid recipient address in
``/etc/amavisd/amavisd.conf``

A catchall address for messages suspected of containing a virus can be
configured by setting the **$virus_quarantine_to** setting to a valid recipient
address in ``/etc/amavisd/amavisd.conf``.
