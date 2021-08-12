# RabbitMQ入门
## 安装RabbitMQ
> ubuntu 源中已经有rabbitmq-server了。如果要安装最新版本，则去官网获取。https://www.rabbitmq.com/download.html

```shell
# 更新软件包列表
$ sudo apt-get update
# 安装 RabbitMQ Server
$ sudo apt-get install -y rabbitmq-server
```
## 管理
### 服务器相关命令
- 启动

`sudo service rabbitmq-server start`
- 关闭

`sudo service rabbitmq-server stop`
- 查看状态

`sudo service rabbitmq-server status`
### 调整系统限制
> 如果要调整系统限制（尤其是打开文件的句柄的数量）的话，可以通过编辑配置文件让服务启动的时候调用 ulimit。

```shell
$ vim /etc/default/rabbitmq-Server
ulimit -n 1024
```
### 日志
> 服务器的输出被发送到 RABBITMQ_LOG_BASE 目录的 RABBITMQ_NODENAME.log 文件中。一些额外的信息会被写入到 RABBITMQ_NODENAME-sasl.log 文件中。

```shell
# 配置logrotate
$ vim /etc/logrotate.d/rabbitmq-server
# 查看日志内容（servername 是指你的主机名）
less /var/log/rabbitmq/rabbit@servername.log
```

# HelloWorld
## 安装RabbitMQ库
### 安装pika
```shell
# 更新软件包列表
sudo apt-get update
# 安装所需要的依赖
sudo apt-get install -y python-pip git-core
# 更新 pip
sudo pip install --upgrade pip
# 安装 pika
sudo pip3 install pika
```
## 发送消息
> 写一个send.py用来发送一个消息到队列

### 代码逻辑
#### 创建连接
建立一个到RabbitMQ服务器的连接
```shell
#!/usr/bin/env python3
import pika

connection = pika.BlockingConnection(
              pika.ConnectionParameters('localhost'))
channel = connection.channel()
```
#### 创建队列
- 现在我们已经连接上服务器了，那么，在发送消息之前我们需要确认队列是存在的。如果我们把消息发送到一个不存在的队列，RabbitMQ 会丢弃这条消息。我们先创建一个名为 hello 的队列，然后把消息发送到这个队列中。

`channel.queue_declare(queue='hello')`
-  在 RabbitMQ 中，消息是不能直接发送到队列，它需要发送到交换机（exchange）中，它使用一个空字符串来标识。交换机允许我们指定某条消息需要投递到哪个队列。 routing_key 参数必须指定为队列的名称：

```shell
channel.basic_publish(exchange='',
                      routing_key='hello',
                      body='Hello World!')
print(" [x] Sent 'Hello World!'")
```
#### 关闭连接
-  在退出程序之前，我们需要确认网络缓冲已经被刷写、消息已经投递到 RabbitMQ，然后就关闭连接。

`connection.close()`

### 完整文件
```shell
#!/usr/bin/env python3
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(
        host='localhost'))
channel = connection.channel()

channel.queue_declare(queue='hello')

channel.basic_publish(exchange='',
                      routing_key='hello',
                      body='Hello World!')
print(" [x] Sent 'Hello World!'")
connection.close()
```
## 获取数据
> 编写receive.py，将会从队列中获取消息并打印消息。

### 代码逻辑
#### 创建连接
- 连接到RabbitMQ服务器
```shell
#!/usr/bin/env python3
import pika

connection = pika.BlockingConnection(
              pika.ConnectionParameters('localhost'))
channel = connection.channel()
```
- 需要确认队列是存在的。使用 queue_declare 创建一个队列——我们可以运行这个命令很多次，但是只有一个队列会被创建。
`channel.queue_declare(queue='hello')`
>> 为什么要重复声明队列呢 —— 我们已经在前面的代码中声明过它了。如果我们确定了队列是已经存在的，那么我们可以不这么做，比如此前预先运行了 send.py 程序。可是我们并不确定哪个程序会首先运行。这种情况下，在程序中重复将队列重复声明一下是种值得推荐的做法.

#### 列出所有的队列
- 列出所有的队列，使用rabbitmqctl工具。
```shell
# 先确保服务已经开启
sudo service rabbitmq-server start

python3 send.py

sudo rabbitmqctl list_queues
```
### 创建回调函数
- 从队列中获取消息相对来说稍显复杂。需要为队列定义一个回调（callback）函数。当我们获取到消息的时候，Pika 库就会调用此回调函数。这个回调函数会将接收到的消息内容输出到屏幕上。
```shell
def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)
```
- 下一步，我们需要告诉 RabbitMQ 这个回调函数将会从名为 "hello" 的队列中接收消息：
```shell
channel.basic_consume(queue='hello',
                      auto_ack=True,
                      on_message_callback=callback)
```
- 要成功运行这些命令，我们必须保证队列是存在的，我们的确可以确保它的存在——因为我们之前已经使用 queue_declare 将其声明过了。auto_ack 参数下节会进行介绍。
- 最后，我们输入一个用来等待消息数据并且在需要的时候运行回调函数的无限循环。
```shell
print(' [*] Waiting for messages. To exit press CTRL+C')
channel.start_consuming()
```
### 完整代码
```shell
#!/usr/bin/env python3
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(
        host='localhost'))
channel = connection.channel()

channel.queue_declare(queue='hello')

def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)

channel.basic_consume(queue='hello',
                      auto_ack=True,
                      on_message_callback=callback)

print(' [*] Waiting for messages. To exit press CTRL+C')

channel.start_consuming()
```
### 执行
```shell
# 确认启动服务
$ sudo service rabbitmq-server start
# 使用send.py发送一条消息
python3 send.py
# 使用receive.py接收消息
python3 receive.py
```
