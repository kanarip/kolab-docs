==============
Shared Folders
==============

Types of Shared Folders
=======================

*   Shared Addressbook
*   Shared Calendar
*   Shared Journal
*   Shared Mail Folder
*   Shared Tasks


Creating a Shared Mail Folder
=============================

Open the kolab-webadmin an got to the "Shared Folders Section.

In the following example we want to create a "info" mailbox where multiple users

#.  Add Shared Folder

    Choose **Shared Mail Folder**

#.  Set your Folder Name

    Folder Name: **info**

#.  Email Address

    Every shared mail folder must have an email address attached.
    Usually the format is <foldername>@<primary_domain>

    Feel free to add secondary email addresses (alias) if you need them.

    Email: **info@kolab.example.org**

#.  Delegates

    If you want that other people should be allowed to send on behalf of the 
    shared mail folder, you must add them as delegates. 

    P.S. Don't forget to manually add the identity with your email to your 
    identities in roundcube or your standalone mailclient.

#.  Target IMAP Folder

    This is the IMAP Destination where the shared mailbox is getting stored.
    It should match foldername and email address.

    Folder: **shared/info@kolab.example.org**

#.  Verify

    you should now have your shared mailbox created within cyrus

    .. parsed-literal::

        # :command:`kolab lm | grep shared`
        shared/info@kolab.example.org


Maintaining Folder Permissions
==============================

Every newly created shared folder is public readable to anyone on the IMAP server.
While this can be useful if you want to have public announcement folders in 
your organization, but in most cases you want to control the user group that
is allowed to access and admin this folder.

#.  The default ACL after you created a shared folder

    .. parsed-literal::
    
        # :command:`kolab lam shared/info@kolab.example.org`
        Folder shared/info@kolab.example.org
          lrs           anyone

    Each letter of the ACL flags stands for one right. (l=list, r=red, s=seen flag)
    This ACLs mean anyone connected to the IMAP Server has the right to read the
    shared folder contents.

#.  Maybe you want to revoke that anyone can read this shared folder
  
    .. parsed-literal::
    
        # :command:`kolab dam shared/info@kolab.example.org anyone`
        Folder shared/info@kolab.example.org

#.  Give provide full administrative rights to the new shared folder owner

    .. parsed-literal::
    
        # :command:`kolab sam shared/info@kolab.example.org john.doe@kolab.example.org all`

    The acl "all" is an alias for the imap acl "lrswipkxtecda". You can find all the
    access rights in the IMAP reference or command line reference linked below.

#.  Verify

    .. parsed-literal::
    
        # :command:`kolab lam shared/info@kolab.example.org`
        Folder shared/info@kolab.example.org
          lrswipkxtecda john.doe@kolab.example.org

#.  Maintaining additional users

    As soon as the owner is set, you can either add additional permissions via
    the cli interface or delegate this work to the new owner. With the roundcube
    folder management interface he's abe to add and remove additional users.

    But keep in mind: Adding delegates has to be done via kolab-webadmin and not 
    via roundcube.

    **Roundcube > Settings > Folders > (Select Folder) > Permissions**


Receiving Mails into a Shared Mailbox
=====================================

If you wanto to receive mails from the outside world, you must ensure 2 things.

#.  Postfix

    Postfix is configured to include the the sharedfolders configuration in the
    virtual_alias_maps parameter.

    .. parsed-literal::
    
        # :command:`postconf virtual_alias_maps`
        virtual_alias_maps = $alias_maps, ldap:/etc/postfix/ldap/virtual_alias_maps.cf, ldap:/etc/postfix/ldap/virtual_alias_maps_mailforwarding.cf, ldap:/etc/postfix/ldap/virtual_alias_maps_sharedfolders.cf, ldap:/etc/postfix/ldap/mailenabled_distgroups.cf, ldap:/etc/postfix/ldap/mailenabled_dynamic_distgroups.cf

#.  Cyrus
    
    You must set the **p (post)** flag/permission on the shared mail folder, to allow
    cyrus/lmtp to post messages into the folder. Otherwise you'll end up with 
    permission or mailbox not found error messages.

    .. parsed-literal::
    
        # :command:`kolab sam shared/info@kolab.example.org anyone p`

    verify your acl

    .. parsed-literal::
    
        # :command:`kolab lam shared/info@kolab.example.org`
        Folder shared/info@kolab.example.org
          p             anyone
          lrswipkxtecda john.doe@kolab.example.org


Additional References
=====================

You want to read the following references to understand the commands used above:

*   :ref:`admin_cli_set-mailbox-acl`
*   :ref:`admin_cli_list-mailbox-acl`
*   :ref:`admin_cli_delete-mailbox-acl`
*   :ref:`admin_imap-access-rights-reference`
