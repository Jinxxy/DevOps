# Linux命令
### cut 命令
    // 打印/etc/passwd文件中以:为分隔符的第1个字段和第6个字段分别表示用户名和其家目录
    $ cut /etc/passwd -d ':' -f 1,6
    
>   打印/etc/passwd文件中每一行的前N个字符：

    # 前五个（包含第五个）
    $ cut /etc/passwd -c -5
    # 前五个之后的（包含第五个）
    $ cut /etc/passwd -c 5-
    # 第五个
    $ cut /etc/passwd -c 5
    # 2到5之间的（包含第五个）
    $ cut /etc/passwd -c 2-5
### grep命令
    // grep命令的一般形式为
    grep [命令选项]... 用于匹配的表达式 [文件]...
    $ grep -rnI "shiyanlou" ~
> -r 参数表示递归搜索子目录中的文件,-n表示打印匹配项行号，-I表示忽略二进制文件。这个操作实际没有多大意义，但可以感受到grep命令的强大与实用。

    # 查看环境变量中以"yanlou"结尾的字符串
    $ export | grep ".*yanlou$"
### WC命令
wc 命令用于统计并输出一个文件中行、单词和字节的数目，比如输出/etc/passwd文件的统计信息：

    $ wc /etc/passwd
分别只输出行数、单词数、字节数、字符数和输入文本中最长一行的字节数：

    # 行数
    $ wc -l /etc/passwd
    # 单词数
    $ wc -w /etc/passwd
    # 字节数
    $ wc -c /etc/passwd
    # 字符数
    $ wc -m /etc/passwd
    # 最长行字节数
    $ wc -L /etc/passwd
结合管道来操作一下，下面统计/etc下面所有目录数
    $ ls -dl /etc/*/ | wc -l
### sort 排序命令
默认排序

    $ cat /etc/passwd | sort
反转排序

    $ cat /etc/passwd | sort -r
特定字段排序

    $ cat /etc/passwd | sort -t':' -k 3
> 上面的-t参数用于指定字段的分隔符，这里是以":"作为分隔符；-k 字段号用于指定对哪一个字段进行排序。这里/etc/passwd文件的第三个字段为数字，默认情况下是以字典序排序的，如果要按照数字排序就要加上-n参数：$ cat /etc/passwd | sort -t':' -k 3 -n
### uniq 去重命令
