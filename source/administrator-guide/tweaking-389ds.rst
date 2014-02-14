=============================
Tweaking 389 Directory Server
=============================

.. _admin_ldap_controlling_indexes_and_indexing:

Controlling Indexes and Indexing
--------------------------------

Indexes are created for individual attributes, and may consist of one or more of
the following three types:

#.  Presence

    A presence index for attributes services queries with a filter such as
    "``(cn=*)``".

#.  Equality

    An equality index for an attribute services queries with a filter such as
    "``(mail=john.doe@example.org)``".

#.  Substring

    A substring index for an attribute services queries with a filter such as
    "``(mail=*joh*)``".

Presence and substring indexes may be used with, for example, auto-completion,
while equality indexes may be used in, for example, LDAP lookup tables for
Postfix.

Listing the current indexes for a database could be done using a script such as:

    https://git.kolab.org/kolab-scripts/plain/utils/list-attribute-indexes.sh

Adding new attribute indexes for a database, and executing the task to create
the index, could be done with a script such as:

    https://git.kolab.org/kolab-scripts/plain/utils/add-attribute-index.sh

Recommended Additional Indexes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``alias``

    Kolab Groupware by default uses the ``alias`` attribute to store additional
    recipient email addresses for users. This attribute is not indexed by
    default.

``mailAlternateAddress``

    While the ``mailAlternateAddress`` is used, by default, as a container of
    any external email addresses for a user (such as a private or personal email
    address), you may find it is searched as part of auto-completion.

    Especially when using VLV/SSS, should the ``mailAlternateAddress`` attribute
    index be a substring index, but it only contains an equality index by
    default.

.. _admin_ldap_configure-vlv:

Configuring Virtual List View Control
-------------------------------------

On the side of the LDAP server, Virtual List Views consist of two separate
configuration items:

#.  The search, with a base dn, scope and filter.

#.  The index that includes the Server-Side Sorting parameters.

For an LDAP client to successfully use Virtual List View controls, it is
crucially important that:

#.  The search base dn and scope match the configuration of the VLV search, and

#.  Any attributes searched in addition to the configured VLV search filter are
    appropriately indexed.

By default, the configuration of primarily the Kolab web client uses the
following configuration parameters for browsing the LDAP address book:

.. rubric:: For Individual Contact Entries

*   **Search Base DN**: *ou=People,$root_dn*

    where *$root_dn* is the relevant root suffix, such as ``dc=example,dc=org``.

*   **Search Scope**: *sub*
*   **Search Filter**: *(objectClass=inetOrgPerson)*

.. NOTE::

    The search parameters for address book entries are deliberately **not**
    limited to only include other Kolab user entries.

The configuration for the LDAP address book also lists the order of attributes
to use when sorting the entries:

#.  displayname,
#.  sn,
#.  givenname,
#.  cn

.. rubric:: For Groups

*   **Search Base DN**: *ou=Groups,$root_dn*

    where *$root_dn* is the relevant root suffix, such as ``dc=example,dc=org``.

*   **Search Scope**: *sub*
*   **Search Filter**: *(|(objectClass=groupOfUniqueNames)(objectClass=groupOfUrls))*

.. NOTE::

    For groups too, the search parameters for address book entries are
    deliberately **not** limited to only include other Kolab user entries.

The configuration for the LDAP address book also lists the order of attributes
to use when sorting the entries:

#.  cn

Creating the VLV and SSS configuration objects in an LDAP server may be achieved
using the following scripts, in order:

#.  Creating the VLV Search configuration in LDAP:

    https://git.kolab.org/kolab-scripts/plain/populate-ldap/10a-add-vlv-searches.sh

#.  Creating the VLV Indexes with Sorting configuration in LDAP:

    https://git.kolab.org/kolab-scripts/plain/populate-ldap/10b-add-vlv-indexes.sh

#.  Subsquently, the index tasks should be executed:

    https://git.kolab.org/kolab-scripts/plain/populate-ldap/10c-run-vlv-index-tasks.sh

.. _admin_ldap_configure-sss:

Configuring Server-side Sorting Control
---------------------------------------

.. _admin_ldap_increasing-max-open-fds:

Increasing the Maximum Number of File Descriptors
-------------------------------------------------

A 389 Directory Server is configured to open at most 1024 so-called file
descriptors, which include database pointers and network sockets.

To increase this number to, for example, 8192:

#.  Edit :file:`/etc/sysconfig/dirsrv`, adding a line:

    .. parsed-literal::

        ulimit -n 8192

#.  Stop the directory server:

    .. parsed-literal::

        # :command:`service dirsrv stop`

#.  Edit :file:`/etc/dirsrv/slapd-*/dse.ldif` and replace the following line:

    .. parsed-literal::

        nsslapd-maxdescriptors: 1024

    for:

    .. parsed-literal::

        nsslapd-maxdescriptors: 8192

#.  Start the directory server back up:

    .. parsed-literal::

        # :command:`service dirsrv start`

.. _admin_ldap_7bit-password-check:

Disabling the 7-bit Password Enforcement
----------------------------------------

By default, 389 Directory Server has enabled a plugin to only allow passwords to
consist of 7-bit characters.

Older systems and software applications do not support the use of 8-bit
characters (i.e., non-ASCII) in passwords, and to prevent compatibility issues,
this plugin is enabled by default.

To allow 8-bit characters, disable the **7-bit check** plugin:

.. parsed-literal::

    # :command:`ldapmodify -x -h localhost -D "cn=Directory Manager" -W`
    Enter LDAP Password:
    dn: cn=7-bit check,cn=plugins,cn=config
    changetype: modify
    replace: nsslapd-pluginEnabled
    nsslapd-pluginEnabled: off

    modifying entry "cn=7-bit check,cn=plugins,cn=config"

A restart of the directory service is required for this change the become
active:

.. parsed-literal::

    # :command:`service dirsrv restart`
