> 系统：Ubuntu 16.04.7 LTS
> 任务：启动SVN服务，配置权限，用户名：test 密码：test


ubuntu默认带有svn，所以先删除svn
sudo apt-get remove --purge subversion
更新
sudo apt-get update

安装svn
sudo apt-get install subversion

创建文件夹
sudo mkdir -p /home/jin/svn/repository

修改权限
cd /home/jin/svn
sudo chmod -R 777 repository/

创建版本库
sudo svnadmin create repository/

修改db文件夹权限
cd repository
sudo chmod -R 777 db

修改配置文件
sudo vim conf/svnserve.conf
```shell
# 将以下注释删除
19 anon-access = read
20 auth-access = write

27 password-db = passwd

36 authz-db = authz
```

添加用户
sudo vim conf/passwd
```shell
[users]
test = test
```
设置用户权限
sudo vim conf/authz
```shell
[/]
test = rw
```

测试服务是否正常
cd /home/svn/repository/conf/
svnserve -d --listen-port 3690 -r /home/svn
ps aux | grep svnserve
停止服务
killall svnserve
