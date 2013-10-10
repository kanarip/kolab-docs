=======
Storage
=======

Storage considerations are a complex matter as the various options provide or
restrict one's ability to adjust the necessary parameters as the need arises.

The most important considerations include;

*   Data Redundancy
*   Speed
*   Scalability
*   Volume
*   Cost

Storage is not a part of Kolab Groupware, in that it ships a particular storage
solution as part of the product, and it has no particular requirements for
storage either.

As such, your SAN, NAS, local disk, local array of disks or network share could
be used, although the following considerations are important:

*   The Kolab Groupware IMAP spool is I/O intensive (large volumes of data are
    read and get written).
*   The IMAP spool consists of many small files.

As such, we recommend you take into account;

*   The available bandwidth between the IMAP server and the storage provider,
*   The protocol overhead if file-level read and/or write locking is required.

Volume
======

Regardless of the volume of storage in total, this section relates to the volume
of storage allocated to any one singular specific purpose in Kolab Groupware,
and capacity planning in light of that (not the layer providing the storage).

Archiving and e-Discovery notwithstanding, the largest chunks of data volume you
are going to find in Kolab Groupware are the live IMAP spools.

Each individual IMAP spool is considered a volume, or part of a volume if you
feel inclined to share volumes across Cyrus IMAP backend instances. Regardless,
you need a filesystem **somewhere** (even if the bricks building the volume are
distributed) -- the recommended restrictions you should put forth to the
individual chunks of storage lay therein.

Saturating the argument to make a point, imagine, if you will, a million users
with one gigabyte of data each. Just the original, minimal data footprint is now
around and about one petabyte.

Performing a filesystem check (:command:`fsck.ext4` comes to mind) on a single
one petabyte volume will be prohibitively expensive simply considering the
duration of the command to complete execution, let alone successful execution,
for your **million** users will not have access to their data while the command
has not finished -- again, let alone it finished successfully.

**Solely therefore** would you require a second copy of the groupware payload,
now establishing a minimal data footprint to **two** petabyte.

.. NOTE::

    Also note that the two replicas of one petabyte would, if the replication
    occurs at the storage volume level, run the risk of corrupting both replicas
    filesystems.

Your requirements for data redundancy aside, filesystem checks needing to be
performed at least regularly, if not for the level of likelihood they need to
happen because actual recovery is required, should be restricted to a volume of
data that enables the check to complete in a timely fashion, and possibly (when
no data redundancy is implemented) even within a timeframe you feel comfortable
you can hold off your users/customers while they have no access to their data.

.. Using Bricks to Build a Larger Volume
.. -------------------------------------
..
.. 500 bricks of 4 TB each would build a two petabyte storage volume with enough
.. space for redundant storage, where individual bricks can be taken offline, its
.. filesystem can be checked, and the brick can be brought back online, without
.. interrupting data availability.

Redundancy
==========

Storage Volume Level Replication
--------------------------------

.. WARNING::

    For the reasons outlined in this section, storage volume level replication
    has only a limited number of Kolab Groupware deployment scenarios for which
    it would be recommended.

A typical aspect of replication at the storage volume level is that only one of
the (two or more) copies for the storage volume can be written to
simultaneously.

.. graphviz::

    digraph {
            label="One Way Replication on the Storage Volume Level";

            "Storage Client #1" -> "Storage Volume #1" [dir=both,color=green];
            "Storage Client #1" -> "Storage Volume #2" [color=red];

            subgraph {
                rank=same;
                "Storage Volume #1" [color=green];
                "Storage Volume #2" [color=red];

            }

            "Storage Volume #1" -> "Storage Volume #2";

        }

.. WARNING::

    Storage volume level replication does not protect against filesystem
    corruption.

Only storage volume #1 is available for both read as well as write operations.
Deploying this like so means to allocate twice the volume without gaining any
performance, and may therefore be a costly option.

.. NOTE::

    Note that even just mounting storage volume copy #2 can corrupt the replica,
    if the storage volume provider itself is not aware of the mandatory
    read-only copy restrictions to enforce.

Depending on whether the storage appliance allows multi-master storage volume
level replication in a way that makes the copies of the volume accessible, in
parallel, by multiple clients, on either side of the replication, and depending
on the storage volume level replication strategy used (it must be immediate),
you may be able to configure two-way replication, or multi-master replication.
In this scenario, two or more nodes could access the storage volume in parallel,
but only using a cluster filesystem.

.. graphviz::

    digraph {
            nodesep=1

            subgraph {
                    rank=same;
                    "Storage Client #1";
                    "Storage Client #2";
                }

            subgraph {
                    rank=same;
                    "Storage Volume #1" [color=green];
                    "Storage Volume #2" [color=green];
                }

            "Storage Client #1" -> "Storage Volume #1", "Storage Volume #2" [dir=both,color=green];
            "Storage Client #2" -> "Storage Volume #1", "Storage Volume #2" [dir=both,color=green];
            "Storage Volume #1" -> "Storage Volume #2" [dir=both];
        }

This, however, means the storage **clients** need to negotiate amongst
themselves, who's turn it is to write to what (i.e. locking), similar to NFS
where the clients negotiate with the server.

Alternatively, a second file-sharing protocol (with its own locking
negotiation mechanism) could be used for multiple nodes to be able to write to
storage volume level replicated dual-head clustered filesystems. Just the level
of complexity of this terminology should put you off.

While perfectly suitable for large clusters with relatively small filesystems
(see `"Filesystems: Smaller is Better" <https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Global_File_System_2/ch-considerations.html#s2-fssize-gfs2>`_) and feasible if not too many parallel
write operations are likely to occur (think, for example, of web application
servers and (asset-)caching proxies), and not too many parallel write operations
occur to the same set of files, this doesn't scale to the volume of files
typically associated with large volumes of messages in IMAP spools to which many
nodes write in parallel.

Integrated Storage Protocol Level Replication
---------------------------------------------

Integrated storage protocol level replication isn't necessarily limited to
replication only, as it may already include parallel access controls,
distribution across multiple storage nodes (each providing a part of the total
storage volume available), enabling the use of cheap commodity hardware to
provide the individual parts (called "bricks").

Additional features may include the use of a geographically oriented set of
parameters for the calculation and assignment of replicated chunks of data.

.. graphviz::

    digraph {

            "Storage Client" -> "Storage Access Point" [dir=none,color=green];

            subgraph cluster_storage {
                    color=green;

                    "Storage Access Point" [shape=point,color=green];

                    "Brick #1" [color=green];
                    "Brick #2" [color=green];
                    "Brick #3" [color=green];

                    "Storage Access Point" -> "Brick #1", "Brick #2", "Brick #3" [color=green];
                }
        }

Application Level Replication
-----------------------------

.. rubric:: Master-Slave Replication

.. graphviz::

    digraph {
            subgraph {
                    rank=same;
                    "Storage Client #1" [color=green];
                    "Storage Client #2" [color=blue];
                    "Storage Client #1" -> "Storage Client #2";
                }

            subgraph {
                    rank=same;
                    "Storage Volume #1" [color=green];
                    "Storage Volume #2" [color=green];
                }

            "Storage Client #1" -> "Storage Volume #1" [dir=both];
            "Storage Client #2" -> "Storage Volume #2" [dir=both];
        }

.. rubric:: Master-Master Replication

.. graphviz::

    digraph {
            subgraph {
                    rank=same;
                    "Storage Client #1" [color=green];
                    "Storage Client #2" [color=green];
                    "Storage Client #1" -> "Storage Client #2" [dir=both];
                }

            subgraph {
                    rank=same;
                    "Storage Volume #1" [color=green];
                    "Storage Volume #2" [color=green];
                }

            "Storage Client #1" -> "Storage Volume #1" [dir=both];
            "Storage Client #2" -> "Storage Volume #2" [dir=both];
        }

.. rubric:: Master-Master Application Level Replication Using Integrated Storage Protocol Level Replication

.. graphviz::

    digraph {
            nodesep=1
            subgraph {
                    rank=same;
                    "Storage Client #1" [color=green];
                    "Storage Client #2" [color=green];
                    "Storage Client #1" -> "Storage Client #2" [dir=both];
                }

            "Storage Client #1" -> "Storage Access Point" [dir=none,color=green];
            "Storage Client #2" -> "Storage Access Point" [dir=none,color=green];

            subgraph cluster_storage {
                    color=green;

                    "Storage Access Point" [shape=point,color=green];

                    "Brick #1" [color=green];
                    "Brick #2" [color=green];
                    "Brick #3" [color=green];

                    "Storage Access Point" -> "Brick #1", "Brick #2", "Brick #3" [color=green];
                }

        }

