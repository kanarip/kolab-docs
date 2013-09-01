==================
Backup and Restore
==================

389 Directory Server
====================

Backup
------

A backup procedure for 389 Directory Server consists of three separate steps:

#.  The exection of a pre-script to export the databases.
#.  The inclusion of the exported databases in to the backup, along with the
    directory server configuration directory :file:`/etc/dirsrv/`.
#.  Clean-up using a post-script.

A sample combined pre- and post-script that could be used:

.. parsed-literal::

    #!/bin/bash

    if [ "$1" == "--before" ]; then
        for dir in \`find /etc/dirsrv/ -mindepth 1 -maxdepth 1 -type d \\
                -name "slapd-\*" | xargs -n 1 basename\`; do

            for nsdb in \`find /var/lib/dirsrv/${dir}/db/ -mindepth 1 \\
                    -maxdepth 1 -type d | xargs -n 1 basename\`; do

                ns-slapd db2ldif -D /etc/dirsrv/${dir} -n ${nsdb} \\
                    -a /tmp/$(hostname)-$(echo ${dir} | sed -e 's/slapd-//g')-${nsdb}.ldif \\
                    >/dev/null 2>&1

            done
        done

    elif [ "$1" == "--after" ]; then
        rm -rf /tmp/\*.ldif
    fi

This will result in a number of files in :file:`/tmp/`, one per database to be
exact, that you will want to include in the backup.

Database Restore
----------------

For the following procedure to be executed, you must shut down the directory
server service:

.. parsed-literal::

    # :command:`service dirsrv stop`

After the exported databases have been restored from backup, import the LDIFs
back on to the database:

.. parsed-literal::

    # ns-slapd ldif2db \\
        -D /etc/dirsrv/slapd-*$instance_name* \\
        -n *$database_name* \\
        -i /path/to/exported/database.ldif

where:

    *$instance_name*

        is the name of an instance configured on this LDAP server.

    *$database_name*

        is the name for the target database the restore should occur to.

.. NOTE::

    The database for the restore should already exist. In the example situation
    of a migrating an LDAP tree from one LDAP server to another, first add the
    domain on the target server, so that the database is created, then stop
    the service, then restore to the created database.

For example, restoring the previously exported root suffix "dc=mykolab,dc=com"
to a database named ``mykolab_com`` on a system ``kolab.example.org``, run:

.. parsed-literal::

    # ns-slapd ldif2db \\
        -D /etc/dirsrv/slapd-kolab \\
        -n mykolab_com \\
        -i /tmp/kolab.example.org-kolab-mykolab_com.ldif

.. NOTE::

    The location of the LDIF file to restore from as well as the LDIF file to
    restore from itself must be accessible for the user account the directory
    server is configured to run under (usually the unprivileged **nobody**
    account).

Cyrus IMAP
==========

If you stuck with the defaults, and you are not doing a migration or disaster
recovery, you only need to restore from backup what was deleted more than 69
days ago.

Kolab Groupware specifies these defaults to enable you to make sure that
whatever ends up in the IMAP spool at any given point in time can be guaranteed
to be included in at least 1 full backup, even if you create a full backup only
quarterly.

You may have altered this magic number to fit your backup strategy. The default
is 3 months -- two potentially 31 days, one 30 days -- plus 1 week -- the margin
of error when using "first saturday night of the month".

Assuming all full backups succeed, even if you cycle full backups monthly, you
would need to keep 1 volume around per quarter to comply with regulations your
environment may be subject to -- noted that you need to keep around the last
full backup of any given quarter, and not the first of quarter #1 and the last
of quarter #2.

Keep around full backups until you know they are eligible for purging -- you
never know ahead of time whether the next full backup is going to be successful.

Your exact backup needs, regulatory and/or legal requirements, and an
efficient and cost-effective strategy are considered consultancy that
`Kolab Systems AG <http://kolabsys.com>`_ and
`Certified Partners <http://kolabsys.com/partners>`_ are more than happy to
provide you with.

Backup
------

If you have read the :ref:`install-preparing_the_system-partitioning` section of
the :ref:`install`, you can consider using LVM snapshots to backup the Cyrus
IMAP config and spool directories.

Files and directories to include (or not include) in the backup of Cyrus IMAP
include:

*   :file:`/var/spool/imap/`

    You may want to exclude files named:

    *   :file:`cyrus.squat`
    *   :file:`cyrus.cache.NEW`
    *   :file:`cyrus.expunge.NEW`
    *   :file:`cyrus.index.NEW`

    as well as directories named :file:`stage./` and :file:`sync./`

*   :file:`/var/lib/imap/`

    You will want to exclude:

    *   :file:`/var/lib/imap/socket/`
    *   :file:`\*.lock\*`

Restore
-------





MySQL
=====

Databases and Tables You Care About
-----------------------------------

There's little purpose to backing up caches, so consider either:

*   Backing them up under a significantly more volatile strategy, or
*   Not including them in the backup at all.

Backup
------

The backup of MySQL too consists of three steps:

#.  Making the data to backup available in a form the backup program
    understands,

#.  Including the data in the actual backup,

#.  Cleanup.

For the execution of a pre-script, and therefore what data to include in the
backup, as well as the cleanup, a choice should be made between
:ref:`admin-backup-mysql-lvm_snapshots` and :ref:`admin-backup-mysql-mysqldump`.

.. _admin-backup-mysql-mysqldump:

Using :command:`mysqldump`
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _admin-backup-mysql-lvm_snapshots:

Using LVM Snapshots
^^^^^^^^^^^^^^^^^^^

The larger the MySQL database(s), the less likely you are going to backup MySQL
using :command:`mysqldump`. With larger databases, for one, the contents of the
database may change while you're exporting the database. Luckily, there's a
``--single-transaction`` option to :command:`mysqldump`, but again in the case
of larger MySQL databases, this directly impacts production.

Do **NOT** use this method if you can afford to run one or more read-only
slaves. Use whichever method taking the read-only slave offline temporarily and
then back up the data from it.

An alternative to backup MySQL with :command:`mysqldump` is to use LVM snapshots
on a logical volume underneath MySQL:

#.  Flush everything MySQL may have cached to disk,
#.  Lock MySQL,
#.  Create an LVM snapshot,
#.  Unlock MySQL,
#.  Sync the contents of the snapshot anywhere you like.

The trick is in between step 2 and 4, as InnoDB automatically removes any
standing locks at the end of the session. You MUST therefore hold on to the
session while you create the LVM snapshot:

.. parsed-literal::

    (
        date > /var/log/backup-mysql.log && \\
        echo "FLUSH TABLES WITH READ LOCK;" && \\
        sleep *$x* && \\
        lvcreate --size 10G --snapshot \\
            --name lv_mysql_snap /dev/vg_db01/lv_mysql >> \\
            /var/log/backup-mysql.log 2>&1 && \\
        echo "SHOW MASTER STATUS;" && \\
        echo "UNLOCK TABLES;" && \\
        date >> /var/log/backup-mysql.log && \\
        echo "\quit" \\
    ) | mysql >> /var/log/backup-mysql.log 2>&1

Creating a subshell with the output of that subshell piped through MySQL keeps
the session open while creating a snapshot of the logical volume, however:

#.  The flushing of tables establishing a read lock is a command that returns
    immediately. As it requests a global read lock, that waits for all other
    read locks to expire before it actually goes about flushing tables and read
    locking them, this must not be used for database servers that have
    long-running queries (which a Kolab Groupware server has not).

#.  Use the *$x* in "*sleep $x*" to establish the margin in between issuing the
    flush command to MySQL, and the snapshot being created. An increased number
    for *$x* would indicate slower storage and/or larger queries.

.. WARNING::

    While this is actually tested, and it works, please note that you should
    still test for yourself -- using a restore.

On decent database infrastructure with just Kolab Groupware making use of the
environment, outside of office and/or peak hours, flushing, locking and snapshot
creation can take as little as about **3ms**.
