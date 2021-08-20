`vim /etc/yum.repos.d/mongodb-org-5.0.repo`

```shell
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
```

`sudo yum install -y mongodb-org`


创建文件夹

```shell
mkdir -p /data/mongodb/shard1/logs \ &
mkdir -p /data/mongodb/shard1/data/db

mkdir -p /data/mongodb/shard2/logs \ &
mkdir -p /data/mongodb/shard2/data/db

mkdir -p /data/mongodb/config/logs \ &
mkdir -p /data/mongodb/config/data/db

mkdir -p /data/mongodb/mongos/logs \ &
mkdir -p /data/mongodb/mongos/data/db
```

副本集1配置
```shell
systemLog:
   destination: file
   path: "/data/mongodb/shard1/logs/mongo.log"
   logAppend: true
storage:
   journal:
      enabled: true
   dbPath: "/data/mongodb/shard1/data/db"
processManagement:
   fork: true
   pidFilePath: "/data/mongodb/shard1/logs/mongo.pid"
net:
   bindIp: 0.0.0.0
   port: 27017
replication:
   replSetName: "shard1"
sharding:
   clusterRole: shardsvr
```

副本集2配置
```shell
systemLog:
   destination: file
   path: "/data/mongodb/shard2/logs/mongo.log"
   logAppend: true
storage:
   journal:
      enabled: true
   dbPath: "/data/mongodb/shard2/data/db"
processManagement:
   fork: true
   pidFilePath: "/data/mongodb/shard2/logs/mongo.pid"
net:
   bindIp: 0.0.0.0
   port: 27018
replication:
   replSetName: "shard2"
sharding:
   clusterRole: shardsvr
```

`mongod -f /data/mongodb/shard1/mongo.conf`
`mongod -f /data/mongodb/shard2/mongo.conf`

config集配置
```shell
systemLog:
   destination: file
   path: "/data/mongodb/config/logs/mongo.log"
   logAppend: true
storage:
   journal:
      enabled: true
   dbPath: "/data/mongodb/config/data/db"
processManagement:
   fork: true
   pidFilePath: "/data/mongodb/config/logs/mongo.pid"
net:
   bindIp: 0.0.0.0
   port: 27019
replication:
   replSetName: "congifrs"
sharding:
   clusterRole: configsvr
```

mongos集配置
```shell
systemLog:
   destination: file
   path: "/data/mongodb/mongos/logs/mongo.log"
   logAppend: true
storage:
   journal:
      enabled: true
   dbPath: "/data/mongodb/mongos/data/db"
processManagement:
   fork: true
net:
   bindIp: 0.0.0.0
   port: 27020
replication:
   replSetName: "mongos"
sharding:
   clusterRole: shardsvr
```
