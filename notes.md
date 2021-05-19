# Redis notes

## what is redis?
An in-memory data structure store that supports the storing of multiple data types including:
- strings
- lists
- sets
- sorted sets
- hashes
- streams
- bit arrays
- hyperlog logs

It should also be noted that Redis is not strictly a key-value store since it supports multiple complex data types and isn't limited to just key-value strings.
## redis-server installation
For latest stable version of redis server use the following command:

```
$ wget http://download.redis.io/redis-stable.tar.gz
```
Use the following commands to install from source:
```
$ tar xvzf redis-stable.tar.gz
$ cd redis-stable
$ make
```
May need to run make distclean command on Ubuntu systems:
```
$ cd redis-stable
$ make distclean
$ make
```
I had issues doing this on Ubuntu AMIs on AWS without taking a few actions first. If you get errors like:
```
/bin/sh: 1: cc: not found
Makefile:368: recipe for target 'adlist.o' failed
make[1]: *** [adlist.o] Error 127
make[1]: Leaving directory '/home/ubuntu/redis-stable/src'
Makefile:6: recipe for target 'all' failed
make: *** [all] Error 2
```
I had to make sure to update the system with the following:
```
sudo apt update && sudo apt upgrade
```
After this, run 'make' command from the redis-stable directory and it should do the compilation.

Copy binaries from src/ for redis-server

Alternate way to install latest stable version of redis on Ubuntu through PPA:
```
$ sudo add-apt-repository ppa:redislabs/redis
$ sudo apt-get update
$ sudo apt-get install redis
```
According to redis [documentation](https://redis.io/topics/quickstart), installing from source is the recommended way to install. 

To start the redis-server just run redis-server without any arguments:
```
$ redis-server
```
Doing this without any arguments will start redis-server in the shell and you will have to CTRL+C to get out of it, which kills the redis-server process. This method is fine for testing basic functionality and I even just put the process in the background with the ampersand so I could test redis-cli functionality. You can use 'ps' or 'jobs' commands to check on the process:
```
$ redis-server &
$ ps auxf | grep redis
$ jobs -l
```
To specify a configuration file just add path to config file to your redis-server command:
```
$ redis-server /path/to/config/file
```
There is an example of a redis config file [here](https://raw.githubusercontent.com/redis/redis/6.0/redis.conf).

## configuring replication between 2 nodes
You can add the directive, replicaof <master node ip> <master port> to your redis.conf file to enable replication. Once complete you can start the redis-server on the replica node. Prior to starting redis-server on replica, do a 'tail -f /var/log/redis_6379.log' so you can observe what happens in the redis logs:

From master
```
$ tail -f /var/log/redis_6379.log
1979:M 19 May 2021 16:26:22.634 * Replica 172.31.20.229:6379 asks for synchronization
1979:M 19 May 2021 16:26:22.634 * Full resync requested by replica 172.31.20.229:6379
1979:M 19 May 2021 16:26:22.634 * Replication backlog created, my new replication IDs are '0ea26e54acff99670b58613a9680a37881efcc18' and '0000000000000000000000000000000000000000'
1979:M 19 May 2021 16:26:22.634 * Starting BGSAVE for SYNC with target: disk
1979:M 19 May 2021 16:26:22.634 * Background saving started by pid 3493
3493:C 19 May 2021 16:26:22.638 * DB saved on disk
3493:C 19 May 2021 16:26:22.638 * RDB: 0 MB of memory used by copy-on-write
1979:M 19 May 2021 16:26:22.738 * Background saving terminated with success
1979:M 19 May 2021 16:26:22.739 * Synchronization with replica 172.31.20.229:6379 succeeded
```
From replica
```
907:C 19 May 2021 16:26:22.625 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
907:C 19 May 2021 16:26:22.625 # Redis version=6.2.3, bits=64, commit=00000000, modified=0, pid=907, just started
907:C 19 May 2021 16:26:22.625 # Configuration loaded
907:S 19 May 2021 16:26:22.626 * Increased maximum number of open files to 10032 (it was originally set to 1024).
907:S 19 May 2021 16:26:22.626 * monotonic clock: POSIX clock_gettime
907:S 19 May 2021 16:26:22.628 * Running mode=standalone, port=6379.
907:S 19 May 2021 16:26:22.628 # Server initialized
907:S 19 May 2021 16:26:22.628 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
907:S 19 May 2021 16:26:22.628 * Loading RDB produced by version 6.2.3
907:S 19 May 2021 16:26:22.628 * RDB age 283 seconds
907:S 19 May 2021 16:26:22.628 * RDB memory usage when created 0.83 Mb
907:S 19 May 2021 16:26:22.628 * DB loaded from disk: 0.000 seconds
907:S 19 May 2021 16:26:22.628 * Ready to accept connections
907:S 19 May 2021 16:26:22.630 * Connecting to MASTER 172.31.28.194:6379
907:S 19 May 2021 16:26:22.630 * MASTER <-> REPLICA sync started
907:S 19 May 2021 16:26:22.630 * Non blocking connect for SYNC fired the event.
907:S 19 May 2021 16:26:22.632 * Master replied to PING, replication can continue...
907:S 19 May 2021 16:26:22.633 * Partial resynchronization not possible (no cached master)
907:S 19 May 2021 16:26:22.635 * Full resync from master: 0ea26e54acff99670b58613a9680a37881efcc18:0
907:S 19 May 2021 16:26:22.739 * MASTER <-> REPLICA sync: receiving 219 bytes from master to disk
907:S 19 May 2021 16:26:22.739 * MASTER <-> REPLICA sync: Flushing old data
907:S 19 May 2021 16:26:22.739 * MASTER <-> REPLICA sync: Loading DB in memory
907:S 19 May 2021 16:26:22.743 * Loading RDB produced by version 6.2.3
907:S 19 May 2021 16:26:22.743 * RDB age 0 seconds
907:S 19 May 2021 16:26:22.743 * RDB memory usage when created 1.83 Mb
907:S 19 May 2021 16:26:22.743 * MASTER <-> REPLICA sync: Finished with success
```

## replication theory
Redis replication has 3 critical components to the system:
1. Master keeps replica updated by sending stream of commands to it to keep track of changes made to the dataset on master (e.g. writes, key expiration/eviction).
2. In situations when replica loses connection to master a reconnection is established to continue replicating with partial resync and attempt to retrieve lost commands during connection issues.
3. If partial resync isn't possible, replica asks for full resync which involves master taking snapshot (backup??) of its data and sending to replica. Then sending commands via the stream for new changes made to dataset.

### replication process
Redis uses concept of replication ID and it is critical to understanding how replication works in redis. The replication ID acts as the representation of the dataset for a master. Every master has a replication ID. Included with that is an offset that increments based on the number of bytes of replication stream produced to send to the replicas for updates.

Together, the replication ID and offset represent an exact version of the master dataset.

There is support for both asynchronous and synchronous replication. By default asynchronous is in place and the replica periodically checks in with the master to confirm the amount of data that has been sent.
  
When replicas connect to master they use PSYNC cmd to send old replication ID/offsets that have been processed at that point in time. If the ID from the replica is not known a full sync happens which will give replica full dataset from master.
  
## redis configuration
Can call redis server using 'redis-server' command with no additional arguments to use default configuration file. The template for redis config file can be found in the redis-stable root directory (e.g. ~/redis-stable/redis.conf).
```
$ redis-server
```
You can pass configuration parameters via the cli command directly:
```
$ redis-server --port 6380 --slaveof 1.2.3.4 --port 6379
```
If you want to change a configuration paramter on the fly without having to restart redis-server you can use CONFIG SET command. Do note that this will not write any changes to redis.conf file so if you were to reboot the node it would go back to using the previous configuration defined in redis.conf.
  
If you want to have the config change be written to redis.conf file on the fly without restarting, use the CONFIG REWRITE command after you have done the CONFIG SET change:
```
$ redis-cli -h <host ip> -p <port> config set <parameter> <new value>
OK
$ redis-cli -h <host ip> -p <port> config get <parameter you just changed>
$ redis-cli -h <host ip> -p <port> config rewrite
```
You can then log into the host whose configuration you just changed and check the redis.conf file to confirm the changes were written to the file without having to do a reboot!

## redis-cli installation (client node)
Process is identical to redis-server installation. You can copy just the redis-cli binary from the src/ directory to a local location in your users $PATH variable to run locally without having to change directory into redis-stable/ directory.

## eviction policies

## data structures

## persistence

## benchmark tool
  
## logging

## helpful links
[Redis Quickstart](https://redis.io/topics/quickstart)
[Redis configuration file example for 6.0](https://raw.githubusercontent.com/redis/redis/6.0/redis.conf)
[Full list of Redis commands](https://redis.io/commands#)
[Data structures](https://redis.io/topics/data-types-intro)
[Persistence](https://redis.io/topics/persistence)
[Eviction Policies 1](https://redis.io/topics/lru-cache)
[Eviction Policies 2](https://docs.redislabs.com/latest/rs/administering/database-operations/eviction-policy/)
[Benchmarking](https://redis.io/topics/benchmarks)
