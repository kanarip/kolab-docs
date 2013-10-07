.. _deployment_hosted-kolab:

=================================
Hosted Kolab Groupware Deployment
=================================

A Hosted Kolab Groupware Deployment consists of at least two separate parent
domain name spaces.

It's intended use case is to allow the sale of accounts, whether they be
individual user accounts, or domain accounts, and whether they require payment
(for example, `MyKolab.com <https://mykolab.com>`_) or not
(for example, `Kolab.org Demo <https://kolabsys.com/try>`_).

#.  The first :term:`parent domain name space` is referred to as the
    :term:`management domain`.

    This is typically the location for service users, and users servicing the
    systems (such as system administrators and support staff), as well as
    privilege and permission groups (for example, ``sysadmin-main`` group
    membership to allow the use of ``sudo``).

#.  The second :term:`parent domain name space` is either the first of many
    hosted domains, or the :term:`primary hosted domain`.

    A primary hosted domain is typically open for user self-registration, such
    as https://demo.kolab.org via https://kolabsys.com/try

.. graphviz::

    digraph {
            label="Hosted Kolab Groupware Deployment - LDAP Layout";
            subgraph cluster_kolabsys {
                    label="Management Domain";
                    "dc=kolabsys,dc=net" -> "ou=Groups" [dir=none];
                    "dc=kolabsys,dc=net" -> "ou=People", "ou=Special Users" [dir=none];
                    "ou=People" -> "uid=sysadmin1", "uid=sysadmin2" [dir=none];
                    "ou=Special Users" -> "uid=cyrus-admin", "uid=kolab-service" [dir=none];
                }

            subgraph cluster_mykolab {
                    label="Primary Hosted Domain";
                    "ou=People 1" [label="ou=People",dir=none];
                    "dc=mykolab,dc=com" -> "ou=People 1" [dir=none];
                    "ou=People 1" -> "uid=jdoe", "uid=jroe" [dir=none];
                }
        }

Using this distinction allows a Hosted Kolab Groupware provider to;

*   Configure its systems to authenticate against LDAP, while maintaining a
    guarantee no customers are accidentally allowed to do so.

*   Authorize a service or application user account to create new accounts in
    the primary hosted domain.

*   Authorize a service or application user account to read the information of
    selected domain name spaces.

.. graphviz::

    digraph {
            "dc=mykolab,dc=com" -> "ou=People" [dir=none];
            "ou=People" -> "uid=jdoe", "uid=jroe" [dir=none];
            "uid=hosted-kolab-service,ou=Special Users,dc=kolabsys,dc=net" -> "ou=People" [label="write access"];
            "uid=hosted-kolab-service,ou=Special Users,dc=kolabsys,dc=net" -> "associateddomain=mykolab.com" [label="read access",color=green];
            "uid=hosted-kolab-service,ou=Special Users,dc=kolabsys,dc=net" -> "associateddomain=customer.tld" [label="no access",color=red];
        }

Registration and Payment Processes
==================================

Registration of an email address (to one of the hosted domain name spaces open
for user registration), would require some confirmation of ownership, and some
means to contact the user.

It is deemed sufficient for a user to specify an external email address, and
complete payment, to get an account activated.

.. graphviz::

    digraph {
            "User Signup" -> "External Email Address Confirmation" -> "Payment" -> "Activation";
        }

Subsequent Changes and Account Suspension
-----------------------------------------

Payment is a regularly occuring process, and the amount is subject to changes in
user subscriptions.

It is paramount to immediately activate new subscriptions, both in terms of user
expectations and because activation of user subscription options during or after
payment includes some potential attack vectors.

The account is degraded (some functionality is removed), or de-activated
entirely, should payment become overdue.

Domain Registration Process
---------------------------

A domain registration process is more complicated, since before the domain is
active (even within the environment it is registered in), ownership of the
domain needs to be confirmed.

If this crucial step is not taken, the environment is subject to a variety of
internal attack vectors, including phishing.

.. graphviz::

    digraph {
            "Domain Signup" -> "External Email Address Confirmation" -> "Domain Ownership Confirmation" -> "Activation", "Payment";
            "Domain Ownership Confirmation" -> "Domain User(s) Creation" -> "Payment";
        }

User Registration
=================

If one or more domains are open for user registration,

Domain Registration
===================

Differentiating Access Levels
=============================

Establishing different access levels in a hosted Kolab Groupware environment
allows a provider to associate different features with costs incurred to the
customer.

Among other levels, the following levels of access could be defined:

*   Web client access,
*   Plugins for the web client on a per-plugin basis,
*   Settings-based features for the web client, on a per-setting basis,
*   Direct IMAP access (for desktop clients and other IMAP clients),
*   Server-side filtering (Manage Sieve),
*   Mobile device synchronization through ActiveSync,
*   CalDAV/CardDAV access,
*   WebDAV access

The methodology to distinguish access levels is based on authorization
parameters such as the roles associated with a user's account and/or group
membership. Kolab Groupware recommends using roles, as they are far more
scalable than group membership, to establish authorization to services.

An example scenario building a hosted Kolab Groupware environment could be to
require additional payment for the use of ActiveSync to synchronize mobile
devices, whereas all other services and access levels are included in a base
price for the account.

The following roles would be defined, with their associated access levels:

#.  ``cn=activesync-user,dc=mykolab,dc=com``,

    A user of ActiveSync. This role is typically added when the user selects the
    option, and authorizes the user to use mobile device synchronization through
    ActiveSync.

#.  ``cn=imap-user,dc=mykolab,dc=com``,

    A regular user account. This role is typically added after the user's
    account has received initial payment.

#.  ``cn=suspended-user,dc=mykolab,dc=com``

    A suspended user has overdue payments, and could therefore not be allowed to
    send any email any longer.

    It is generally considered prohibitively punitive to not allow the user to
    access his/her data any longer, and therefore this is considered an
    intermediate state for the account to allow timely recovery of full
    functionality.

    A deployment could opt to also suspend delivery to the account, but should
    bear in mind that delivery failure is likely considered data loss.

Multiple Parent Domain Root DNs and Access Levels
-------------------------------------------------

When using roles to establish access to applications or features including the
Kolab Web Client, any of its plugins, Chwala, iRony and/or Syncroton, an
environment with multiple parent domain name spaces must take into account the
names or roles are variable.

The **kolab_auth** plugin for the Kolab Web Client, responsible for using roles
to determine additional plugins to enable, and settings to enforce, can use the
following syntax to allow a single set of definitions to apply to multiple root
dns:

.. parsed-literal::

    cn=imap-user,%dc

``%dc`` is expanded to the domain root dn. See
:ref:`and_ldap_mapping-a-domain-name-space-to-a-dit-root-dn` for more
information.

Multi-Domain Hosted Environments and SSL Certificates
=====================================================

A hosted Kolab Groupware environment with customers registering their own domain
name spaces instructs them to use addresses for services in the primary hosted
domain by default. The primary hosted domain should have a valid SSL certificate
signed by a publically trusted certificate authority.

For an example customer *example.org*, therefore, the location for the web
client would be https://webmail.mykolab.com, and the IMAP server would be
imaps://imap.mykolab.com. Users in the *example.org* domain would login using
their full email address.

Should a customer require a dedicated SSL certificate to their domain, so that
the customer's users can use https://webmail.example.org and/or
imaps://imap.example.org, it is important to take into account that therefore
the domain name space needs to be associated with a dedicated public IP address.

While modern browsers can deal with the HTTP host header negotiation prior to
encrypting the connection, most mobile devices can not.

In other words, while https://webmail.example.org (for modern browsers) does not
strictly require a unique service IP address to be associated with it, you must
consider that https://activesync.example.org/Microsoft-Server-ActiveSync does.

Furthermore, auto-discovery protocols often mistakenly assume addresses such as
https://autodiscover.example.org and https://example.org contain valid automatic
configuration, and sometimes fall back to, and sometimes do not even have
implemented at all, the query for SRV records such as
_autodiscover._tcp.example.org, which is eligible to contain a value pointing to
another web server http host address (that an SSL certificate is available for).

Using a dedicated service IP address resolves an issue with desktop clients as
well; The use of addresses such as ``imap.example.org`` and ``smtp.example.org``
would trigger an alert about the validity of the SSL certificate used, if the
service IP address for these DNS records pointed to the same service IP address
as those DNS records used for the primary hosted domain.

Setting a Domain Base DN
------------------------

Hosted Kolab Groupware deployments that choose to allow users to register
domain names should consider setting the ``domain_base_dn`` setting in the
``[ldap]`` section of **kolab.conf(5)** to a location in a directory tree that
is a database, and can therefore be indexed and replicated.

In the example referred to previously, this would look as follows:

.. graphviz::

    digraph {
        "dc=kolabsys,dc=net" -> "ou=Domains";
        "ou=Domains" -> "associateddomain=kolabsys.net", "associateddomain=mykolab.com";
    }
