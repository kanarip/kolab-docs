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

.. .. _and_ldap_root-dns-that-are-not-organizations:
..
.. Known Root DNs That are Not Organizations
.. ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
..
.. Depending on the LDAP server technology implemented, the exceptions to the rule
.. a root dn corresponds to a domain name space might include:
..
.. * ``o=NetscapeRoot``, the container for 389 Directory Server configuration.
.. * ``cn=schema``, an interface to maintain schemas in OpenLDAP.
.. * ``cn=config``, including ``cn=schema,cn=config``, otherwise known as the DSE,
..   again storing configuration. With 389 Directory Server, the root DSE is not
..   a database.
..

.. rubric:: Parent, Alias and Child Domain Namespaces

An organization -- anything ranging from just you to your family or a
multi-national corporation -- might have a domain name space of ``example.org``,
and a DIT root dn of ``dc=example,dc=org``. The :term:`parent domain name space`
(of ``example.org``) is how we would like to refer to the domain ("the
organization") as a whole, but additional domains may be available to its users,
such as ``example.net``.

The ``example.net`` :term:`domain name space` in this case is called an
:term:`alias domain name space`.

For mail sent to recipients in either domain name space (``example.org`` or
``example.net``), the same root dn will need to be searched in order to
determine whether the intended recipient is in fact a valid recipient, and what
mailbox to use for delivery.

Users, distribution groups, resources and shared folders may be configured using
either of the domain name spaces as the resident domain for their primary
recipient address, for example john.doe@example.org and jane.doe@example.net.

For additional information on LDAP, and your Kolab deployment, please see:

*   :ref:`deployment_organizations-with-multiple-domain-namespaces`.
*   :ref:`admin_organizations-with-multiple-domain-namespaces`.

LDAP Usage
==========

Kolab Groupware uses LDAP for the following purposes:

*   To determine which domain name spaces are considered local destinations, in
    part or in full,
*   To determine valid local recipient email addresses,
*   To determine the host on which the user's mailbox resides,
*   To determine the recipient address for final delivery,
*   To determine the relay destination,
*   As the authoritative list of users to create and maintain mailboxes for,
*   As the authoritative list of shared folders to create and maintain mailboxes
    for,
*   As the authoritative list of individual resources to create and maintain
    mailboxes for,
*   As the source for static distribution group expansion into its individual
    members,
*   As the source for dynamic distribution group expansion into its individual
    members,
*   Authentication of users and services,
*   Translation of the authentication ID into the authorization ID (a process
    called canonification),
*   To determine whether IMAP access control identifiers are valid,
*   Delegation of control over directory tree contents,
*   To determine valid identities for user email submission,
*   The authoritative source of user mailbox quota,
*   ...

For this purpose, Kolab is configured to use a **service account**, usually
``uid=kolab-service,ou=Special Users`` in the primary domain's root dn.

This service account is intended to have read access throughout all directory
entries, across all directories.

.. todo:: Document the size, lookthrough and administrative limitations.

.. _and_ldap_389-directory-server:

Integration with 389 Directory Server
=====================================

389 Directory Server is by far the preferred Kolab Groupware LDAP server, not in
the least because it supports;

* Multi-master replication with up to 4 masters [#f1]_,
* Effective Rights controls support [#f2]_,
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

.. _and_ldap_use-of-mailalternateaddress:

Primary Email Address (``mail``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. NOTE::

    The primary email address may be subject to a recipient policy, which
    applies common rules to existing user information, to compose the primary
    email address.

Secondary Email Address(es) (``alias``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

External Email Address(es) (``mailAlternateAddress``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _and_ldap_openldap:

Integration with OpenLDAP
=========================


.. rubric:: Footnotes

.. [#f1] `Red Hat Directory Server 9.0 Administration Guide on Configuring Multi-Master Replication <https://access.redhat.com/site/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Managing_Replication-Configuring_Multi_Master_Replication.html>`_
.. [#f2] `Red Hat Directory Server 9.0 Administration Guide on Retrieving Effective Rights <https://access.redhat.com/site/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/running-ldapsearch-with-controls.html#example-ger-control>`_
