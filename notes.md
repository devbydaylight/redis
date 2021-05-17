# Redis notes

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



## configuring replication between 2 nodes

## redis-cli installation (client node)
Process is identical to redis-server installation. You can copy just the redis-cli binary from the src/ directory to a local location in your users $PATH variable to run locally without having to change directory into redis-stable/ directory.

## benchmark tool
