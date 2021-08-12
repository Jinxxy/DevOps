# 安装
## 安装git
```shell
$ sudo apt-get update
$ sudo apt-get install git
```
## 添加git用户
```shell
# 添加 Git 用户
$ sudo useradd git
# 设置密码,为了方便操作，密码较为简单
$ sudo passwd git
# 重复输入两次密码
```
## 设置git用户的工作目录
```shell
# 设置 git 用户的工作目录
$ sudo mkdir /home/git

#将工作目录的权限给git用户
$ sudo chown -R  git　/home/git
```
## 生成秘钥
```shell
# 生成密钥
# 默认将放在家目录的 .ssh 文件夹中
# 不修改名字的话，默认密钥对名为 id_rsa
$ ssh-keygen -t rsa
# 将公钥发送给远程端
$ cat ~/.ssh/id_rsa.pub | \
 ssh git@localhost \
 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```
## 在远程端建立仓库
```shell
# 切换用户到git,在本实验中用户权限的使用很重要，之后会讲解
$ su git
# 创建仓库文件夹，-p 是指建立上层目录。
$ mkdir -p /home/git/example/project.git
$ cd /home/git/example/project.git

# 初始化仓库
$ git init  --bare
```
## 初始化仓库
```shell
# 退出 git 这个用户
$ exit
$ mkdir -p /home/shiyanlou/example/shiyanlou_cs616
$ cd /home/shiyanlou/example/shiyanlou_cs616OperationsOperationsOperationsOperations

#初始化　git　仓库
$ git init  　
# 设置用户名
$ git config --global user.name "shiyanlou"

# 设置用户的邮件
$ git config --global user.email  shiyanlou.localhost

# 创建一个文档来测试提交的效果
$ echo "I am Shiyanlou Readme Doc" > ./readme
```
## 提交自己的代码
```shell
$ git add .
$ git commit -m "test"
$ git remote add origin git@localhost:/home/git/example/project.git
$ git push origin master
```
## 克隆代码
```shell
$ cd /home/shiyanlou
$ git clone git@localhost:/home/git/example/project.git
```
