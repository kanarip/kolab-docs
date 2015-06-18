HOWTO: Deploy High-Available and Load-Balanced LDAP
===================================================

Configure replication
---------------------

**In Kolab1**

Activate changelog::

    dn: cn=changelog5,cn=config
    changetype: add 
    objectclass: top 
    objectclass: extensibleObject
    cn: changelog5
    nsslapd-changelogdir: /var/lib/dirsrv/slapd-kolab1/changelogdb

Add replication manager user::

    dn: cn=replication manager,cn=config
    changetype: add 
    objectClass: inetorgperson
    objectClass: person
    objectClass: top 
    objectClass: organizationalPerson
    cn: replication manager
    sn: RM
    userPassword: PASSWORD
    passwordExpirationTime: 20380119031407Z

**Configure replication for o=netscaperoot suffix**

Create the supplier replica::

    dn: cn=replica,cn="o=netscaperoot",cn=mapping tree,cn=config
    changetype: add 
    objectclass: top 
    objectclass: nsds5replica
    objectclass: extensibleObject
    cn: replica
    nsds5replicaroot: o=netscaperoot
    nsds5replicaid: 1
    nsds5replicatype: 3
    nsds5flags: 1
    nsds5ReplicaPurgeDelay: 604800
    nsds5ReplicaBindDN: cn=replication manager,cn=config

Add Replication Agreements::

    dn: cn=Multimaster replication,cn=replica,cn="o=netscaperoot",cn=mapping tree,cn=config
    changetype: add 
    objectClass: top 
    objectClass: nsDS5ReplicationAgreement
    cn: Multimaster replication
    description: replication for netscaperoot
    nsDS5ReplicaBindDN: cn=replication manager,cn=config
    nsDS5ReplicaBindMethod: SIMPLE
    nsds5replicaChangesSentSinceStartup:
    nsDS5ReplicaCredentials: PASSWORD
    nsDS5ReplicaHost: kolab2.example.org
    nsDS5ReplicaPort: 389 
    nsDS5ReplicaRoot: o=netscaperoot
    nsDS5ReplicaTransportInfo: LDAP
    nsDS5BeginReplicaRefresh: start

**Configure replication for dc=example,dc=org suffix**

Create the supplier replica::

    dn: cn=replica,cn="dc=example,dc=org",cn=mapping tree,cn=config
    changetype: add 
    objectclass: top 
    objectclass: nsds5replica
    objectclass: extensibleObject
    cn: replica
    nsds5replicaroot: dc=example,dc=org
    nsds5replicaid: 1
    nsds5replicatype: 3
    nsds5flags: 1
    nsds5ReplicaPurgeDelay: 604800
    nsds5ReplicaBindDN: cn=replication manager,cn=config

Add Replication Agreements::

    dn: cn=Multimaster replication,cn=replica,cn="dc=example,dc=org",cn=mapping tree,cn=config
    changetype: add 
    objectClass: top 
    objectClass: nsDS5ReplicationAgreement
    cn: Multimaster replication
    description: replication for netscaperoot
    nsDS5ReplicaBindDN: cn=replication manager,cn=config
    nsDS5ReplicaBindMethod: SIMPLE
    nsds5replicaChangesSentSinceStartup:
    nsDS5ReplicaCredentials: PASSWORD
    nsDS5ReplicaHost: kolab2.example.org
    nsDS5ReplicaPort: 389 
    nsDS5ReplicaRoot: dc=example,dc=org
    nsDS5ReplicaTransportInfo: LDAP
    nsDS5BeginReplicaRefresh: start

**In Kolab2**

Activate changelog::

    dn: cn=changelog5,cn=config
    changetype: add
    objectclass: top
    objectclass: extensibleObject
    cn: changelog5
    nsslapd-changelogdir: /var/lib/dirsrv/slapd-kolab2/changelogdb

Add replication manager user::

    dn: cn=replication manager,cn=config
    changetype: add
    objectClass: inetorgperson
    objectClass: person
    objectClass: top
    objectClass: organizationalPerson
    cn: replication manager
    sn: RM
    userPassword: PASSWORD
    passwordExpirationTime: 20380119031407Z

**Configure replication for o=netscaperoot suffix**

Create the supplier replica::

    dn: cn=replica,cn="o=netscaperoot",cn=mapping tree,cn=config
    changetype: add
    objectclass: top
    objectclass: nsds5replica
    objectclass: extensibleObject
    cn: replica
    nsds5replicaroot: o=netscaperoot
    nsds5replicaid: 2
    nsds5replicatype: 3
    nsds5flags: 1
    nsds5ReplicaPurgeDelay: 604800
    nsds5ReplicaBindDN: cn=replication manager,cn=config

Add Replication Agreements::

    dn: cn=Multimaster replication,cn=replica, cn="o=netscaperoot", cn=mapping tree, cn=config
    changetype: add
    objectClass: top
    objectClass: nsDS5ReplicationAgreement
    cn: Multimaster replication
    description: replication for netscaperoot
    nsDS5ReplicaBindDN: cn=replication manager,cn=config
    nsDS5ReplicaBindMethod: SIMPLE
    nsds5replicaChangesSentSinceStartup:
    nsDS5ReplicaCredentials: PASSWORD
    nsDS5ReplicaHost: kolab1.example.org
    nsDS5ReplicaPort: 389
    nsDS5ReplicaRoot: o=netscaperoot
    nsDS5ReplicaTransportInfo: LDAP
    nsds5BeginReplicaRefresh: startConfigure replication for dc=example,dc=org suffix 

**Configure replication for dc=example,dc=org suffix**

Create the supplier replica::

    dn: cn=replica,cn="dc=example,dc=org",cn=mapping tree,cn=config
    changetype: add
    objectclass: top
    objectclass: nsds5replica
    objectclass: extensibleObject
    cn: replica
    nsds5replicaroot: dc=example,dc=org
    nsds5replicaid: 2
    nsds5replicatype: 3
    nsds5flags: 1
    nsds5ReplicaPurgeDelay: 604800
    nsds5ReplicaBindDN: cn=replication manager,cn=config

Add Replication Agreements::

    dn: cn=Multimaster replication,cn=replica, cn="dc=example,dc=org", cn=mapping tree, cn=config
    changetype: add
    objectClass: top
    objectClass: nsDS5ReplicationAgreement
    cn: Multimaster replication
    description: replication for netscaperoot
    nsDS5ReplicaBindDN: cn=replication manager,cn=config
    nsDS5ReplicaBindMethod: SIMPLE
    nsds5replicaChangesSentSinceStartup:
    nsDS5ReplicaCredentials: PASSWORD
    nsDS5ReplicaHost: kolab1.example.org
    nsDS5ReplicaPort: 389
    nsDS5ReplicaRoot: dc=example,dc=org
    nsDS5ReplicaTransportInfo: LDAP
    nsds5BeginReplicaRefresh: start
