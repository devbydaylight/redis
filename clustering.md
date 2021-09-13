# redis clustering
A collection of notes on clustering in Redis.

## architecture 
```
cluster
  -> nodes
    -> databases
      -> shards
```
- **cluster** made of multiple nodes and can be spread across az's for rack awareness (multi az clusters).
- **nodes** these nodes act as the underlying infrastructure the databases will be created on.
- **databases** typically created by the user via the redis cloud portal or 


## general redis details
- redis is single threaded process.
  - redis process is bound by cpu core using it.
  - available memory also plays a large role in system resource usage with redis.
- clustering enalbes load distribution of redis processes for performance improvement.
  - adding more servers, ram, cpu cores, etc.

## cluster info
- cluster is set of redis processes where each process manages subset of keyspace (database objects).
- keyspace gets partition into shards.
  - a shard exists on a single node and is managed by that node.
  - nodes in a cluster can manage multiple shards.
  - keyspace in shards is split into hash slots (more on hash slots later).
- clients access redis cluster through single endpoint (always single endpoints??).
    - db operations are automatically sent to the proper database shards.

## when is clustering necessary?
- when dataset is larger than 25GB or 50GB (for Redis on Flash).
  - good idea to create multiple shards to distribute data across multiple nodes.
- if the database ops are cpu intensive, its a good idea to use clustering to spread out the processes across multiple servers/cpus.
- minimum number of shards per database is 2 shards.
  - cannot reduce number of shards once clustering is enabled.
  - if needed, can increase number of shards by multiple of chosen shard scheme.

## memory limits
- you can have replication enabled in redis without clustering.
- when setting memory limit on databases you are setting max memory for all database replicas and shards.
  - database replica shards for dbs with replication enabled.
  - database shards for dbs with clustering enabled.

## database replication
- in redis you can replicate dataset to replica shards.
- in the event of a failure of the primary shard, replica shard is promoted to primary.
  - the old primary will then become a replica following the election process of a new primary.
- it is also possible for primary nodes to fail and become unrecoverable.
  - can replace/restore a broken master by adding a new node and recovering snapshots(???).

## ha configuration
  - **rack/zone awareness** can be used as additional high availability mechanism that prevents nodes from sharing same rack.
    - this is good for people that want to have primary/replica nodes in different availability zones in cloud deployments.
    - rack/zone awareness has to be configured at the cluster, node, and database levels.
    - only really relevant for dbs that have replication enabled.
    - even without rack awareness enabled on replicated databases, the master and slave shards will be placed on separate nodes.

  - **ha for replica shards**.
    - replica shard gets migrated when nodes fail to keep the database up and available.
    - possible alternative option for deployment that doesn't allow for rack/zone awareness??
 
## endpoints
- master node can hold master shards within a database.
- when a master node goes down, and the replica node is promoted, do the previous endpoints need to be bound to new master?
  
