===================================
Mail Exchangers for Kolab Groupware
===================================

Kolab Groupware integrates mail exchangers with the rest of the groupware
environment, adding features such as;

*   Delegation (secretary functionality),
*   Envelope sender address verification and authorization,
*   Mandatory access control policy enforcement.

These features ensure the integrity of messages.

Overview
========

The following diagram illustrates the implementation of a single Kolab Groupware
mail exchanger with all features enabled.

.. graphviz::

    digraph {

            subgraph cluster_mta {
                    label="Mail Exchanger";
                    "MSA" -> "Kolab SMTP Access Policy" [dir=none];
                    "MTA" -> "Content Filter" -> "MTA";
                    "MTA" -> "Kolab SMTP Access Policy" [dir=none];

                }

            "MUA" -> "MSA" [label="submission"];
            "Internet" -> "MTA" [dir=both];

            subgraph cluster_local {
                    label="Local Networks";
                    "System #1";
                    "System #2";
                }

            "System #1", "System #2" -> "MTA" [label="relay"];

            "3rd Party Groupware" -> "MTA" [dir=both];
        }

**Local Networks**

    The networks considered *Local Networks* are configured using the
    :ref:`and-mta-postfix-mynetworks` setting.

    By default, this setting includes all locally attached subnets. The
    assumption is therefore, that only server systems are attached to the
    locally attached subnets, and not users.

**Mandatory Access Policy Enforcement**

    Both the MSA and MTA consult the **Kolab SMTP Access Policy** for
    mandatory access control enforcement.

    On the MSA level, the following policies are enforced:

        *   The user must be authenticated successfully.

            Actually authenticating the user is the responsibility of the
            Kolab SASL Authentication daemon, which authenticates the user
            against LDAP.

        *   The authenticated user must be authorized to use the envelope
            sender address specified in the message being submitted.

            A user is considered authorized to use the envelope sender
            address if either the following is true;

            #.  The user itself is also the final recipient for messages sent to
                the envelope sender address, such as would be the case with
                *mail* and *alias* attribute values, or

            #.  The user has been specifically authorized to send "*on behalf
                of*" the original owner of the envelope sender address.

        *   The user must not be disallowed to send messages to the recipients
            listed in the message being submitted.

        *   For the envelope recipient addresses that are considered local
            recipients, each target recipient's access control policies are
            checked requiring the sender to not be disallowed to send to the
            intended recipient.

**3rd Party Groupware**

    3rd Party Groupware solutions may be integrated into the Kolab Groupware
    environment up to and including the split of a single domain name space.

.. _and_mta_postfix:

Postfix
=======

.. _and-mta-postfix-mydestination:

mydestination
-------------

Using an LDAP lookup table ``/etc/postfix/ldap/mydestination.cf``, Postfix is
configured to query ``cn=kolab,cn=config`` for ``(associatedDomain=%s)``
entries, where ``%s`` is substituted for the domain part of envelope recipient
address.

For domain name spaces that are found here, Kolab uses
:ref:`and-mta-postfix-local_recipient_maps` to validate the full envelope
recipient address.

.. _and-mta-postfix-mynetworks:

mynetworks
----------

.. _and-mta-postfix-relay_domains:

relay_domains
-------------

.. _and-mta-postfix-local_recipient_maps:

local_recipient_maps
--------------------

.. _and-mta-postfix-relay_recipient_maps:

relay_recipient_maps
--------------------

.. _and_mta_kolab-smtp-access-policy:

Postfix & the Kolab SMTP Access Policy
--------------------------------------

The Kolab SMTP Access Policy is a policy service for Postfix that applies
mandatory recipient and sender address access controls using the Postfix SMTPD
Policy.

It verifies envelope sender address used in the message against the
authentication and authorization database.

What the Kolab SMTP Access Policy is
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The policy service is the implementation of a fine-grained mandatory access
control system, that allows delegatees to be appointed authorization (by
administrators, and delegators) to use the delegator's email address(es) as the
envelope sender address for messages the delegatees send, and/or allows an
administrator –or individual, if you'll permit this through custom ACI– to
configure a user account to be restricted access to receive from and/or send to
only individual addresses, groups, group members, domain name spaces, and groups
of domain name spaces.

As such, a corporate board or directors for example, may have a distribution
group 'board@example.com' to which only the members of the board of directors
are allowed to send messages, but no one else.

Note that this is slightly different from a mailing list such as implemented
with Majordomo or Mailman. While these technologies could require approved,
subscription-based submission of messages even though in a more enhanced
fashion, the subscribers list to such a mailing list is not based on LDAP group
membership, organizational unit orientation, roles, queries or otherwise related
to regular user provisioning, human resources, organizational roles and identity
management.

Similarly, each of the board members may authorize assisting personal to respond
to email using their own envelope sender address. Here's how that works:

John Doe, the Chief Executive Officer
"""""""""""""""""""""""""""""""""""""

John has a lovely secretary called Lucy. John allows Lucy to read and write to
John's Calendar, and opens up his INBOX folder to Lucy for read-only access.

John however, being a CEO and all that, tends to be unable to regularly read his
email and take the time to respond. Internet is only free of charge half an hour
a time, twice, at Schiphol. John would like Lucy to be able to respond on his
behalf (especially to those invitations for random events a CEO has little
interest in). John therefore authorizes Lucy to "send on behalf of". This is
considered a Kolab Delegate -future enhancements notwithstanding.

In LDAP, this would look as follows:

.. parsed-literal::

    dn: uid=doe,ou=People,dc=example,dc=org
    cn: John Doe
    (...)
    mail: john.doe@example.org
    (...)
    kolabDelegate: uid=meier,ou=People,dc=example,dc=org
    (...)

What the Kolab SMTP Access Policy is not
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Kolab SMTP Access Policy applies access control between senders and
recipients on an individual, per-entity basis. It can be used to restrict an
individual user from receiving from or sending to other recipients or senders,
including entire domain name spaces, but it does not apply a global
blacklist/whitelist mechanism.

When?
"""""

The Kolab SMTP Access Policy needs to be executed in desired points in a
mail-flow.

A typical deployment executes the Kolab SMTP Access Policy upon receiving
messages, or in other words, in smtpd and submission. The submission part is the
most illustrative of why the Kolab SMTP Access Policy works the way it does.

Kolab SMTP Access Policy in Action During Submission
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The submission of a new email by a user of Kolab Groupware has the following
three interesting stages;

MAIL FROM

    There is always one envelope sender address.

RCPT TO

    There are one or more recipients for each message.

DATA

    In the DATA SMTP protocol state, the envelope sender and all recipients are
    known. It is here that the Kolab SMTP Access Policy starts checking the
    policies that apply to the sender and recipients in one go.

Postfix allows for more and different restrictions to be configured to check the
policy, but these are the interesting ones.

Using the Postfix sender restrictions allows the Kolab SMTP Access Policy to
verify certain information, and otherwise block the mail early on. Note that the
first policy request occurs in protocol state RCPT, and thus also the first
recipient for the message is being supplied in the policy request. For the
purpose of verifying the sender's authorization to use the envelope sender
address access however, this is of little interest.

*   Is the sender authenticated?
*   Is the authenticated sender allowed to use the envelope sender address?
*   Envelope sender addresses that a user is typically allowed to use include
    primary and secondary email addresses directly associated with the user's
    entity in the authentication and authorization database.
*   Other address may include any of the email addresses the user has been made
    an authorized Kolab delegate for.

In case these checks are successful the Kolab SMTP Access Policy either
continues with "checking" the recipient - please see notes later on.

If configured to not also check recipient (the default is to check recipients
too) the Kolab SMTP Access Policy returns action DUNNO, which indicates to
Postfix the policy service doesn't care about blocking nor accepting the
message. Please see the notes later on for more information.

Using the Postfix recipient restrictions allows the Kolab SMTP Access Policy to
aggregate all recipients to which the message is intended. The Kolab SMTP Access
Policy has no interest in blocking at this stage, and will always return DUNNO.

It is not until the very last policy request in the DATA protocol state, that
Postfix allows the Kolab SMTP Access Policy to iterate over the information
received so far, and let the Kolab SMTP Access Policy know the parts of the
complete message submission that involves sender and one or more recipients is
over.

It is therefor crucially important that the Kolab SMTP Access Policy process
spawned by Postfix only exits after a complete message policy request has
finished (DATA protocol state, at which all possible MAIL FROM and RCPT TO must
have been submitted by the client), and it has given Postfix back to ultimate
policy request result.

It is to this end, that the Kolab SMTP Access Policy reads policy requests, for
as long as it can, until it reaches the DATA protocol state. Only then does the
Kolab SMTP Access Policy actually check sender access policies and recipient
access policies. During the RCPT TO protocol state, the policy service will
return DUNNO using function ignore(_("No objections yet")).

.. graphviz::

    digraph {
            "MUA" -> "MSA" [label="submission"];

            subgraph cluster_postfix {
                    "MSA";
                    "STARTTLS" [shape=box];
                    "AUTHENTICATE" [shape=box];
                    "Message Refused" [shape=diamond];
                    "Recipient Domain Check" [shape=diamond];
                    "Recipient Address Check" [shape=diamond];
                }

            subgraph cluster_kolabsap {
                    "Sender Identity Check" [shape=diamond];
                    "Delegation Check" [shape=diamond];
                    "Sender Recipient Access Policy Check" [shape=diamond];
                    "Recipient Local Check" [shape=diamond];
                    "Recipient Sender Access Policy Check" [shape=diamond];
                }

            "MSA" -> "STARTTLS";

            "STARTTLS" -> "Message Refused" [color=red,label=Failed];
            "STARTTLS" -> "AUTHENTICATE" [color=green,label=Success];

            "AUTHENTICATE" -> "Message Refused" [color=red,label=Failed];
            "AUTHENTICATE" -> "Recipient Domain Check" [color=green,label=Success];

            "Recipient Domain Check" -> "Sender Identity Check" [color=red,label=Remote];
            "Recipient Domain Check" -> "Recipient Address Check" [color=green,label=Local];

            "Recipient Address Check" -> "Message Refused" [color=red,label=Invalid];
            "Recipient Address Check" -> "Sender Identity Check" [color=green,label=Valid];

            "Sender Identity Check" -> "Delegation Check" [color=red,label=Failed];
            "Sender Identity Check" -> "Sender Recipient Access Policy Check" [color=green,label=Success];

            "Delegation Check" -> "Message Refused" [color=red,label=Failed];
            "Delegation Check" -> "Sender Recipient Access Policy Check" [color=green,label=Success];

            "Sender Recipient Access Policy Check" -> "Message Refused" [color=red,label="Sender Explicitly Disallowed To Send To Recipient"];
            "Sender Recipient Access Policy Check" -> "Recipient Local Check" [color=green,label=Success];

            "Recipient Local Check" -> "Message Accepted" [color=green,label="No"];
            "Recipient Local Check" -> "Recipient Sender Access Policy Check" [color=green,label="Yes"];

            "Recipient Sender Access Policy Check" -> "Message Refused" [color=red,label="Recipient Explicitly Disallows Sender To Send To Recipient"];
            "Recipient Sender Access Policy Check" -> "Message Accepted" [color=green,label="Success"];

        }

.. rubric:: Graph Legend

Recipient Domain Check

    The recipient domain check establishes whether the domain part of the
    envelope recipient email addresses is local, or remote.

    Domains considered local are those listed in
    :ref:`and-mta-postfix-mydestination` and those in
    :ref:`and-mta-postfix-relay_domains`.

Recipient Address Check

    For envelope recipients in local domains, the address must be a valid
    address that can be found using :ref:`and-mta-postfix-local_recipient_maps`
    for domains in :ref:`and-mta-postfix-mydestination`, and/or
    :ref:`and-mta-postfix-relay_recipient_maps` for domains in
    :ref:`and-mta-postfix-relay_domains`.

Sender Identity Check

Delegation Check

Sender Recipient Access Policy Check

Recipient Local Check

Recipient Sender Address Policy Check
