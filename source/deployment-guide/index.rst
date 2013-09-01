================
Deployment Guide
================

Standard Deployment Scenarios
=============================

.. toctree::
    :maxdepth: 1

    localhost
    redundant-server
    multi-server
    hosted-kolab-groupware-deployment
    cyrus-imap-murder-topologies

    storage

    ../glossary

General Deployment Considerations
=================================

It is important to appreciate the use-case to which you wish to deploy Kolab,
and map that to the appropriate deployment scenario.

After all, Kolab Groupware is Made To Measure, and supremely flexible. It is
best deployed after you articulate what you seek to get out of it -- especially
for businesses.

Generic Statements
------------------

*   Larger numbers of users make it more important to ensure service
    availability.

*   Larger numbers of users make load-balancing (and high-availability through
    load-balancing) more attractive, more efficient and more cost-effective.

*   Contrary to popular belief, larger numbers of users make capacity planning
    more unpredictable, up to next to near impossible. Here, you require the
    ability to scale up and down as *turns out to be needed*, and not be locked
    in to a certain scale with limited options to break out. You are likely
    looking for :ref:`deployment_multi-server-for-each-service`.

*   The larger the (potential) data footprint, the more important it becomes to
    consider your storage options.

*   The more flexibility you require in scaling;

    *   the more likely you run idle over-capacity, or
    *   under-performing services because of under-capacity, but
    *   the easier it is to answer either of the aforementioned problems.

A Couple of Users
-----------------

In terms of capacity, for a family server, SOHO situation or micro-entity, it is
probably more than sufficient to run :doc:`localhost`.

If the data is really important, and you do not have data redundancy built in to
the single server (through RAID, or regular backups that are easy to restore),
such an environment might want to opt for a :doc:`redundant-server`.

Dozens of Users
---------------

When a deployment seeks to serve groupware to dozens of users, :doc:`localhost`
suffices unless the average user's usage pattern is extremely high.

A Free Software ISV with employees working remotely, from home, for example,
very much relies on electronic communications. Operating in the Free Software
community, it's communication patterns are ever increasing, with its employees
subscribing to upstream communities' mailing lists, and the organization itself
possibly providing services to its community.

While servicing only a couple of dozen users, the number of messages exchanged
easily exceeds thousands per day.

For this deployment, you may consider a deployment scenario as depicted in
:ref:`deployment_multi-server-with-combined-services`.

Scaling up from a single server deployment to a deployment with multiple servers
is relatively straight-forward, but, depending on what service you choose to
migrate off of the single host, possibly involves data migration and
configuration changes.

.. TODO::

    Somewhere other than here, document the process of scaling up from one
    single server on to multiple servers.

Hundreds of Users
-----------------

Providing Kolab Groupware to hundreds of users is an environment of scale. The
starting point is likely
:ref:`deployment_multi-server-with-combined-services`, however;

*   You may already have centralized authentication and authorization,
*   You probably already have an existing infrastructure, possibly including a
    perimeter network.

To illustrate why this is important:

    The Kolab web interfaces do not require a dedicated web server -- if you
    have one already, then you may want to consider installing the Kolab web
    interfaces on that, if not simply for the fact that public IP space is
    limited.

Other considerations come in to play deploying Kolab Groupware, and those are
included in the following sections:

*   :ref:`deployment-hundreds-redundancy`
*   :ref:`deployment-hundreds-high-availability`
*   :ref:`deployment-hundreds-load-balancing`
*   :ref:`deployment-hundreds-scalability`

.. _deployment-hundreds-redundancy:

Redundancy
^^^^^^^^^^

Redundancy -- with regards to data -- is a matter to be considered separate from
high-availability.

There are separate, distinct replication levels and scenarios one can consider:

.. _deployment-hundreds-high-availability:

High-Availability
^^^^^^^^^^^^^^^^^

Nothing overloads a helpdesk more than hundreds of users calling in at very much
the same point in time, because a service is unavailable (and might, as a domino
effect, render other services unavailable).

The larger your userbase, the more important it is to ensure services remain
available -- even during planned service windows.

.. _deployment-hundreds-load-balancing:

Load-Balancing
^^^^^^^^^^^^^^

.. _deployment-hundreds-scalability:

Scalability
^^^^^^^^^^^

With a quota of 1GB, a total data footprint of 100GB - 900GB is still
manageable, but should your users (be allowed to) have larger mailboxes and/or
use the File Storage features in Kolab, you are more likely speaking to the tune
of several terabytes (if not right from the start, you'll get there over time).

**This** is were scalability comes in to play. One could start with a single
Cyrus IMAP server, like so:

.. graphviz::

    digraph {
            rankdir=LR;
            "MUA" -> "IMAP Backend" -> "1 TB Storage Volume";
        }

You will want to make sure your users' desktop applications, and the rest of the
Kolab software uses a DNS entry to connect to IMAP (for example,
``imap.example.org``), so that it is easier for you to change what it is they
actually end up connecting to.

With several terabytes of data, *when* you get there, the desired scenario might
look like:

.. graphviz::

    digraph {
            rankdir=LR;
            subgraph cluster_murder {
                    label="Cyrus IMAP Murder";
                    "New IMAP Frontend";
                    "Original IMAP Backend";
                    "Additional IMAP Backend";
                }

            "MUA" -> "New IMAP Frontend";
            "New IMAP Frontend" -> "Original IMAP Backend" -> "Original 1 TB";
            "New IMAP Frontend" -> "Additional IMAP Backend" -> "Additional 1 TB";
        }

This is a simple change that can be prepared ahead of time, and implemented
during a service window, if and/or when it is needed.

.. NOTE::

    You have options with regards to the target topology of the Cyrus IMAP
    Murder. Please refer to :ref:`deployment_imap_cyrus-imap-murder`.

A Thousand Users
----------------

The magical boundary of a thousand users depicts each individual user's usage
pattern becomes unpredictable, as for one the number of mobile devices they
synchronize are not necessarily under control any longer.

Several Thousands of Users
--------------------------

The larger the enterprise (or: the larger the number of users), the more
significant capacity planning becomes in relation to deploying Kolab.

Tens of Thousands of Users
--------------------------

Hundreds of Thousands of Users
------------------------------

When an enterprise with 350.000 employees plans for a Kolab deployment, it is
unlikely all of the users will be migrated over the course of a single service
window, and despite what other groupware vendors might tell you, it is near to
impossible to accurately plan for the capacity required.

It is also important to appreciate any existing infrastructure and network
topology, and for Kolab to integrate in to that environment.

Ranging from small and medium-sized business, large enterprise and service
provider deployments, the number of users involved ranges from 50 to anywhere in
the hundreds of thousands or millions.

.. _deployment_organizations-with-multiple-domain-namespaces:

Organizations with Multiple Domain Namespaces
---------------------------------------------

When the people throughout an organization use different email domains, but need
to maintain the ability to share groupware data with everyone else in the
organization, it is important to appreciate the effects of using the primary
recipient email address (*mail*) of the user as the authorization ID
(*result_attribute*).

This might be the case in a holding with multiple subsidiaries. To illustrate,
an example holding corporation **Holding, Inc.**, with subsidiaries *Foo, Inc.*
and *Bar, Inc.*:

.. graphviz::

    digraph {
            "Holding, Inc." -> "Foo, Inc.";
            "Holding, Inc." -> "Bar, Inc.";
        }

.. NOTE::

    This is not considered a case for ISPs or providers of Hosted Kolab, but may
    be applicable to **customers** of ISPs and **consumers** of Hosted Kolab.
    ISPs and Hosted Kolab providers should refer to dedicated sections:

    * :ref:`deployment_hosted-kolab`

Let's suppose that:

*   People working for Holding, Inc. use email addresses ``@holding.inc``.
*   People working for Foo, Inc. use email addresses ``@foo.inc``.
*   People working for Bar, Inc. use email addresses ``@bar.inc``.

And:

*   All people are contained within a single LDAP tree (for, perhaps,
    Human Resources is a department within the holding, providing services to
    the holding as well as its subsidiaries, like it is providing Kolab
    Groupware services in this example):

    .. graphviz::

        digraph {
                "dc=holding,dc=inc" -> "ou=Groups", "ou=People" [dir=none];
                "ou=People" -> "ou=Foo", "ou=Bar" [dir=none];
                "ou=People" -> "uid=doe", "uid=smith" [dir=none];
                "ou=Bar" -> "uid=roe" [dir=none];
                "ou=Foo" -> "uid=average" [dir=none];
            }

In a default Kolab Groupware installation, the following mailboxes might be
created:

*   user/john.doe@holding.inc
*   user/jim.smith@holding.inc
*   user/joe.average@foo.inc
*   user/jane.roe@bar.inc

Because Cyrus IMAP uses the email domain as an authorization realm, and no
cross-realm authorization is allowed, in this scenario, John, Joe and Jane
cannot share mailboxes - though John and Jim can.

This may be the desired effect, and if it is, you can skip reading the rest of
this topic.

If it is not the intended effect however, and you seek to allow all people to
share groupware data with all other users, you must consider the following:

*   Should all people be given a primary recipient email address of
    ``@holding.inc``, in an attempt to make all users end up in the same
    authorization realm, then they are implicitly allowed to send using that
    email address.

    This in itself may not be desirable.

To enable users to share groupware data while their primary recipient email
addresses make them end up in different authorization realms, you should set the
``result_attribute`` setting in **kolab.conf(5)** to the name of an attribute
that does not contain a realm identifier (i.e., something without an '@' in it),
such as the ``uid`` attribute, which by default does not include a domain name
space. This would create the following mailboxes:

*   user/doe
*   user/smith
*   user/average
*   user/roe

You may also consider setting ``virtdomains`` to ``off`` in **imapd.conf(5)**,
although this implies only the null realm is ever going to be used.

For larger deployments, we also recommend reading about
:ref:`deployment_imap_cyrus-imap-murder`.

See Also
--------

*   :ref:`admin_organizations-with-multiple-domain-namespaces`.
