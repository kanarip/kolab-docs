========================
Upgrading from Kolab 2.3
========================

As Kolab Groupware used to be distributed as an OpenPKG stack, with different locations for files, the upgrade of a Kolab 2 server to a Kolab 3 server is a largely manual process.

.. NOTE::

    The Kolab 3 server used here has been set up for the same domain name space as the Kolab 2 server. No users have been created on the Kolab 3 server. kolab2.example.org refers to the Kolab 2 server, kolab3.example.org refers to the Kolab 3 server.

.. rubric:: Preparations

1.  During the migration, the Kolab 2 server cannot be allowed to;

    *   Receive new email.
    *   Let users post/submit new data.

    The easiest way to prevent any of this happening is to shut down all Kolab Groupware related services on kolab2.example.org:

    .. parsed-literal::

        # /kolab/bin/openpkg rc stop all

2.  Create a backup of the data from kolab2.example.org.
3.  Shut down the Cyrus IMAP service on kolab3.example.org:

    .. parsed-literal::

        # service cyrus-imapd stop

4.  Shut down the Kolab daemon on kolab3.example.org:

    .. parsed-literal::

        # service kolabd stop

5.  Update the settings related to the recipient policy in /etc/kolab/kolab.conf. The following settings are important:

    *   The primary_mail setting in the [$domain] section.
    *   The policy MUST[2] either match the former convention used, if any, or not be enabled at all. See Example 1.1, “Example Migration of example.org” for an example and some more gotchas.

    .. WARNING::

        In case the recipient policy is not to be applied, consider updating the user_types as per the instructions in Section 5.1, “Editing user_types”.
        The secondary_mail setting in the [$domain] section.

        This part of the policy does not apply should the primary_mail setting already have been disabled.

.. rubric:: Example Migration of example.org

Our first example has had a running Kolab 2.3 on OpenPKG server, with a general email address convention of "surname"@example.org.

By default, a Kolab 3.0 Groupware server will apply a recipient policy for the mail attribute value of "givenname"."surname"@example.org. The recipient policy must therefore be adjusted.

In the [example.org] section in /etc/kolab/kolab.conf, the primary_mail setting must be adjusted to match the "surname"@example.org convention:

    .. parsed-literal::

        (...snip...)
        [example.org]
        primary_mail = %(surname)s@%(domain)s
        (...snip...)

Now, users that are created will get a mail attribute value of "surname"@example.org assigned.

First adding user John Doe will give him a mail attribute value of doe@example.org, but should you have a Jane Doe as well, she would get doe2@example.org. It is therefore important to add users in order.

Migration of LDAP
-----------------

This section has not been authored yet.

Migration and Upgrade of Data
-----------------------------

Migrate the Data Through Copying
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Login to kolab3.example.org to execute the steps in this procedure.

1.  Copy mailboxes.db and annotations.db. These files are located in /kolab/var/imapd/ on your Kolab 2 server.

    .. parsed-literal::

        # scp root@kolab2.example.org:/kolab/var/imapd/annotations.db \\
            /var/lib/imap/annotations.db
        (...)
        # scp root@kolab2.example.org:/kolab/var/imapd/mailboxes.db \\
            /var/lib/imap/mailboxes.db
        (...)

    If cyrus can't start with these files with a message like the following, you need to convert the files instead of copying.
    
    .. parsed-literal::
    
        skiplist: invalid magic header: /var/lib/imap/mailboxes.db
        (...)
        DBERROR: opening /var/lib/imap/mailboxes.db: cyrusdb error
        (...)
        
    Use the following commands to convert the files from Berkeley DB to skiplist:
    
    .. parsed-literal::
    
        ssh root@kolab2.example.org "/kolab/bin/cvt_cyrusdb /kolab/var/imapd/annotations.db /tmp/annotations.db skiplist"
        ssh root@kolab2.example.org "/kolab/bin/cvt_cyrusdb /kolab/var/imapd/mailboxes.db /tmp/mailboxes.db skiplist"
        
    After the conversion, copy the files to the new kolab3 server:
    
        .. parsed-literal::

        # scp root@kolab2.example.org:/tmp/annotations.db \\
            /var/lib/imap/annotations.db
        (...)
        # scp root@kolab2.example.org:/tmp/mailboxes.db \\
            /var/lib/imap/mailboxes.db
        (...)

2.  Migrate the mail spool:

    .. parsed-literal::

        # rsync -rltpHvz --progress --partial \\
            kolab2.example.org:/kolab/var/imapd/spool/ \\
            /var/spool/imap/
        (...)

3.  Migrate the seen and subscription databases:

    .. parsed-literal::

        # rsync -rltpHvz --progress --partial \\
            kolab2.example.org:/kolab/var/imapd/domain/ \\
            /var/lib/imap/domain/
        (...)
        # rsync -rltpHvz --progress --partial \\
            kolab2.example.org:/kolab/var/imapd/user/ \\
            /var/lib/imap/user/
        (...)

4.  Ensure the filesystem permissions are correct:

    .. parsed-literal::

        # chown -R cyrus:mail /var/lib/imap/ /var/spool/imap/

5.  Ensure only the cyrus user can read and write, and the mail group can read the contents of either directory tree:

    .. parsed-literal::

        # find /var/lib/imap -type f -exec chmod 640 {} \\;
        # find /var/lib/imap -type d -exec chmod 750 {} \\;
        
        # find /var/spool/imap -type f -print0 | xargs -0 chmod 640
        # find /var/spool/imap -type d -print0 | xargs -0 chmod 750
        
    If your find doesn't have the -print0 option or your xargs command doesn't know -0, you can use the much slower commands below:
    
    .. parsed-literal::

        # find /var/spool/imap -type f -exec chmod 640 {} \\;
        # find /var/spool/imap -type d -exec chmod 750 {} \\;

6.  As the seen databases are particularly hard for Cyrus IMAP 2.4 to upgrade real-time, convert the seen databases with, for example:

    .. parsed-literal::

        #!/bin/bash

        find /var/lib/imap/ -type f -name "\*.seen" | \
            sort | while read seendb; do
                /usr/lib/cyrus-imapd/cvt_cyrusdb ${seendb} skiplist ${seendb}.txt flat
                mv ${seendb} ${seendb}.orig
                /usr/lib/cyrus-imapd/cvt_cyrusdb ${seendb}.txt flat ${seendb} skiplist
                chown cyrus:mail ${seendb} ${seendb}.txt ${seendb}.orig
            done

7.  Stop the Kolab daemon:

    .. parsed-literal::

        # service kolabd stop

8.  Start the Cyrus IMAP service on kolab3.example.org:

    .. parsed-literal::

        # service cyrus-imapd start

    .. IMPORTANT::
        Users should not yet be allowed to interact with the system at this point. We suggest closing access to the system through the firewall.

        Use the Cyrus IMAP administrator account to select all mailboxes, to make sure the format upgrade is not taking place while the user is attempting to login / select a mailbox.

        Average sized mailboxes (those restricted with a reasonable quota such as 2GB) can take about 2 minutes to upgrade. A single folder can upgrade as fast as 5 seconds. Mailboxes that contain a lot of messages (such as a shared lists folder that also functions as an archive) can take up to 2-4 minutes to upgrade (approximately 40.000 messages).

    .. NOTE::

        Optionally, if errors are expected enable full so-called telemetry logging so that issues can be backtracked. On the IMAP server, issue the following commands:

        .. parsed-literal::

            # mkdir -p /var/lib/imap/log/cyrus-admin
            # chown cyrus:mail /var/lib/imap/log/cyrus-admin

            #!/bin/bash

            kolab lm | while read folder; do
                echo ". SELECT \\"${folder}\\""
            done | \\
                imtest -t "" \\
                    -u ${cyrus_admin} \\
                    -a ${cyrus_admin} \\
                    -w '${cyrus_admin_pw}' \\
                    ${imap_host}

        or, alternatively;

        .. parsed-literal::

            #!/bin/bash

            . ./settings.sh

            echo '. LIST "" "\*"' | \\
                imtest \\
                    -t "" \\
                    -u ${cyrus_admin} \\
                    -a ${cyrus_admin} \\
                    -w '${cyrus_admin_pw}' \\
                    ${imap_host} | \\

                    sed -r \\
                        -e '/^\\* LIST/!d' \\
                        -e 's/.\*\"\/\"\s(.\*)/\1/g' \\
                        -e 's/^"//g' \\
                        -e 's/"$//g' \\
                        -e 's/\s\*\r\*\n\*$//g' | \\

                    while read folder; do
                        echo ". SELECT \\"${folder}\\""
                    done | \\
                        imtest -t "" \\
                            -u ${cyrus_admin} \\
                            -a ${cyrus_admin} \\
                            -w '${cyrus_admin_pw}' \\
                            ${imap_host}

        On your console display, you will see some errors stating NO Permission Denied. These errors you can ignore.
        You'll see messages such as the following appear in ``/var/log/maillog``:

        .. parsed-literal::

            Aug  8 16:40:10 kolab imap[4644]: Index upgrade: example.org!shared.lists.example^org.memo (10 -> 12)
            Aug  8 16:40:10 kolab imap[4644]: seen_db: user cyrus-admin opened /var/lib/imap/user/c/cyrus-admin.seen

9.  The annotations database may not have been upgraded correctly, causing some annotations to miss the first 4 characters of their value. The easiest way to fix the issue, that is known to work, is to get the annotation values as they were on the old (Kolab 2) IMAP server, and set them on the new (Kolab 3) IMAP server.

    .. parsed-literal::

        # kolab -c conf/kolab-kolab2.example.org.conf \\
            list-mailbox-metadata "user/john.doe/Calendar\*@example.org"
        Folder user/john.doe/Calendar@example.org
          /shared/vendor/cmu/cyrus-imapd/lastpop
          /shared/vendor/cmu/cyrus-imapd/partition          default
          /shared/vendor/cmu/cyrus-imapd/lastupdate         8-Aug-2012 16:16:06 +0200
          /shared/vendor/cmu/cyrus-imapd/size               266564
          /shared/vendor/cmu/cyrus-imapd/pop3newuidl        true
          /shared/vendor/cmu/cyrus-imapd/sharedseen         false
          /shared/vendor/kolab/folder-type                  event.default
          /shared/vendor/cmu/cyrus-imapd/condstore          true
          /shared/vendor/cmu/cyrus-imapd/duplicatedeliver   false
          /shared/vendor/kolab/incidences-for               admins
          /shared/vendor/kolab/folder-test                  true
        Folder user/john.doe/Calendar/Private@example.org
          /shared/vendor/cmu/cyrus-imapd/lastpop
          /shared/vendor/cmu/cyrus-imapd/partition          default
          /shared/vendor/cmu/cyrus-imapd/lastupdate         8-Aug-2012 16:08:58 +0200
          /shared/vendor/cmu/cyrus-imapd/condstore          true
          /shared/vendor/cmu/cyrus-imapd/pop3newuidl        true
          /shared/vendor/cmu/cyrus-imapd/size               305426
          /shared/vendor/cmu/cyrus-imapd/sharedseen         false
          /shared/vendor/kolab/folder-type                  event
          /shared/vendor/cmu/cyrus-imapd/duplicatedeliver   false
        # kolab list-mailbox-metadata "user/john.doe/Calendar\*@example.org"
        Folder user/john.doe/Calendar@example.org
          /shared/vendor/cmu/cyrus-imapd/lastpop
          /shared/vendor/cmu/cyrus-imapd/partition          default
          /shared/vendor/cmu/cyrus-imapd/lastupdate         8-Aug-2012 16:16:27 +0200
          /shared/vendor/cmu/cyrus-imapd/duplicatedeliver   false
          /shared/vendor/cmu/cyrus-imapd/pop3newuidl        true
          /shared/vendor/cmu/cyrus-imapd/size               266564
          /shared/vendor/cmu/cyrus-imapd/sharedseen         false
          /shared/vendor/kolab/folder-type                  event.default
        Folder user/john.doe/Calendar/Private@example.org
          /shared/vendor/cmu/cyrus-imapd/lastpop
          /shared/vendor/cmu/cyrus-imapd/partition          default
          /shared/vendor/cmu/cyrus-imapd/lastupdate         8-Aug-2012 16:27:44 +0200
          /shared/vendor/cmu/cyrus-imapd/duplicatedeliver   false
          /shared/vendor/cmu/cyrus-imapd/pop3newuidl        true
          /shared/vendor/cmu/cyrus-imapd/size               305426
          /shared/vendor/cmu/cyrus-imapd/sharedseen         false

    Fix'em:

    .. parsed-literal::

        #!/bin/bash

        # Interesting Annotations
        declare -a ia

        ia[${#ia[@]}]="/shared/vendor/kolab/folder-type"
        ia[${#ia[@]}]="/shared/vendor/kolab/folder-test"

        for folder_search in user/\*@example.org shared/\*@example.org; do
            kolab -c conf/kolab-kolab.kolabsys.com.conf \\
                list-mailbox-metadata "${folder_search}" | \\
                while read line; do
                    if [ ! -z "$(echo $line | grep ^Folder)" ]; then
                        current_folder=$(echo $line | cut -d' ' -f2-)

                        echo "Folder: '${current_folder}'"
                    else
                        annotation_key=$(echo $line | awk '{print $1}')
                        annotation_value=$(echo $line | awk '{print $2}')

                        i=0
                        set_annotation=0
                        while [ $i -lt ${#ia[@]} ]; do
                            if [ "${ia[$i]}" == "${annotation_key}" ]; then
                                set_annotation=1
                                break
                            fi
                            let i++
                        done

                        if [ ${set_annotation} -eq 0 ]; then
                            continue
                        fi

                        echo "Setting ${annotation_key} to ${annotation_value}"

                        kolab set-mailbox-metadata \\
                            "${current_folder}" \\
                            "${annotation_key}" \\
                            "${annotation_value}"
                    fi
                done

        done

10. Upgrade all messages from Kolab Format version 2 to Kolab Format version 3 using kolab-formatupgrade. This command is run in two parts. The first will upgrade all mailbox contents in the personal namespace:

    .. parsed-literal::

        # kolab lm "user/%@example.org" | \\
           sed -e 's/user\///g' | \\
           while read user; do
               kolab-formatupgrade \\
                   --user "${user}" \\
                   --password $password \\
                   --proxyauth cyrus-admin \\
                   --port 143 \\
                   --encrypt TLS \\
                   localhost
           done

11. The second part upgrades the contents of shared folders. Shared folders have no designated owners, and we can therefore not login as a designated user to upgrade the format.

    As the user cyrus-admin normally does not have the necessary privileges to insert new messages into mail folders, so we're going to have to give out the rights first. We'll delete them again afterwards.

    .. parsed-literal::

        # kolab sam shared/\*@example.org cyrus-admin lrswiptexa
        # kolab lm shared/\*@example.org | \\
           while read folder; do
               kolab-formatupgrade \\
                   --user cyrus-admin \\
                   --password $password \\
                   --port 143 \\
                   --encrypt TLS \\
                   --folder "${folder}" \\
                   localhost
           done
        # kolab dam shared/\*@example.org cyrus-admin


