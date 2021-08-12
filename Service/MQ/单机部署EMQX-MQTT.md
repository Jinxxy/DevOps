# Centos7部署EMQ X服务

> 官方文档：https://docs.emqx.cn/broker/latest/

## 安装部署

### 安装
```shell
# 安装所需要的依赖包
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
# 使用以下命令设置稳定存储库，以 CentOS 7 为例
$ sudo yum-config-manager --add-repo https://repos.emqx.io/emqx-ce/redhat/centos/7/emqx-ce.repo
# 安装最新版本的 EMQ X Broker
$ sudo yum install emqx
```

### 安装特定版本
```shell
# 查询可用版本
$ yum list emqx --showduplicates | sort -r
emqx.x86_64                     4.0.0-1.el7                        emqx-stable
emqx.x86_64                     3.0.1-1.el7                        emqx-stable
emqx.x86_64                     3.0.0-1.el7                        emqx-stable
# 根据第二列中的版本字符串安装特定版本，例如 4.0.0
$ sudo yum install emqx-4.0.0
```

### docker部署
`docker run -d --name emqx -p 1883:1883 -p 8083:8083 -p 18083:18083 emqx/emqx`

## 启动
```shell
# 启动
$ emqx start
emqx 4.0.0 is started successfully!
# 查看状态
$ emqx_ctl status
Node 'emqx@127.0.0.1' is started
emqx v4.0.0 is running
# systemctl启动
$ sudo systemctl start emqx
# service启动
$ sudo service emqx start
```