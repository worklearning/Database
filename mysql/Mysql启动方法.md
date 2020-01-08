# Mysql启动方法

在Mysql安装成功后，如果是使用源码包编译安装的方法，则默认没有mysqld服务，不能够通过systemctl的方式启动mysql数据库，需要手动启动。

创建Mysql用户和用户组

*groupadd -g 1000 mysql*

*useradd -g mysql -G mysql -u 1000 -d /home/mysql -s /bin/bash mysql*

首先，需要对数据库进行初始化操作，需要注意的是--datadir指定了数据库的数据目录，此目录一定要存在，否则无法进行初始化

*/usr/local/mysql/5.7/bin/mysqld --user mysql --datadir=/home/db --initialize --initialize-insecure*

![Mysql初始化](https://github.com/aolitianya/work/blob/master/%E6%95%B0%E6%8D%AE%E5%BA%93/Mysql/%E6%88%AA%E5%9B%BE/Mysql%E5%88%9D%E5%A7%8B%E5%8C%96.png)


初始化操作完成后启动数据库，需要注意的是在/etc/my.cnf中指定的datadir和socket目录是存在的且有访问权限，在nohup.out中能够看到对应的mysql启动的输出

*nohup /usr/local/mysql/5.7/bin/mysqld --defaults-file=/etc/my.cnf --user mysql --datadir=/home/db &*

![Mysql启动](https://github.com/aolitianya/work/blob/master/%E6%95%B0%E6%8D%AE%E5%BA%93/Mysql/%E6%88%AA%E5%9B%BE/Mysql%E5%90%AF%E5%8A%A8.png)


执行完成后能够通过ps看到mysql进程已经启动。

第一次启动数据库需要重新设定mysql的密码，除密码设置外都选择默认即可

*/usr/local/mysql/5.7/bin/mysql_secure_installation -S /home/db/mysql.sock*

执行完成后登录mysql，输入密码后登录mysql数据库

*/usr/local/mysql/5.7/bin/mysql -uroot -S /home/db/mysql.sock -p*



