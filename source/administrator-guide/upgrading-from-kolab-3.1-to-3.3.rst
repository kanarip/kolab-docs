====================================
Upgrade Notes from Kolab 3.1 to 3.3
====================================

This chapter contains some upgrade notes for moving forward from Kolab 3.1 to
Kolab 3.3. You can use this guide aswell for upgrading from Kolab 3.2 to 3.3.
The differences aren't that many.

ChangeLog
=========

While Kolab 3.2 mostly included backend and groundlaying changes for upcoming
realases due to switching to Cyrus IMAPd 2.5, Kolab 3.3 now ships with couple
new and updated frontend and admin modules.

Kolab 3.3 compared to Kolab 3.1 ships the following additional components:

#.  **Birthday Calender**

    This feature was already incuded in Kolab Groupware 3.2

#.  **New roundcube release**

    The folder structure has changed. Roundcube has moved their public
    web content into a *public_html/* folder. While it tries to be backwards
    compatible, you might want to check your virtual host configuration if
    you've actually modified it.

#.  **E-Mail Tagging**

    The roundcube plugin *kolab_tags* supports taggging of e-mails

#.  **Notes**

    The roundcube plugin *kolan_notes* supports writing and sharing notes.
    Via syncroton these notes can be managed via the active sync protocol
    as well.

    You can also create shared notesfolders for groups.

#.  **Resource Management**

    While managing resources was already included in the Kolab Webadmin GUI,
    the roundcube frontend was missing a component to search, check and book
    resources. This part makes use of freebusy informations to actually
    show the availabilities.

#.  **Freebusy**

    The freebusy web daemon now supports caching of freebusy informations
    and resources. You might want to update/replace your configuation to
    support resources, etc.

#.  **Wallace**

    The wallace daemon now includes modules for checking iTip invitations
    and resource booking requests. Wallace is now enabled by default in new
    Kolab 3.3 installations. If you want to make use of it, you must integrate
    it in the postfix mail flow.

#.  **IMAP ACL editor (kolab-webadmin)**

    You can now create share folders within the kolab-webadmin and manage 
    and enforce initial access control lists for those folders.

#.  **Organizatioal Unit Editor (kolab-webadmin)**

    Those installations that make use of bigger LDAP Directories or
    manage corporation addressbooks within LDAP can now make use of the OU
    Editor instead of relying on external LDAP Editors. The ou management
    includes an ACL Editor for LDAP targets.



Updating the system
===================

These update procecures are just an example. They don't differ too much from
a basic installation.


CentOS 6
--------

Update the repo to the new location

 .. parsed-literal::

    # :command:`cd /etc/yum.repos.d/`
    # :command:`rm Kolab*.repo`
    # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.3/CentOS_6/Kolab:3.3.repo`
    # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/CentOS_6/Kolab:3.3:Updates.repo`

run the upgrade process

 .. parsed-literal::

    # :command:`yum update`


Debian 7
--------

Update the repo to the new location

 .. parsed-literal::

    # :command:`echo "deb http://obs.kolabsys.com/repositories/Kolab:/3.3/Debian_7.0/ ./
    deb http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/Debian_7.0/ ./" > /etc/apt/sources.list.d/kolab.list`

Import the new Release Keys

 .. parsed-literal::

    # :command:`wget -qO - http://obs.kolabsys.com/repositories/Kolab:/3.3/Debian_7.0/Release.key | apt-key add -`
    # :command:`wget -qO - http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/Debian_7.0/Release.key | apt-key add -`

If you've don't have set a correct apt-pinning, please check the Installation Guide.

Update and Upgrade the system

 .. parsed-literal::

    # :command:`apt-get update`
    # :command:`apt-get dist-upgrade`

 .. WARNING::

    You'll get ask if you want to replace your configuration files! DON'T overwrite them!
    You'll lose your configuration and credentials and end up with a broken frontend.


Update your configuration files
===============================

If you want to check want configuration files have changed, the best way is to 
compare the previous and current version in the GIT repository.


/etc/kolab/kolab.conf
---------------------

You can see the configuration differences here:

    http://git.kolab.org/pykolab/diff/conf/kolab.conf?id=pykolab-0.7.1&id2=pykolab-0.6.10

These are the values that have been updated. Please change them in your configuration
depending on your installation and needs


 .. parsed-literal::

    [ldap]
    sharedfolder_acl_entry_attribute = acl
    modifytimestamp_format = %Y%m%d%H%M%SZ
    
    [kolab_smtp_access_policy]
    delegate_sender_header = True
    alias_sender_header = True
    sender_header = True
    xsender_header = True
    cache_uri = <copy and paste mysql uri from the kolab_wap section>

    [wallace]
    modules = resources, invitationpolicy, footer
    kolab_invitation_policy = ACT_ACCEPT_IF_NO_CONFLICT:example.org, ACT_MANUAL

If you're planning to make use of wallace please make sure wallace is enabled to start
using :command:`chkconfig` on RHEL/Centos or :file:`/etc/default/wallace` on debian.

Restart the services

 .. parsed-literal::

    # :command:`service kolab-server restart`
    # :command:`service wallace restart`


/etc/kolab-freebusy/config.ini
------------------------------

You can see the configuration differences here:

    http://git.kolab.org/kolab-freebusy/diff/config/config.ini.sample?id=kolab-freebusy-1.0.5&id2=kolab-freebusy-1.0.3

Instead of editing the configuration by hand it's easier to just recreate the
configuration using the setup-kolab tool.

For Redhat/CentOS

 .. parsed-literal::

    # :command:`cp /etc/kolab-freebusy/config.ini.rpmnew /etc/kolab-freebusy/config.ini`

For Debian

 .. parsed-literal::

    # :command:`cp /etc/kolab-freebusy/config.ini.dpkg-dist /etc/kolab-freebusy/config.ini`

Recreatae the configuation:

 .. parsed-literal::

   # :command:`setup-kolab freebusy`


/etc/roundcubemail/config.inc.php
---------------------------------

You can see the configuration differences here:

    http://git.kolab.org/pykolab/diff/share/templates/roundcubemail/config.inc.php.tpl?id=pykolab-0.7.1&id2=pykolab-0.6.10

Change the plugin load order the follwing way:

#.  move *kolab_auth* to the top position
#.  move *kolab_config* after *kolab_addressbook*
#.  add *kolab_notes* after *kolab_folders*
#.  add *kolab_tags* after *kolab_notes*


/etc/roundcubemail/password.inc.php
-----------------------------------

You can see the configuration differences here:

    http://git.kolab.org/pykolab/diff/share/templates/roundcubemail/password.inc.php.tpl?id=pykolab-0.7.1&id2=pykolab-0.6.10

Change the password driver from **ldap** to **ldap_simple**.

 .. parsed-literal::

    $config['password_driver'] = 'ldap_simple';


/etc/iRony/dav.inc.php
----------------------

You can see the configuration differences here:

    http://git.kolab.org/iRony/diff/config/dav.inc.php.sample?id=54802da29dd4e77ca8c716f6c24c1aabef3a3c1f&id2=iRony-0.2.4

The iRony configuration doesn't have anything special configurations.
You might want to consider just to take the new default config file
or change it based on the differences between the previous version.

For Redhat/CentOS

 .. parsed-literal::

    # :command:`cp /etc/iRony/dav.inc.php.rpmnew /etc/iRony/dav.inc.php`

For Debian

 .. parsed-literal::

    # :command:`cp /etc/iRony/dav.inc.php.dpkg-dist /etc/iRony/dav.inc.php`


/etc/postfix/ldap/virtual_alias_maps_sharedfolders.cf
-----------------------------------------------------

To fix the handling of resource invitations you've to adjust your existing
virtual alias maps, otherwise you end up with non-delivery-reports. 

Please update your filter with this new default configuration:

 .. parsed-literal::

    query_filter = (&(|(mail=%%s)(alias=%%s))(objectclass=kolabsharedfolder)(kolabFolderType=mail))

Restart the postfix daemon

 .. parsed-literal::

    # :command:`service postfix restart`


/etc/postfix/master.cf
----------------------

You can see the configuration differences here:

    http://git.kolab.org/pykolab/diff/share/templates/master.cf.tpl?id=pykolab-0.7.1&id2=pykolab-0.6.10

This will put wallace as the next content-filter after the mail has been
returned from amavis to postfix. If you're don't want to make use of iTip 
processing or resource management you can skip this section.

 .. parsed-literal::

    [...]
    127.0.0.1:10025     inet        n       -       n       -       100     smtpd
        -o cleanup_service_name=cleanup_internal
        -o content_filter=smtp-wallace:[127.0.0.1]:10026
        -o local_recipient_maps=
    [...]

Restart the postfix daemon

 .. parsed-literal::

    # :command:`service postfix restart`

The mail flow will be the following:

#.  postfix receives mail (running on port :25 and port :587)
#.  postfix sends mail to amavisd (running on port 127.0.0.1:10024)
#.  amavisd checks mail
#.  amavisd sends mail to postfix (running on port 127.0.0.1:10025)
#.  postfix sends mail to wallace (running on port 127.0.0.1:10026)
#.  wallace checks the message for itip, resources, etc
#.  wallace sens mail to postfix (running on port 127.0.0.1:10026)
#.  postfix will start delivering the mail (external or internal)


mysql database: kolab
---------------------

A couple new features are relying new tables (organizational units).
The shared folder have been extended to make use of the **acl** editor.

You can find the full sql file here:

#.  web: http://git.kolab.org/kolab-wap/tree/doc/kolab_wap.sql?id=kolab-webadmin-3.2.1
#.  locally: :file:`/usr/share/doc/kolab-webadmin/kolab_wap.sql`

The kolab-webadmin package doesn't provide auto updates or upgrade files
for your database. Here's a summary of what has been changed. 

If you've made changes on the shared folder types you might want to 
change the types manually in the settings section of kolab-webadmin.

Open the mysql cli:

 .. parsed-literal::

    # :command:`mysql -u root -p -D kolab`

and apply the followin changes: The tables will be deleted and recreated.
Don't forget: if you've made changes to shared folder types, please update
them manually!

 .. code-block:: sql

    --
    -- Table structure for table `ou_types`
    --
    
    DROP TABLE IF EXISTS `ou_types`;
    /*!40101 SET @saved_cs_client     = @@character_set_client */;
    /*!40101 SET character_set_client = utf8 */;
    CREATE TABLE `ou_types` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `key` text NOT NULL,
      `name` varchar(256) NOT NULL,
      `description` text NOT NULL,
      `attributes` longtext NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `name` (`name`)
    ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
    /*!40101 SET character_set_client = @saved_cs_client */;
    
    --
    -- Dumping data for table `ou_types`
    --
    
    LOCK TABLES `ou_types` WRITE;
    /*!40000 ALTER TABLE `ou_types` DISABLE KEYS */;
    INSERT INTO `ou_types` VALUES (1,'unit','Standard Organizational Unit','A standard organizational unit definition','{\"auto_form_fields\":[],\"fields\":{\"objectclass\":[\"top\",\"organizationalunit\"]},\"form_fields\":{\"ou\":[],\"description\":[],\"aci\":{\"optional\":true,\"type\":\"aci\"}}}');
    /*!40000 ALTER TABLE `ou_types` ENABLE KEYS */;
    UNLOCK TABLES;
    
    
    --
    -- Table structure for table `sharedfolder_types`
    --
    
    DROP TABLE IF EXISTS `sharedfolder_types`;
    /*!40101 SET @saved_cs_client     = @@character_set_client */;
    /*!40101 SET character_set_client = utf8 */;
    CREATE TABLE `sharedfolder_types` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `key` text NOT NULL,
      `name` varchar(256) NOT NULL,
      `description` text NOT NULL,
      `attributes` longtext NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `name` (`name`)
    ) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
    /*!40101 SET character_set_client = @saved_cs_client */;
    
    --
    -- Dumping data for table `sharedfolder_types`
    --
    
    LOCK TABLES `sharedfolder_types` WRITE;
    /*!40000 ALTER TABLE `sharedfolder_types` DISABLE KEYS */;
    INSERT INTO `sharedfolder_types` VALUES (1,'addressbook','Shared Address Book','A shared address book','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"contact\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(2,'calendar','Shared Calendar','A shared calendar','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"event\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(3,'journal','Shared Journal','A shared journal','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"journal\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(4,'task','Shared Tasks','A shared tasks folder','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"task\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(5,'note','Shared Notes','A shared Notes folder','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"note\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(6,'file','Shared Files','A shared Files folder','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"file\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(7,'mail','Shared Mail Folder','A shared mail folder','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"mail\"],\"objectclass\":[\"top\",\"kolabsharedfolder\",\"mailrecipient\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[],\"alias\":{\"type\":\"list\",\"optional\":true},\"kolabdelegate\":{\"type\":\"list\",\"autocomplete\":true,\"optional\":true},\"kolaballowsmtprecipient\":{\"type\":\"list\",\"optional\":true},\"kolaballowsmtpsender\":{\"type\":\"list\",\"optional\":true},\"kolabtargetfolder\":[],\"mail\":[]}}');
    /*!40000 ALTER TABLE `sharedfolder_types` ENABLE KEYS */;
    UNLOCK TABLES;

After the database update has been applied. Logout from the kolab-webadmin interface
and login back in to load the new changes.


