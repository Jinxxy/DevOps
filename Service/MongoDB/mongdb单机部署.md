> 服务器信息：mongodb1(192.168.13.155),mongodb2(192.168.13.158),mongodb3(192.168.13.159)
# 安装mongodb
## 1. yum安装
### 添加源文件
`vim /etc/yum.repos.d/mongodb-org-5.0.repo`

```shell
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
```

### 安装服务

`sudo yum install -y mongodb-org`

## 2. 直接使用服务

```shell
# 下载mongodb-linux-x86_64-rhel80-5.0.2.tgz包
tar -xzvf mongodb-linux-x86_64-rhel80-5.0.2.tgz
mv mongodb-linux-x86_64-rhel80-5.0.2 mongodb
cd /opt/mongodb/bin/
```

# 配置服务

## 创建文件夹

```shell
mkdir -p /data/mongodb/shard1/logs \ &
mkdir -p /data/mongodb/shard1/data/db
```

## 配置mongodb1服务器
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
```

## 启动mongod服务
`/opt/mongodb/bin/mongod -f /data/mongodb/shard1/mongod.conf`

# 授权服务
## 登录mongo
`/opt/mongodb/bin/mongo --host=192.168.13.155 --port=27017`

## 创建超级管理员
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

## 创建普通用户

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

## 关闭服务
`kill -2 进程ID`

## 开启认证权限
### 1. 命令行开启（每次启动服务都要带上）
```shell
# 开启认证权限启动服务
/opt/mongodb/bin/mongod -f /data/mongodb/shard1/mongod.conf --auth
```
### 2. 配置文件开启
```shell
security:
  #开启授权认证
  authorization: enabled
```
## 重新启动服务
```shell
# 如果报错
# 删除.lock文件
rm -f /data/mongodb/shard1/data/db/*.lock
# 修复数据
/opt/mongodb/bin/mongod --repair --dbpath=/data/mongodb/shard1/data/db
# 重启服务
/opt/mongodb/bin/mongod -f /data/mongodb/shard1/mongod.conf
```
