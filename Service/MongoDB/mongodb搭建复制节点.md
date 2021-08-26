# 副本集

副本集有两种类型三种角色两种类型:
- 主节点(Primary)类型:数据操作的主要连接点，可读写。
- 次要（辅助、从）节点(Secondaries）类型:数据冗余备份节点，可以读或选举。

三种角色:
主要成员（Primary) :主要接收所有写操作。就是主节点。
副本成员〈Replicate)∶从主节点通过复制操作以维护相同的数据集，即备份数据，不可写操作，但可以读操作(但需要配置)。是默认的一种从节点类型。
仲裁者(Arbiter):不保留任何数据的副本，只具有撬票选举作用。当然也可以将仲裁服务器维护为副本集的一部分，即副本成员同时也可以是仲裁者。也是一种从节点类型。

环境信息
centos8
192.168.57.201,192.168.57.202,192.168.57.203

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
```

## 配置节点

#### 节点1配置文件
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
   replSetName: "shard1"
sharding:
   clusterRole: shardsvr
```
#### 节点2配置文件
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
   replSetName: "shard1"
sharding:
   clusterRole: shardsvr
```

### 启动副本集1
`/opt/mongodb/bin/mongod -f /data/mongodb/shard1/mongo.conf`

## 初始化副本集和主节点

登录mongo

```shell
/opt/mongodb/bin/mongo --host=192.168.13.155 --port=27017
```
#### 执行初始化副本集命令

`> rs.initiate()`

```shell
> rs.initiate()
{
	"info2" : "no configuration specified. Using a default configuration for the set",
	"me" : "192.168.13.155:27017",
	"ok" : 1
}
configrs:SECONDARY>
configrs:PRIMARY>
```
#### 添加副本节点
`> rs.add("192.168.13.158:27017")`
```shell
shard1:PRIMARY> rs.add("192.168.13.158:27017")
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1629871100, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1629871100, 1)
}
```


```shell
# 切换到admin库> use admin
# 创建系统超级用户myroot,设置密码123456，设置角色root
# > db.createUser([user∵: "myroot" , pwd : "123456" , roles:[ { "role" : "root" ,"db" : "admin" }]})
# 或
> db.createUser({user : "myroot" , pwd : "123456" , roles : ["root"]})
successfully added user: { "user" : "myroot"，"roles" : ["root"] }
# 创建专门用来管理admin库的账号myadmin，只用来作为用户权限的管理
> db.createUser({user:"myadmin",pwd:"123456",roles:[{role:"userAdminAnyDatabase",db:"admin"}]})
successfully added user: i
"user" : "myadmin"，"roles" : [
{
"role" : "userAdminAnyDatabase" ,"db" : "admin"
}
]
```

```shell
openssl rand -base64 756 > <path-to-keyfile>
chmod 400 <path-to-keyfile>
```

配置文件后添加
```shell
security:
  # KeyFile鉴权文件
  keyFile: "/data/mongodb/shard1/mongo.keyfile"
  # 开启认证方式运行
  authorization: enabled
replication:
  replSetName: <replicaSetName>
net:
   bindIp: localhost,<hostname(s)|ip address(es)>
```
## 关闭已开启的服务

```shell
# 通过进程ID关闭节点
kill -2 2421
# 删除.lock文件
rm -f /data/mongodb/shard1/data/db/*.lock
# 修复数据
/opt/mongodb/bin/mongod --repair --dbpath=/data/mongodb/shard1/data/db
# 重启服务
/opt/mongodb/bin/mongod -f /data/mongodb/shard1/mongod.conf
```






```shell

```

```shell

```
```shell

```
```shell

```
