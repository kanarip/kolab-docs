.. _and_kolab-daemon:

================
The Kolab Daemon
================

The Kolab daemon **kolabd** (running as the *kolabd* service) is the Kolab
Groupware component that synchronizes mutations made in LDAP against IMAP.

The following mutations are taken in to account:

*   :ref:`and_kolab-daemon_kolab-user-creation`,
*   :ref:`and_kolab-daemon_kolab-user-modification`,
*   :ref:`and_kolab-daemon_kolab-user-deletion`,
*   :ref:`and_kolab-daemon_kolab-group-deletion`,
*   :ref:`and_kolab-daemon_resource-creation`,
*   :ref:`and_kolab-daemon_resource-modification`,
*   :ref:`and_kolab-daemon_resource-deletion`,
*   :ref:`and_kolab-daemon_shared-folder-creation`,
*   :ref:`and_kolab-daemon_shared-folder-modification`,
*   :ref:`and_kolab-daemon_shared-folder-deletion`,

.. _and_kolab-daemon_kolab-user-creation:

Kolab User Creation
===================

A *Kolab user* is created when a new LDAP object is created under the base dn
configured for a parent domain, which is either;

*   the configured ``kolab_user_base_dn`` in the domain-specific section
    of :manpage:`kolab.conf(5)`,

*   the configured ``user_base_dn`` in the domain-specific section of
    :manpage:`kolab.conf(5)`,

*   the configured ``base_dn`` in the domain-specific section of
    :manpage:`kolab.conf(5)`,

*   the detected root dn for a domain.

This is usually ``ou=People,$root_dn``, where *$root_dn* of course is the root
dn for the directory tree that corresponds with the parent domain.

*Kolab user* entries match the filter setting for Kolab users, either;

*   the configured ``kolab_user_filter`` setting in the domain-specific section
    of :manpage:`kolab.conf(5)`,

*   the configured ``kolab_user_filter`` setting in the generic ``[ldap]``
    section of :manpage:`kolab.conf(5)`,

*   the configured ``user_filter`` setting in the domain-specific section of
    :manpage:`kolab.conf(5)`,

*   the configured ``user_filter`` setting in the generic ``[ldap]``
    section of :manpage:`kolab.conf(5)`,

usually ``(objectclass=kolabinetorgperson)``.

For these new objects, the following actions need to take place;

#.  If configured, the recipient policy needs to be applied to the new entry,

    .. NOTE::

        If the user object was created through the Web Administration Panel, and
        a recipient policy was configured, then the API the Web Administration
        Panel addresses has already applied the recipient policy.

        However, if the Web Administration Panel API was misconfigured, or the
        administrator creating the new user entry was allowed to override the
        default generated values, then the application of the recipient policy
        by the Kolab daemon will:

        #.  Change the primary email address attribute value,

        #.  Add those secondary email address attribute values that the
            recipient policy mandates for compliance.

#.  If the recipient policy mandates any changes need to be made to the user
    object, such as the value for the ``mail`` and/or ``alias`` attributes, a
    callback to LDAP needs to be issued, creating another
    :ref:`and_kolab-daemon_kolab-user-modification` notification to the daemon,

#.  With the resulting set of attributes (modified if the recipient policy has
    had to, unmodified if not), a mailbox needs to be created for the new user,

    .. NOTE::

        For Cyrus IMAP Murder deployments, the Kolab daemon is normally
        configured to initially communicate with a Cyrus IMAP frontend server.

        Unless the target mailbox server had already been supplied by LDAP, the
        Kolab daemon would create the mailbox using the connection to a Cyrus
        IMAP frontend, and await the mailbox entry to re-occur on said frontend.

        At this point in time, the Cyrus IMAP Murder mailbox list will have set
        the ``/shared/vendor/cmu/cyrus-imapd/server`` metadata value to the
        server address of the backend IMAP server the mailbox was created on.

        The Kolab daemon will then set ``mailserver_attribute`` to this address.

#.  Any configured additional default folders need to be created,

    .. NOTE::

        Any configured additional quota(root), annotations and ACLs for each of
        the default folders will need to be reflected,

#.  The user needs to be subscribed to the initial set of folders created for,
    the account,

#.  If not supplied by LDAP already, any configured default quota needs to be
    applied to the IMAP mailbox as well as communicated back to the new user
    object, in case of which a callback to LDAP needs to be issued, which would
    cause another :ref:`and_kolab-daemon_kolab-user-modification` notification
    to the daemon to be issued.

.. _and_kolab-daemon_kolab-user-modification:

Kolab User Modification
=======================

* acl cleanup

.. _and_kolab-daemon_kolab-user-deletion:

Kolab User Deletion
===================

* acl cleanup

.. _and_kolab-daemon_group-deletion:

Group Deletion
=================

* acl cleanup

.. _and_kolab-daemon_resource-creation:

Resource Creation
=================

.. _and_kolab-daemon_resource-modification:

Resource Modification
=====================

.. _and_kolab-daemon_resource-deletion:

Resource Deletion
=================

.. _and_kolab-daemon_shared-folder-creation:

Shared Folder Creation
======================

.. _and_kolab-daemon_shared-folder-modification:

Shared Folder Modification
==========================

.. _and_kolab-daemon_shared-folder-deletion:

Shared Folder Deletion
======================
