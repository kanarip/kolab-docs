====================================
HOWTO: Use GlusterFS for IMAP Spools
====================================

GlusterFS is a distributed filesystem with built-in redundancy and self-healing
features, that allows invidual storage volumes to be aggregated in to larger
storage volumes.

This HOWTO sets up a single Kolab server using an IMAP spool mounted over
GlusterFS, as illustrated in :ref:`howto-glusterfs-replicated_volume`.

To illustrate the GlusterFS volume scaling, we expand this original GlusterFS
volume in :ref:`howto-glusterfs-distributed_replicated_volume`.

The initial setup consists of the following systems:

*   System ``gfs1.example.org`` with a second disk volume *vdb* of *10GB* and IP
    address 192.168.122.11.
*   System ``gfs2.example.org`` with a second disk volume *vdb* of *10GB* and IP
    address 192.168.122.12.
*   System ``kolab.example.org``.

The ``IN A`` address for ``gfs.example.org`` is made to resolve to the .11
**and** .12 IP addresses.

.. _howto-glusterfs-replicated_volume:

GlusterFS Replicated Volume
===========================

The initial setup looks as follows:

.. graphviz::

    digraph {
            nodesep=1

            "Kolab Server" -> "GlusterFS"

            subgraph cluster_gluster {
                    "GlusterFS" -> "Brick #1", "Brick #2";

                    subgraph {
                            rank=same;
                            "Brick #1" -> "Brick #2" [dir=both];
                        }
                }
        }

In this scenario, the Kolab server uses a GlusterFS volume mount for its IMAP
spool, that is redundant as both bricks contain the same data.

1.  Partition ``/dev/vdb`` on ``gfs1`` and ``gfs2`` as follows:

    .. parsed-literal::

        # :command:`parted /dev/vdb`
        GNU Parted 3.1
        Using /dev/vdb
        Welcome to GNU Parted! Type 'help' to view a list of commands.
        # :command:`mklabel gpt`
        Warning: The existing disk label on /dev/vdb will be destroyed and all \
        data on this disk will be lost.
        Do you want to continue? Yes/No? yes
        # :command:`unit GB`
        # :command:`mkpart primary 0GB 10GB`
        # :command:`set 1 lvm on`

2.  Create a physical volume, then a volume group, then a logical volume on both
    ``gfs1`` and ``gfs2``:

    .. parsed-literal::

        # :command:`pvcreate /dev/vdb`
        # :command:`vgcreate vg_gfs /dev/vdb`
        # :command:`lvcreate -L 9GB -n lv_brick vg_gfs`

    .. NOTE::

        The logical volume ``lv_brick`` leaves 10% of the volume group unused
        for two purposes:

            #.  Filesystem checks can be performed on a logical volume snapshot,
                without interrupting the storage availability, and

            #.  Backups can be made using logical volume snapshots without
                interrupting storage availability.

3.  On both ``gfs1`` and ``gfs2``, create a filesystem on the new logical
    volume:

    .. parsed-literal::

        # :command:`mkfs.ext4 /dev/vg_gfs/lv_brick`

4.  Create a mount point for the filesystem:

    .. parsed-literal::

        # :command:`mkdir -p /srv/gfs`

5.  Configure the mount to be made on system startup and mount:

    .. parsed-literal::

        # :command:`echo "/dev/vg_gfs/lv_brick /srv/gfs ext4 defaults 1 2" >> \
            /etc/fstab`
        # :command:`mount -a`

6.  Create the directory to be exported as a brick:

    .. parsed-literal::

        # :command:`mkdir -p /srv/gfs/brick`

    .. WARNING::

        Do not use the filesystem root directory ``/srv/gfs/`` as the brick to
        export, for its ``lost+found/`` directory will be rendered corrupt and
        useless.

7.  Install the ``glusterfs``, ``glusterfs-fuse`` and ``glusterfs-server``
    packages on ``gfs1`` and ``gfs2``:

    .. parsed-literal::

        # :command:`yum -y install glusterfs{,-fuse,-server}`

8.  Start the **glusterd** service and configure it to start when the system
    boots:

    .. parsed-literal::

        # :command:`service glusterd start`
        # :command:`chkconfig glusterd on`

9.  Use ``gfs1`` and probe the other GlusterFS node:

    .. parsed-literal::

        # :command:`gluster peer probe gfs2.example.org`

10. Create the GlusterFS volume to provide to ``kolab.example.org``:

    .. parsed-literal::

        # :command:`gluster volume create imap0 \
            gfs1.example.org:/srv/gfs/brick/ gfs2.example.org:/srv/gfs/brick/`

11. Start the new volume:

    .. parsed-literal::

        # :command:`gluster volume start imap0`

12. Continue with :ref:`howto-glusterfs-configuring_the_glusterfs_client`.

.. _howto-glusterfs-distributed_replicated_volume:

GlusterFS Distributed Replicated Volume
=======================================

This part of the HOWTO assumes we are expanding a
:ref:`howto-glusterfs-replicated_volume` and you already have followed
:ref:`howto-glusterfs-configuring_the_glusterfs_client`.

We'll be expanding the GlusterFS storage volume from *10GB* to *20GB*, by
configuring the GlusterFS volume to become a distributed volume (on top of being
replicated).

The number of nodes required for this is **4** -- distributing files over two
bricks, each of which replicate with a replica brick. We will therefore add
nodes:

*   System ``gfs3.example.org`` with a second disk volume *vdb* of *10GB* and IP
    address 192.168.122.13.
*   System ``gfs4.example.org`` with a second disk volume *vdb* of *10GB* and IP
    address 192.168.122.14.

1.  Partition ``/dev/vdb`` on ``gfs3`` and ``gfs4`` as follows:

    .. parsed-literal::

        # :command:`parted /dev/vdb`
        GNU Parted 3.1
        Using /dev/vdb
        Welcome to GNU Parted! Type 'help' to view a list of commands.
        # :command:`mklabel gpt`
        Warning: The existing disk label on /dev/vdb will be destroyed and all \
        data on this disk will be lost.
        Do you want to continue? Yes/No? yes
        # :command:`unit GB`
        # :command:`mkpart primary 0GB 10GB`
        # :command:`set 1 lvm on`

2.  Create a physical volume, then a volume group, then a logical volume on both
    ``gfs3`` and ``gfs4``:

    .. parsed-literal::

        # :command:`pvcreate /dev/vdb`
        # :command:`vgcreate vg_gfs /dev/vdb`
        # :command:`lvcreate -L 9GB -n lv_brick vg_gfs`

    .. NOTE::

        The logical volume ``lv_brick`` leaves 10% of the volume group unused
        for two purposes:

            #.  Filesystem checks can be performed on a logical volume snapshot,
                without interrupting the storage availability, and

            #.  Backups can be made using logical volume snapshots without
                interrupting storage availability.

3.  On both ``gfs3`` and ``gfs4``, create a filesystem on the new logical
    volume:

    .. parsed-literal::

        # :command:`mkfs.ext4 /dev/vg_gfs/lv_brick`

4.  Create a mount point for the filesystem:

    .. parsed-literal::

        # :command:`mkdir -p /srv/gfs`

5.  Configure the mount to be made on system startup and mount:

    .. parsed-literal::

        # :command:`echo "/dev/vg_gfs/lv_brick /srv/gfs ext4 defaults 1 2" >> \
            /etc/fstab`
        # :command:`mount -a`

6.  Create the directory to be exported as a brick:

    .. parsed-literal::

        # :command:`mkdir -p /srv/gfs/brick`

    .. WARNING::

        Do not use the filesystem root directory ``/srv/gfs/`` as the brick to
        export, for its ``lost+found/`` directory will be rendered corrupt and
        useless.

7.  Install the ``glusterfs``, ``glusterfs-fuse`` and ``glusterfs-server``
    packages on ``gfs3`` and ``gfs4``:

    .. parsed-literal::

        # :command:`yum -y install glusterfs{,-fuse,-server}`

8.  Start the **glusterd** service and configure it to start when the system
    boots:

    .. parsed-literal::

        # :command:`service glusterd start`
        # :command:`chkconfig glusterd on`

9.  Use ``gfs1`` and probe the new GlusterFS nodes:

    .. parsed-literal::

        # :command:`gluster peer probe gfs3.example.org`
        # :command:`gluster peer probe gfs4.example.org`

10. Add the new bricks to the existing volume:

    .. parsed-literal::

        # :command:`gluster volume add-brick imap0 \
            gfs3.example.org:/srv/gfs/brick gfs4.example.org:/srv/gfs/brick`

11. Rebalance the bricks (use ``gfs1`` or ``gfs2``):

    .. parsed-literal::

        # :command:`gluster volume rebalance imap0 start`
        # :command:`watch -n 1 gluster volume rebalance imap0 status`

12. When the rebalancing of the volume has been completed, remounting the volume
    on the GlusterFS client(s) makes it appreciate the change in storage volume.

    .. parsed-literal::

        # :command:`mount -o remount /var/spool/imap/`

.. graphviz::

    digraph {
            nodesep=1

            "Kolab Server" -> "GlusterFS"

            subgraph cluster_gluster {
                    "GlusterFS" -> "Brick #1", "Brick #2", "Brick #3", "Brick #4";

                    subgraph {
                            rank=same;
                            "Brick #1" -> "Brick #2" [dir=both];
                            "Brick #3" -> "Brick #4" [dir=both];
                        }
                }
        }


.. [root@kolab ~]# netstat -anp | grep gluster
.. tcp        0      0 192.168.121.56:1015         192.168.121.12:24009        ESTABLISHED 1597/glusterfs
.. tcp        0      0 192.168.121.56:1023         192.168.121.12:24007        ESTABLISHED 1597/glusterfs
.. tcp        0      0 192.168.121.56:1016         192.168.121.11:24009        ESTABLISHED 1597/glusterfs
.. tcp        0      0 192.168.121.56:1011         192.168.121.14:24009        ESTABLISHED 1597/glusterfs
.. tcp        0      0 192.168.121.56:1022         192.168.121.13:24009        ESTABLISHED 1597/glusterfs
.. unix  2      [ ]         DGRAM                    2062670 1597/glusterfs

.. _howto-glusterfs-configuring_the_glusterfs_client:

Configuring the GlusterFS Client
================================

Using ``kolab.example.org``, this procedure configures the GlusterFS client to
mount the ``imap0`` volume.

1.  Install the ``glusterfs`` and ``glusterfs-fuse`` packages:

    .. parsed-literal::

        # :command:`yum -y install glusterfs{,-fuse}`

2.  Configure the mount to be made on system startup and mount:

    .. parsed-literal::

        # :command:`echo "gfs.example.org:/imap0 /var/spool/imap/ glusterfs defaults,_netdev 0 0" >> /etc/fstab`
        # :command:`mount -a -t glusterfs`

3.  Change the directory ownership back to its original owner and group:

    .. parsed-literal::

        # :command:`chown cyrus:mail /var/spool/imap/`
        # :command:`chmod 750 /var/spool/imap/`

FAQ
===

What happens when a GlusterFS node fails?
-----------------------------------------

In a replica *n* volume, *n*-1 nodes can fail. For each individual brick, at
least one replica must stay alive.

In situations where you might expect or are required take in to account the
failure of multiple nodes (that are replicas) simultaneously, such as might be
the case when using old desktop PCs for your storage, you should increase the
number of replicas.

There is a significant initial performance hit for the GlusterFS client, as it
merely starts to realize one of the volume's bricks is no longer available.

The write performance should not be impacted significantly, but the read
performance is -- not unlike with RAID 1 replicated disk volume.

You can find peers that are unavailable as being disconnected:

.. parsed-literal::

    # :command:`gluster peer status`
    Number of Peers: 3

    Hostname: gfs2.example.org
    Uuid: 5e68482a-4164-4cfb-af2c-61a64cf894a7
    State: Peer in Cluster (Connected)

    Hostname: gfs3.example.org
    Uuid: 89073c71-1cf7-4d6e-af93-dab8f13cee14
    State: Peer in Cluster (**Disconnected**)

    Hostname: gfs4.example.org
    Uuid: fb7db59d-aaee-4dcc-98e3-c852243c8024
    State: Peer in Cluster (Connected)

When the node comes back online, it will automatically repair itself before it
is deemed connected. During the downtime, and during the repair, it is
crucially important the other replica(s) does not fail as well.

Replica *x*, Distribute *y* - how much storage, how many nodes?
---------------------------------------------------------------

The total storage volume available is impacted most significantly by the number
of replicas -- the distribution is a JBOD aggregation of volumes.

.. <dialt0ne> hm. where do you set cluster.background-self-heal-count ? http://ur1.ca/eqih1
.. <glusterbot> Title: #27073 Fedora Project Pastebin (at ur1.ca)
.. * jskinner_ (~jskinner@69.170.148.179) has joined #gluster
.. <xdexter> nsupdate need bind instaled?
.. * failshel_ (~failshell@lpr157.lapresse.ca) has joined #gluster
.. <semiosis> dialt0ne: gluster volume set cluster.background-self-heal-count 2
.. <semiosis> dialt0ne: gluster volume set $volname cluster.background-self-heal-count 2
.. <semiosis> it's undocumented
.. * failshell has quit (Read error: Operation timed out)
.. <dialt0ne> hm.
.. <dialt0ne> it's been set. performance is still a dog :-\
.. <dialt0ne> Options Reconfigured: cluster.background-self-heal-count: 2
.. <dialt0ne> set cluster.data-self-heal-algorithm to full now, see if that's helpful