Kolab Deployment on Redundant Servers
=====================================

This deployment provides high-availability to a Kolab Groupware deployment
through redundancy.

Using DRBD
----------

.. graphviz::

    digraph drbd {
            rankdir=LR;
            subgraph cluster_master {
                rankdir=TB;
                style=filled;
                color=lightgrey;
                node [style=filled,color=white];
                "OS Disk 0" [label="OS Disk"];
                "Data Disk 0" [label="Data Disk"];
                label = "Master";
            }

            subgraph cluster_slave {
                rankdir=TB;
                node [style=filled];
                "OS Disk 1" [label="OS Disk"];
                "Data Disk 1" [label="Data Disk"];
                label = "Slave";
            }

            "Data Disk 0" -> "Data Disk 1";
        }

Using GlusterFS
---------------

.. graphviz::

    digraph glusterfs {
            compound=true;

            rankdir=TB;

            subgraph cluster_gfs0 {
                label = "GlusterFS";

                rankdir=LR;

                subgraph cluster_gfs1 {
                    label = "GlusterFS Node 1";

                    rankdir=TB;

                    "OS Disk 2" [label="OS Disk"];
                    "Data Disk 2" [label="Data Disk"];
                    "OS Disk 2" -> "Data Disk 2" [style=invis];
                }

                subgraph cluster_gfs2 {
                    label = "GlusterFS Node 2";

                    rankdir=TB;

                    "OS Disk 3" [label="OS Disk"]
                    "Data Disk 3" [label="Data Disk"];
                    "OS Disk 3" -> "Data Disk 3" [style=invis];
                    "Data Disk 3" -> "Data Disk 2" [dir=both];
                }

                { rank=same; "OS Disk 2", "OS Disk 3" }
                { rank=same; "Data Disk 2", "Data Disk 3" }
            }

            subgraph cluster_kolab0 {
                label = "Kolab";

                rankdir=LR;

                subgraph cluster_kolab1 {
                    label = "Kolab Server 1";

                    rankdir=TB;

                    "OS Disk 0" [label="OS Disk"];
                    "GFS Mount 0" [label="GFS Mount"];
                    "OS Disk 0" -> "GFS Mount 0" [style=invis];
                }

                subgraph cluster_kolab2 {
                    label = "Kolab Server 2";

                    rankdir=TB;

                    "OS Disk 1" [label="OS Disk"]
                    "GFS Mount 1" [label="GFS Mount"];
                    "OS Disk 1" -> "GFS Mount 1" [style=invis];
                }

                { rank=same; "OS Disk 0", "OS Disk 1", "OS Disk 2", "OS Disk 3" }
                { rank=same; "GFS Mount 0", "GFS Mount 1", "Data Disk 2", "Data Disk 3" }

            }

            "GFS Mount 0" -> "Data Disk 3" [lhead=cluster_gfs0];
            "GFS Mount 1" -> "Data Disk 2" [lhead=cluster_gfs0];

        }
