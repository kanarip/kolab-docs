========================
Kolab Groupware and LDAP
========================

Kolab Groupware makes extensive use of LDAP, and has unique capabilities that,
should you choose to use them, may require the use of a particular LDAP server
implementation as a result.

To allow you the greatest flexibility (you do not have to decide today), Kolab
ships the community version of **Red Hat Directory Server**, called
**389 Directory Server** (formerly known as *Fedora Directory Server*).

.. NOTE::

    If you are new to LDAP, we suggest reading the :ref:`and_ldap_intro`.

Kolab Groupware uses LDAP for, among other things:

*   Authentication of users and services, through
    :ref:`and_ldap_kolab-saslauthd`,

*   Mail Exchangers to decide whether to accept or reject messages, and how to
    route accepted messages based on information contained in LDAP,

*   the authoritative list of mailboxes to be maintained in IMAP, through
    :ref:`and_ldap_kolabd`,

*   the Global Address Book for users, distribution groups, contacts, shared
    folders and resources,

*   In Kolab 3.0, for single parent domain deployments only, translation of the
    authentication ID into the authorization ID (a process called
    canonification).

*   In Kolab 3.1 and later, for multi- parent domain deployments, translation of
    the authentication ID into the authorization ID (a process called
    canonification) for the web client only.

*   In Kolab 3.2 and later, for multi- parent domain deployments, translation of
    the authentication ID into the authorization ID (a process called
    canonification) for both the web client and IMAP itself, as well as group
    ACLs for IMAP based on roles or (simple) group membership.

For this purpose, Kolab is configured to use a **service account**, usually
``uid=kolab-service,ou=Special Users`` in the primary domain's root dn.

This service account is intended to have read access throughout all directory
entries, across all directory trees, as it is used to read lists of domain name
spaces locally hosted, and valid recipient and sender addresses in those domain
name spaces.

During setup, this account is configured to circumvent **size**, **search**,
**lookthrough** and other administrative limitations configured on normal
accounts, that protect your LDAP server's performance.

.. _and_ldap_kolabd:

**kolabd**
==========

The Kolab daemon **kolabd** is responsible for the synchronization of changes in
LDAP that are to be relected on the IMAP mail boxes and folders and access
control.

It uses either searches or replication mechanisms available in the LDAP server,
depending on the LDAP server's capabilities.

For each of the mutations in LDAP, the daemon takes the appropriate actions
against IMAP, such as;

*   Creating mailboxes for new users, shared folders and resources,
*   Renaming mailboxes for entries that have changed, when appropriate,
*   Deleting mailboxes for entries that have been removed,

as well as communicates back any further changes to LDAP should they be needed
-- for example, the enforcement of policies such as the recipient policy.

.. rubric:: See Also

*   :ref:`and_kolab-daemon`

.. _and_ldap_kolab-saslauthd:

**kolab-saslauthd**
===================

The Kolab SASL Authentication Daemon **kolab-saslauthd** is responsible for
verifying the user credentials supplied to the IMAP server and the :term:`MSA`,
in turn using the following key steps:

#.  The authentication realm as provided in the (user-supplied) login username,
    or the primary domain name space (the default realm),

#.  The LDAP domain object that corresponds to the authentication realm,

#.  The associated DIT root dn for the domain,

#.  The user entry corresponding with the provided (user-supplied) login
    username,

#.  An attempt to bind with the user entry DN found is made, using the
    (user-supplied) login password.

Steps 2 and 4 are LDAP searches, that depending on the size of the deployment
may take longer than would be considered good performance.

.. rubric:: See Also

.. todo::

    Administration Guide topic for LDAP deployments with single trees growing
    over 1.000 entries.

The Difference Between Accounts and Users
=========================================

It is important to note that there is a difference between a *user* and an
*account* -- of the type that a cow is an animal, but an animal is not a cow.

There is only one type of user, and that is a human being physically present in
this time and space.

While these users tend to have accounts (*user accounts*), other types of
accounts include service accounts, administration accounts and system accounts.

A service account included with a default Kolab Groupware setup is
**kolab-service** [#]_. This account enables *services* such as for example
Postfix, to search LDAP for entries (recipients hosted by the local Kolab
Groupware installation), without disclosing the contents of the entire LDAP tree
to everyone (anonymously).

An administration account that Kolab Groupware uses by default is
**cyrus-admin**. This account is made a Cyrus IMAP administrator (see the
``admins`` setting in :manpage:`imapd.conf(5)`), and is used by Kolab daemons to
maintain the mailboxes and other IMAP related policies.

On the other hand, your Linux system likely holds accounts such as **root** and
**nobody**. These would typically be considered **system accounts**. To make
sure Kolab Groupware daemons and applications do not have unrestricted access to
your entire system (or your data, for that matter), additional system accounts
are created on your system.

Parent, Alias and Child Domain Namespaces
=========================================

All email environments make use of at least one :term:`domain name space`.
Without it, only recipient addresses that are local could be exchanged messages
with, but not the rest of the Internet. A local user ``doe`` must be qualified
to the rest of the Internet as being user ``doe`` in a domain name space (such
as ``example.org``) -- this is what makes an email address ``doe@example.org``.

An organization -- anything ranging from just you to your family or a
multi-national corporation -- for which Kolab Groupware is being setup, will
have to choose a :term:`primary domain` for the deployment. The domain name
space choosen will be used for the email addresses if its users.

An organization such as the **Kolab Community** might, for example, setup Kolab
for the primary domain ``kolab.org``. The Doe family though might setup Kolab
with a primary domain of ``doe.nl``.

Because domain name spaces typically only have one owner, it is recommended to
use the domain components that make up the domain to also make up the LDAP root
dn. The Kolab Community would therefore result in ``dc=example,dc=org``, and the
Doe family would use ``dc=doe,dc=nl``. This is also the default during the Kolab
setup.

Multi-Domain Deployments
------------------------

There are two types of additional domains one might add to a Kolab Groupware
deployment.

**parent domains**

    Like mentioned before, these are domains with a separate, isolated LDAP
    directory trees. Adding a parent domain other than the primary domain
    establishes a true multi-domain deployment.

    .. NOTE::

        A default Kolab Groupware deployment is not set up to handle multiple
        parent domains out-of-the-box.

**alias domains** / **child domains**

    Alias domains are additional domains to use with existing parent domains.

Kolab Groupware sets you up with 4 domain name spaces by default:

#.  As the :term:`primary domain name space` for the entire deployment, you
    supply a domain name space of your choosing during setup.

    This domain name space defaults to the domain name space your system FQDN
    resides in.

    For a system FQDN of ``kolab.example.org`` for example, the default domain
    name space for email would be ``example.org``.

#.  Your systems' FQDN, in order to make sure fully qualified local email is
    indeed delivered locally.

    With the previous example in mind, this would be a domain name space of
    ``kolab.example.org``. Local POSIX users, including the **root** superuser,
    tend to receive email to addresses such as ``root@kolab.example.org``.

#.  ``localhost``, and
#.  ``localhost.localdomain``.

The primary domain is also known as a so happens to also be called a
:term:`parent domain name space`.

The :term:`parent domain name space` (of ``example.org``) is how we would like
to refer to the domain ("the organization") as a whole, but additional domains
may be available to its users, such as ``example.net``.

The ``example.net`` domain name space in this case is called an
:term:`alias domain name space` or :term:`child domain name space` (depending on
the nature of your setup).

It is important to note that in Kolab Groupware, each organization receives its
own :term:`root dn`, meaning its own, separate LDAP directory tree. This allows
Kolab Groupware to use multiple LDAP servers, and allows organizations to use
features such as the Global Address Book without a compromise to security and
privacy. As such, each :term:`parent domain name space` for each organization
directly corresponds to a DIT root dn.

For mail sent to recipients in either domain name space (``example.org`` or
``example.net``), the same root dn (of ``dc=example,dc=org``) will need to be
searched in order to determine whether the intended recipient is in fact a valid
recipient, and what mailbox to use for delivery.

Users, distribution groups, resources and shared folders may be configured using
either of the domain name spaces as the resident domain for their primary
recipient address, for example ``john.doe@example.org`` and
``jane.doe@example.net``.

For additional information on LDAP, and your Kolab deployment, please see:

*   :ref:`deployment_organizations-with-multiple-domain-namespaces`.
*   :ref:`admin_organizations-with-multiple-domain-namespaces`.

.. _and_ldap_389-directory-server:

Integration with 389 Directory Server
=====================================

389 Directory Server is by far the preferred Kolab Groupware LDAP server, not in
the least because it supports;

* Multi-master replication with up to 4 masters [#]_,
* Effective Rights controls support [#]_,
* Persistent Search controls support,
* Dynamic configuration of databases, indexes, replicas and replication
  agreements,
* Dynamic configuration and execution of tasks, such as consumer initialization
  and re-indexing.

.. graphviz::

    digraph ldap_multi_master {
            label="Multi-Master Replication Between LDAP Servers"
            nodesep=1
            subgraph {
                rank=same
                "LDAP #1" -> "LDAP #2" [dir=both];
            }
            "LDAP #1" -> "LDAP #3" [dir=both];
            "LDAP #1" -> "LDAP #4" [dir=both];
            "LDAP #2" -> "LDAP #3" [dir=both];
            "LDAP #2" -> "LDAP #4" [dir=both];
            subgraph {
                rank=same
                "LDAP #3" -> "LDAP #4" [dir=both];
            }
        }

Further scaling could be achieved by putting read-only replicas in front of the
LDAP write masters. Services such as :ref:`and_ldap_kolab-saslauthd` could make
use of these LDAP read-only replicas, as well as MTA and MUA applications.

.. graphviz::

    digraph ldap_multi_master {
            label="Multi-Master Replication Between LDAP Servers"
            nodesep=1
            subgraph cluster_masters {
                    subgraph {
                        rank=same
                        "LDAP #1" -> "LDAP #2" [dir=both];
                    }
                    "LDAP #1" -> "LDAP #3" [dir=both];
                    "LDAP #1" -> "LDAP #4" [dir=both];
                    "LDAP #2" -> "LDAP #3" [dir=both];
                    "LDAP #2" -> "LDAP #4" [dir=both];
                    subgraph {
                        rank=same
                        "LDAP #3" -> "LDAP #4" [dir=both];
                    }
            } -> "LDAP #5", "LDAP #6", "LDAP #7", "LDAP #8";
        }

.. .. rubric:: Default Domain Tree Layout
..
.. .. graphviz::
..
..     digraph ldap_tree {
..             rankdir=BT
..             "ou=Groups" -> "dc=example,dc=org" [dir=none];
..             "ou=People" -> "dc=example,dc=org" [dir=none];
..             "ou=Special Users" -> "dc=example,dc=org" [dir=none];
..             "cn=Directory Administrators" -> "dc=example,dc=org" [dir=none];
..             "cn=kolab-admin" -> "dc=example,dc=org" [dir=none];
..         }

389 Directory Server and Multi-Domain
-------------------------------------

389 Directory Server supports the real-time addition and configuration of new
root dn databases.

.. _and_ldap_mapping-a-domain-name-space-to-a-dit-root-dn:

Mapping a Domain Name Space to a Directory Tree Root DN
-------------------------------------------------------

A domain name space, which can be a parent or alias domain name space,
corresponds with a directory tree that contains the users, groups, resources,
roles and shared folders for that domain.

A directory information tree's root dn can be established almost entirely
arbitrarily, and as such a domain name space of ``example.org`` may actually
(need to) correspond to a root dn of ``o=internal,o=example,c=de``.

Kolab Groupware therefore uses the LDAP object classes ``domainRelatedObject``
and ``inetDomain``. With these object classes, the following attributes are
available:

    *   ``associatedDomain``, used as the container for domain name spaces,
    *   ``inetDomainBaseDn``, used as the container for the associated directory
        information tree root dn.

Applications must therefore query the configured :term:`domain_base_dn` for
objects (filtered by value of the configured :term:`domain_name_attribute`) and
look for the configured :term:`domain_result_attribute` on objects found.

Should the result attribute not be included with the LDAP object, as is the case
for a default Kolab Groupware installation, then the standard root dn can be
composed.

Since alias domain name spaces may be specified to a parent domain name space,
applications must make sure that the first value of the
:term:`domain_name_attribute` attribute is used to establish the parent domain
name space.

Using the parent domain name space, as follows:

    #.  Explode the parent domain name space into its components as they are
        divided by dot (.) characters.

        For a parent domain name space of ``example.org``, this should give you
        a list with a component ``example``, and a component ``org``.

    #.  Implode the components using ``,dc=`` as the delimiter.

        For an exploded domain name space of ``example.org``, this should turn
        the list resulting from the previous step ([``example``, ``org``]) into
        a string ``example,dc=org``.

    #.  Prepend the string ``dc=``.

Supported Features
------------------

Virtual List View (VLV)

    Virtual List View control is an LDAP feature that allows a user to query the
    database virtually unprohibited by size, administrative or lookthrough
    limitations.

    In 389 Directory Server, the configuration for VLV is stored as part of the
    LDBM database configuration in ``cn=ldbm database,cn=plugins,cn=config``.
    This makes the configuration for VLV available to discovery.

    * :ref:`admin_ldap_configure-vlv`

    .. NOTE::

        The use of Virtual List View controls requires the use of Server-side
        Sorting.

Server-side Sorting (SSS)

    Server-side Sorting control is an LDAP feature that allows a user to have
    the server sort the results of a query.

    * :ref:`admin_ldap_configure-sss`

Default Attribute Use
---------------------

Kolab object types are generally based off existing LDAP object classes
and LDAP attributes.

.. _and_ldap_default-kolab-user:

A Default Kolab User
^^^^^^^^^^^^^^^^^^^^

A Kolab user is an LDAP entry with the following object classes:

    *   ``top``
    *   ``person``
    *   ``organizationalperson``
    *   ``inetorgperson``
    *   ``mailrecipient``
    *   ``kolabinetorgperson`` (from Kolab LDAP schema extensions)

and commonly at least the following attributes:

    *   ``mail``
    *   ``displayName``
    *   ``preferredLanguage``
    *   ``sn``
    *   ``cn``
    *   ``givenName``
    *   ``uid``
    *   ``mailHost``
    *   ``mailQuota``
    *   ``userPassword``

Additional attributes include:

    *   ``initials``
    *   ``o``
    *   ``title``
    *   ``street``
    *   ``postalCode``
    *   ``l``
    *   ``mobile``
    *   ``pager``
    *   ``alias``
    *   ``mailAlternateAddress``
    *   ``kolabInvitationPolicy`` (from Kolab LDAP schema extensions)
    *   ``kolabDelegate`` (from Kolab LDAP schema extensions)
    *   ``kolabAllowSMTPSender`` (from Kolab LDAP schema extensions)
    *   ``kolabAllowSMTPRecipient`` (from Kolab LDAP schema extensions)

Example entry:

.. parsed-literal::

    dn: uid=doe,ou=People,dc=example,dc=org
    alias: doe@example.org
    alias: j.doe@example.org
    givenName: John
    preferredLanguage: en_US
    sn: Doe
    cn: John Doe
    displayName: Doe, John
    mail: john.doe@example.org
    uid: doe
    objectClass: top
    objectClass: inetorgperson
    objectClass: kolabinetorgperson
    objectClass: mailrecipient
    objectClass: organizationalperson
    objectClass: person
    userPassword:: e1NTSEF9NkF4YVJ4VUE0R0FTMm1DMGlMdFNTZU90RUM0UW1PN1lPcHlwY3c9PQ=

.. _and-ldap-kolab-static-distribution-group:

A Static Kolab Distribution Group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A static distribution group is a group with one or more recipient
addresses, for which inbound message traffic is distributed among the
individual members of the group.

Members need to be added to and removed from the distribution group
individually, contrary to a
:ref:`and-ldap-kolab-dynamic-distribution-group`.

Object classes for a static distribution group:

    *   ``top``
    *   ``groupofuniquenames``
    *   ``kolabgroupofuniquenames`` (from Kolab LDAP schema extensions)

Attributes:

    *   ``mail``
    *   ``uniquemember``

Optional additional attributes:

    *   ``kolabAllowSMTPSender`` (from Kolab LDAP schema extensions)
    *   ``kolabAllowSMTPRecipient`` (from Kolab LDAP schema extensions)

Example entry:

.. parsed-literal::

    # static, Groups, example.org
    dn: cn=static,ou=Groups,dc=example,dc=org
    cn: static
    mail: static@example.org
    objectClass: top
    objectClass: groupofuniquenames
    objectClass: kolabgroupofuniquenames
    uniquemember: uid=doe,ou=People,dc=example,dc=org

.. _and-ldap-kolab-dynamic-distribution-group:

A Dynamic Kolab Distribution Group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A dynamic distribution group is a group with one or more recipient
addresses, that resolves to a set of individual members dynamically,
through executing another search in LDAP.

This means, for example, a dynamic group does not need to be updated to
include "everyone in department $x", if the fact somebody is in
department $x can be determined using an LDAP attribute value or OU
structure.

.. seealso::

    *   :ref:`and-ldap-kolab-static-distribution-group`.

Object classes for a dynamic distribution group:

    *   ``top``
    *   ``groupofurls``
    *   ``kolabgroupofuniquenames`` (from Kolab LDAP schema extensions)

Attributes:

    *   ``mail``
    *   ``memberurl``

Optional additional attributes:

    *   ``kolabAllowSMTPSender`` (from Kolab LDAP schema extensions)
    *   ``kolabAllowSMTPRecipient`` (from Kolab LDAP schema extensions)

Example entry:

.. parsed-literal::

    # dynamic, Groups, example.org
    dn: cn=dynamic,ou=Groups,dc=example,dc=org
    cn: dynamic
    mail: dynamic@example.org
    objectClass: top
    objectClass: groupofurls
    objectClass: kolabgroupofuniquenames

A Kolab Resource
^^^^^^^^^^^^^^^^

Object classes:

    *   ``top``
    *   ``kolabSharedFolder`` (from Kolab LDAP schema extensions)
    *   ``mailRecipient``

Attributes:

    *   ``mail``
    *   ``kolabTargetFolder`` (from Kolab LDAP schema extensions)
    *   ``kolabFolderType`` (from Kolab LDAP schema extensions)

Example entry:

.. parsed-literal::

    dn: cn=Mercedes SLK,ou=Resources,dc=example,dc=org
    cn: Mercedes SLK
    kolabTargetFolder: shared/Resources/Mercedes SLK@example.org
    mail: resource-car-mercedesslk@example.org
    objectClass: top
    objectClass: kolabsharedfolder
    objectClass: mailrecipient
    kolabFolderType: event

A Kolab Shared Folder
^^^^^^^^^^^^^^^^^^^^^

Object classes:

    *   ``top``
    *   ``kolabSharedFolder`` (from Kolab LDAP schema extensions)

Attributes:

    *   ``kolabFolderType`` (from Kolab LDAP schema extensions)

Example entry:

.. parsed-literal::

    dn: cn=Shared Address Book,ou=Shared Folders,dc=example,dc=org
    cn: Shared Address Book
    kolabFolderType: contact
    objectClass: top
    objectClass: kolabsharedfolder

.. _and_ldap_use-of-mailalternateaddress:

Primary Email Address (``mail``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. NOTE::

    The primary email address may be subject to a recipient policy,
    which applies common rules to existing user information, to compose
    the primary email address.

    This recipient policy can be executed in one of three ways, see
    :ref:`admin_rcpt-policy`.

Secondary Email Address(es) (``alias``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

External Email Address(es) (``mailAlternateAddress``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _and_ldap_openldap:

Integration with OpenLDAP
=========================


.. rubric:: Footnotes

.. [#] This service account is located at ``uid=kolab-service,ou=Special Users,$root_dn``
.. [#] `Red Hat Directory Server 9.0 Administration Guide on Configuring Multi-Master Replication <https://access.redhat.com/site/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Managing_Replication-Configuring_Multi_Master_Replication.html>`_
.. [#] `Red Hat Directory Server 9.0 Administration Guide on Retrieving Effective Rights <https://access.redhat.com/site/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/running-ldapsearch-with-controls.html#example-ger-control>`_
