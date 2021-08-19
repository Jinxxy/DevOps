# 服务器信息
操作系统：centos8
mongodb版本：mongodb-linux-aarch64-rhel82-5.0.2
虚拟机：
10.0.0.13,10.0.0.24,10.0.0.25
2个分片复制集
shard1(10.0.0.13:27017,10.0.0.24:27017,10.0.0.25:27017)
shard2(10.0.0.13:27018,10.0.0.24:27018,10.0.0.25:27018)
1个config复制集
(10.0.0.13:28018,10.0.0.24:28018,10.0.0.25:28018)
1个mongos节点

# 搭建mongodb分片复制集

## shard1集群

###  解压缩
`tar xzvf mongodb-linux-aarch64-rhel82-5.0.2.tgz`

### 添加复制集配置文件mongo.conf
```shell
systemLog:
   destination: file
   # mongd或mongos应向其发送所有诊断日志记录信息的日志文件路径
   path: "/opt/mongo/shard1/logs/mongo.log"
   # 当mongos或mongd实例重启时，mongos或mongod会将新条目附加到现有日志文件的末尾
   logAppend: true
storage:
   journal:
       # 启用或禁用持久性日志以确保数据保持有效和可恢复
      enabled: true
   # mongd实例存储其数据的目录。storage.dbPath设置仅适用于mongod
   dbPath: "/opt/mongo/shard1/data/db" #注意修改路径
processManagement:
   # 启用在后台运行mongos或mongod进程的守护进程模式
   fork: true
   # 指定用于保存mongos或mongod进程的进程ID的文件位置，其中mongos或mongod将写入其PID
   pidFilePath:/opt/mongo/shard1/logs/mongod.pid
net:
   # 服务实例绑定所有IP
   # bindIpAll:true
   # 服务实例绑定的IP
   bindIp: 0.0.0.0
   # 绑定的端口
   port: 27017
setParameter:
   enableLocalhostAuthBypass: true
replication:
   # 副本集的名称
   replSetName: "shard1"
sharding:
   # 分片角色
   clusterRole: shardsvr
security:
    #密钥文件，用于集群内部认证
    authorization: "enabled"
    keyFile: /Users/hanqf/myservice_dir/mongodb-mongos/keyFile.key
```
