##### 安装mongod服务

> 服务器信息：mongodb1(192.168.13.155),mongodb2(192.168.13.158),mongodb3(192.168.13.159)


## 添加源文件
`vim /etc/yum.repos.d/mongodb-org-5.0.repo`

```shell
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
```

## 安装服务

`sudo yum install -y mongodb-org`


# 配置服务

## 创建文件夹

```shell
mkdir -p /data/mongodb/shard1/logs \ &
mkdir -p /data/mongodb/shard1/data/db

mkdir -p /data/mongodb/shard2/logs \ &
mkdir -p /data/mongodb/shard2/data/db

mkdir -p /data/mongodb/config/logs \ &
mkdir -p /data/mongodb/config/data/db

mkdir -p /data/mongodb/mongos/logs
```

## 配置副本集
### 副本集1
#### 副本集1配置文件
##### mongodb1服务器
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
   bindIp: 192.168.13.155
   port: 27017
replication:
   replSetName: myshard1
sharding:
   clusterRole: shardsvr
```

##### mongodb2服务器
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
   bindIp: 192.168.13.158
   port: 27017
replication:
   replSetName: myshard1
sharding:
   clusterRole: shardsvr
```

##### mongodb3服务器
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
   bindIp: 192.168.13.159
   port: 27017
replication:
   replSetName: myshard1
sharding:
   clusterRole: shardsvr
```

#### 启动副本集1
`mongod -f /data/mongodb/shard1/mongo.conf`


### 副本集2
#### 副本集2配置文件
##### mongodb1服务器
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
   bindIp: 192.168.13.155
   port: 27018
replication:
   replSetName: myshard2
sharding:
   clusterRole: shardsvr
```

##### mongodb2服务器
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
   bindIp: 192.168.13.158
   port: 27018
replication:
   replSetName: myshard2
sharding:
   clusterRole: shardsvr
```

##### mongodb3服务器
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
   bindIp: 192.168.13.159
   port: 27018
replication:
   replSetName: myshard2
sharding:
   clusterRole: shardsvr
```

#### 启动副本集2
`./mongod -f /data/mongodb/shard2/mongo.conf`

### config集
#### config集配置文件
##### mongodb1服务器
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
   bindIp: 192.168.13.155
   port: 27019
replication:
   replSetName: configrs
sharding:
   clusterRole: configsvr
```

##### mongodb2服务器
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
   bindIp: 192.168.13.158
   port: 27019
replication:
   replSetName: configrs
sharding:
   clusterRole: configsvr
```

##### mongodb3服务器
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
   bindIp: 192.168.13.159
   port: 27019
replication:
   replSetName: configrs
sharding:
   clusterRole: configsvr
```

#### 启动config集
`./mongod -f /data/mongodb/config/mongo.conf`

## 初始化副本集
### 初始化shard1
#### 连接任意一个节点
`mongo --host=192.168.13.155 --port=27017`

#### 执行初始化副本集命令

`> rs.initiate()`

```shell
> rs.initiate()
{
	"info2" : "no configuration specified. Using a default configuration for the set",
	"me" : "192.168.13.155:27017",
	"ok" : 1
}
shard1:OTHER>
shard1:PRIMARY>
```

#### 添加副本节点
`> rs.add("192.168.13.158:27017")`

```shell
shard1:PRIMARY> rs.add("192.168.13.158:27017")
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629721836, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629721836, 1)
}
```

#### 添加仲裁节点
`> rs.addArb("192.168.13.159:27017")`

```shell
shard1:PRIMARY> rs.addArb("192.168.13.159:27017")
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629769614, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629769614, 1)
}
```

### 初始化shard2
#### 连接任意一个节点
`mongo --host=192.168.13.155 --port=27018`

#### 执行初始化副本集命令

`> rs.initiate()`

```shell
> rs.initiate()
{
	"info2" : "no configuration specified. Using a default configuration for the set",
	"me" : "192.168.13.155:27018",
	"ok" : 1
}
shard2:OTHER>
shard2:PRIMARY>
```

#### 添加副本节点
`> rs.add("192.168.13.158:27018")`

```shell
shard2:PRIMARY> rs.add("192.168.13.158:27018")
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629804777, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629804777, 1)
}
```

#### 添加仲裁节点
`> rs.addArb("192.168.13.159:27018")`

```shell
shard2:PRIMARY> rs.addArb("192.168.13.159:27018")
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629804804, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629804804, 1)
}
```

### 初始化configrs
#### 连接任意一个节点
`mongo --host=192.168.13.155 --port=27019`

#### 执行初始化副本集命令

`> rs.initiate()`

```shell
> rs.initiate()
{
	"info2" : "no configuration specified. Using a default configuration for the set",
	"me" : "192.168.13.155:27019",
	"ok" : 1,
	"$gleStats" : {
		"lastOpTime" : Timestamp(1629805085, 1),
		"electionId" : ObjectId("000000000000000000000000")
	},
	"lastCommittedOpTime" : Timestamp(0, 0)
}
configrs:SECONDARY>
configrs:PRIMARY>
```

#### 添加副本节点
`> rs.add("192.168.13.158:27019")`
`> rs.add("192.168.13.159:27019")`

```shell
configrs:PRIMARY> rs.add("192.168.13.158:27019")
{
	"ok" : 1,
	"$gleStats" : {
		"lastOpTime" : {
			"ts" : Timestamp(1629805191, 1),
			"t" : NumberLong(1)
		},
		"electionId" : ObjectId("7fffffff0000000000000001")
	},
	"lastCommittedOpTime" : Timestamp(1629805191, 1),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629805191, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629805191, 1)
}

configrs:PRIMARY> rs.add("192.168.13.159:27019")
{
	"ok" : 1,
	"$gleStats" : {
		"lastOpTime" : {
			"ts" : Timestamp(1629805211, 1),
			"t" : NumberLong(1)
		},
		"electionId" : ObjectId("7fffffff0000000000000001")
	},
	"lastCommittedOpTime" : Timestamp(1629805212, 1),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629805212, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629805211, 1)
}
```

## 配置mongos

```shell
systemLog:
   destination: file
   path: "/data/mongodb/mongos/logs/mongos.log"
   logAppend: true
processManagement:
   fork: true
   pidFilePath: "/data/mongodb/mongos/logs/mongos.pid"
net:
   bindIp: 192.168.13.155
   port: 27020
sharding:
   # 指定配置节点副本集
   configDB: configrs/192.168.13.155:27019,192.168.13.158:27019,192.168.13.159:27019
```

启动mongos
`./mongos -f /data/mongodb/mongos/mongos.conf`


登录mongos

```shell
./mongo --host=192.168.13.155 --port=27020
```
此时写不进去数据，写数据会报错

```shell
mongos> show dbs
admin   0.000GB
config  0.000GB
mongos> use aadb
switched to db aadb
mongos> db.aa.insert({aa:"aa"})
WriteCommandError({
	"ok" : 0,
	"errmsg" : "Database aadb could not be created :: caused by :: No shards found",
	"code" : 70,
	"codeName" : "ShardNotFound",
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629807301, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629807301, 1)
})
```

使用命令添加分片
添加分片
`sh.addShard("IP:Port")`

```shell
# 第一套副本集加入mongos
mognos> sh.addShard("shard1/192.168.13.155:27017,192.168.13.158:27017,192.168.13.159:27017")
{
	"shardAdded" : "shard1",
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629807751, 4),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629807751, 4)
}
# 第二套副本集加入mognos
mognos> sh.addShard("shard2/192.168.13.155:27018,192.168.13.158:27018,192.168.13.159:27018")
{
	"shardAdded" : "shard2",
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629807807, 4),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629807807, 4)
}
# 查看分片状态
mongos> sh.status()
--- Sharding Status ---
  sharding version: {
  	"_id" : 1,
  	"minCompatibleVersion" : 5,
  	"currentVersion" : 6,
  	"clusterId" : ObjectId("6124da1f81312b4d509db3f2")
  }
  shards:
        {  "_id" : "shard1",  "host" : "shard1/192.168.13.155:27017,192.168.13.158:27017",  "state" : 1,  "topologyTime" : Timestamp(1629807751, 1) }
        {  "_id" : "shard2",  "host" : "shard2/192.168.13.155:27018,192.168.13.158:27018",  "state" : 1,  "topologyTime" : Timestamp(1629807807, 2) }
  active mongoses:
        "5.0.2" : 3
  autosplit:
        Currently enabled: yes
  balancer:
        Currently enabled: yes
        Currently running: no
        Failed balancer rounds in last 5 attempts: 0
        Migration results for the last 24 hours:
                No recent migrations
  databases:
        {  "_id" : "config",  "primary" : "config",  "partitioned" : true }
```
如果分片失败，需要先手动移除分片，检查添加分片的信息的正确性后，再次添加分片
移除分片参考
```shell
use admin
db.runCommand({removeShard:"myshardrs02"})
```
注意:如果只剩下最后一个shard，是无法删除的
移除时会自动转移分片数据,需要一个时间过程。
完成后，再次执行删除分片命令才能真正删除。

开启分片功能: sh.enableSharding("库名")、sh.shardCollection("库名.集合名".{"key":1})
在mongos上的articledb数据库配置sharding:
```shell
mongos> sh.enableSharding("articledb")
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629808969, 2),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629808968, 1)
}

```
集合分片




增加mongos节点
## 配置mongos

```shell
systemLog:
   destination: file
   path: "/data/mongodb/mongos/logs/mongos.log"
   logAppend: true
processManagement:
   fork: true
   pidFilePath: "/data/mongodb/mongos/logs/mongos.pid"
net:
   bindIp: 192.168.13.158
   port: 27020
sharding:
   # 指定配置节点副本集
   configDB: configrs/192.168.13.155:27019,192.168.13.158:27019,192.168.13.159:27019
```

启动mongos
`./mongos -f /data/mongodb/mongos/mongos.conf`


# 安全认证



## 集群授权

### 启动mongod服务
#### 配置mongodb1服务器
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
   bindIp: localhost,192.168.13.155
   port: 27017
replication:
   replSetName: myshard1
sharding:
   clusterRole: shardsvr
```

#### 配置mongodb2服务器
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
   bindIp: localhost,192.168.13.158
   port: 27017
replication:
   replSetName: myshard1
sharding:
   clusterRole: shardsvr
```

#### 启动mongod服务
`/opt/mongodb/bin/mongod -f /data/mongodb/shard1/mongod.conf`

### 授权服务

#### 登录mongo服务
`/opt/mongodb/bin/mongo --host=192.168.13.155 --port=27017`

#### 执行初始化副本集命令

`> rs.initiate()`

```shell
> rs.initiate()
{
	"info2" : "no configuration specified. Using a default configuration for the set",
	"me" : "192.168.13.155:27017",
	"ok" : 1
}
shard1:OTHER>
shard1:PRIMARY>
```

#### 添加副本节点
`> rs.add("192.168.13.158:27017")`

```shell
shard1:PRIMARY> rs.add("192.168.13.158:27017")
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629721836, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629721836, 1)
}
```

#### 创建keyfile
```shell
openssl rand -base64 756 > mongo.keyfile
chmod 400 mongo.keyfile
```

#### 创建超级管理员
```shell
# 切换到admin库
> use admin
# 创建系统超级用户myroot,设置密码123456，设置角色root
# > db.createUser({user:"myroot",pwd:"123456",roles:[{ "role" : "root", "db" :"admin" }]})
# 或
> db.createUser({user:"myroot",pwd:"123456",roles:["root"]})
Successfully added user: { "user" : "myroot", "roles" : [ "root" ] }

#创建专门用来管理admin库的账号myadmin，只用来作为用户权限的管理
> db.createUser({user:"myadmin",pwd:"123456",roles:[{role:"userAdminAnyDatabase",db:"admin"}]})
Successfully added user: {
	"user" : "myadmin",
	"roles" : [
		{
			"role" : "userAdminAnyDatabase",
			"db" : "admin"
		}
	]
}

# 查看已经创建了的用户的情况：
> db.system.users.find()

# 删除用户
> db.dropUser("myadmin")
true
> db.system.users.find()
# 修改密码
> db.changeUserPassword("myroot", "123456")
```

#### 创建普通用户

```shell
# 创建(切换)将来要操作的数据库articledb,
> use articledb
switched to db articledb

# 创建用户，拥有articledb数据库的读写权限readWrite，密码是123456
> db.createUser({user: "bobo", pwd: "123456", roles: [{ role: "readWrite", db:"articledb" }]})
# > db.createUser({user: "bobo", pwd: "123456", roles: ["readWrite"]})
Successfully added user: {
"user" : "bobo",
"roles" : [
{
"role" : "readWrite",
"db" : "articledb"
}
]
}

# 测试是否可用
> db.auth("bobo","123456")
1
```

#### 修改配置文件开启认证权限
```shell
security:
  # KeyFile鉴权文件
  keyFile: "/data/mongodb/shard1/mongo.keyfile"
  # 开启认证方式运行
  authorization: enabled
```

#### 关闭服务
```shell
# 关闭服务
kill -2 进程ID
# 如果报错
# 删除.lock文件
rm -f /data/mongodb/shard1/data/db/*.lock
# 修复数据
/opt/mongodb/bin/mongod --repair --dbpath=/data/mongodb/shard1/data/db
# 重启服务
/opt/mongodb/bin/mongod -f /data/mongodb/shard1/mongod.conf
```
#### 开启认证权限

```shell
# 开启认证权限启动服务
/opt/mongodb/bin/mongod -f /data/mongodb/shard1/mongod.conf --auth
```



```shell

```

```shell

```


```shell

```



```shell

```



```shell

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

启动mongos集
`mongod -f /data/mongodb/config/mongo.conf`
