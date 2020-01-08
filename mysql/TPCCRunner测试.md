# TPCCRunner测试

 TPCCRunner是根据Transaction Processing Performance Council（事务处理性能委员会）发布的TPCC规范实现的一套标准化测试工具（TPCCRunner与标准的TPCC规范还是有一些不同的，这是一个相对简化易于操作的工具，相当于简化的TPCC测试）。
 
 ## 一、前提
 
 假设目前已经将数据库配置完成，数据库服务器和压力机是分别独立的机器（压力机和数据库服务器也可以是同一台机器，对测试结果会有影响）。
 
 ## 二、TPCCRunner配置
 
 TPCCRunner是标准的jar包，只要能够满足java虚拟机的要求，TPCCRunner测试的压力机能够运行在任何环境下。
 
 解压TPCCRunner压缩包
 
 *unzip TPCCRunner_BIN_V2.0_CMCC.zip*
 
 *cd TPCCRunner_BIN_V2.0_CMCC*
 
 TPCCRunner最主要的是TPCC的jar包，在TPCCRunner_BIN_V2.0的bin目录下
 
 进行TPCC测试首先需要生成测试数据，使用TPCCRunner自带的数据生成工具来生成数据，根据使用的数据库不同选择不同的配置文件，以下以测试Mysql为例
 
 首先创建数据库，需要调用TPCCRunner中创建数据库的sql语句，在create_database.sql中指定了用于测试的数据库的名称，之后的所有操作都是基于这个数据库进行的，因此在之后的操作中需要和create_database.sql文件中创建的数据库名称统一。
 
 执行：
 
 *mysql -uroot -prootroot -vvv -n < sql/example/mysql/create_database.sql*
 
 创建数据表：
 
 *mysql -uroot -prootroot -vvv -n < sql/example/mysql/create_table.sql*
 
 导入数据：
 
 在导入数据前需要修改loader.properties文件，loader.properties文件内容如下：
 
 --------------------------------------------
 
*driver=com.mysql.jdbc.Driver*

*url=jdbc:mysql://127.0.0.1/tpcc*

*user=root*

*password=rootroot*

*threads=40*

*warehouses=1000*

---------------------------------------

driver指定了连接数据库的引擎

url表示数据库地址，上例是在本机生成数据，因此ip是127.0.0.1，也可以通过网络连接远程生成数据，生成数据库的名称为tpcc

user指定了连接数据库的用户名

password指定了连接数据库用户名对应的登录密码

threads表示有多少个线程在执行生成数据的操作

warehouses指定了生成的数据量大小，一个warehouse约等于1G的数据

执行：

*nohup java -cp bin/TPCC_CMCC_v2.jar:lib/mysql-connector-java-5.1.7-bin.jar iomark.TPCCRunner.Loader conf/example/mysql/loader.properties &*
 
生成数据的时长与warehouse的大小有关，warehouse越多生成数据的时间越长，在openpower服务器上如果warehouse是1000，threads是40生成数据大约需要2个小时。

在数据生成完成后nohup.out文件中会输出数据生成的时间，例如

------------- LoadJDBC Statistics --------------------

     Start Time = Thu Sep 06 14:43:29 CST 2018
     
       End Time = Thu Sep 06 17:09:37 CST 2018
       
       Run Time = 8767598 Milliseconds

数据生成完成后，进入数据库中能够看到tpcc数据库，在tpcc数据库下有10个表，包括一个tpcc_result的表用于记录结果，其余九个表是tpcc测试使用的数据。

数据生成完成后，需要对数据生成索引，执行：

*nohup mysql -uroot -prootroot -vvv -n < sql/example/mysql/create_index.sql &*

如果数据量比较大的话，生成索引也需要比较长的时间。

在测试运行之前需要注意的是，需要在数据库中创建用于进行测试的用户和用户的远程连接权限，以Mysql中使用tpcc用户进行测试为例，在Mysql中执行：

*CREATE USER 'tpcc'@'localhost' IDENTIFIED BY 'tpccrunner';*

*GRANT ALL PRIVILEGES ON *.* TO 'tpcc'@'%' IDENTIFIED BY 'tpccrunner' WITH GRANT OPTION;*

确认测试用户能够通过压力机远程连接到数据库服务器。

修改/conf/example/mysql/master.propertie文件，master.properties文件内容如下：

----------------------------------------------

*listenPort=27891*

*slaves=slave01,slave02,slave03,slave04,slave05,slave06,slave07,slave08,slave09,slave10*

&nbsp;                                                                                                                                    
*runMinutes=3*

*warmupMinutes=1*

&nbsp;

*newOrderPercent=0*

*paymentPercent=0*

*orderStatusPercent=45*

*deliveryPercent=45*

*stockLevelPercent=10*

&nbsp;

*newOrderThinkSecond=0*

*paymentThinkSecond=0*

*orderStatusThinkSecond=0*

*deliveryThinkSecond=0*

*stockLevelThinkSecond=0*

------------------------------------------

listenPort：监听端口号，一般不需要修改

slaves：待测端服务器压力进程对应的slave文件名，每一个slave表示一个java进程，slaves指定了在/conf/example/mysql目录中的slave文件名称

runMinutes：tpccrunner测试运行时间

warmupMinutes：warmup运行时间

newOrderPercent: newOrder事务处理所占所有测试项的比例

paymentPercent: payment事务处理所占测试项的比例

orderStatusPercent: orderStatus事务处理所占测试项的比例

sockLevelPercent：sockLevelPercent事务处理所占测试项的比例

（注意：五种事务的比例之和必须等于100）

newOrderThinkSecond：newOrder思考时间，一般设为0即可

paymentThinkSecond：payment思考时间，一般设为0即可

orderStatusThinkSecond：orderStatus思考时间，一般设为0即可

deliveryThinkSecond：delivery思考时间，一般设为0即可

stockLevelThinkSecond：stockLevel思考时间，一般设为0即可

（五种事务的thinksecond需要根据实际情况进行调整，在标准的tpcc测试中需要指定thinksecond，当数据库存在压力时需要调整这些参数）

修改slave.properties文件，例如：

--------------------------------------------

name=slave01

masterAddress=10.152.11.25

masterPort=27891

&nbsp;

driver=com.mysql.jdbc.Driver

url=jdbc:mysql://10.152.11.25/tpcc

user=root

password=rootroot

poolSize=10

&nbsp;

userCount=2

warehouseCount=1

startWarehouseID=1

----------------------------------------------

name: 每个slave的名称，这里的name要与master中指定的slaves中的名称一一对应，否则运行时会报错

masterAddress：master主机地址，即压力机地址，master端可以在压力机上启动也可以在数据库服务器端启动

masterPort：master主机端口，用于slave与master进行连接，与master.properties中需要设置一致

driver：数据库引擎

url：数据库对应url

user：待测机器数据库连接用户名

password：待测机器数据库连接用户密码

poolSize：线程池大小，此值要大于等于userCount的值

userCount：每个java进程对应的mysql中的用户数目，一个java进程可以模拟多个mysql用户连接，但是最好不要太多，一般一个slave保持在5个左右，模拟的用户过多对java进程本身性能会有一定的影响。

warehouseCount：每个java进程使用的warehouse的数目（如果所有slave使用的warehouse总数超过实际生成warehouse的数目，则测试结果将会不准确，比实际测试结果偏大，所以要充分利用warehouse但是不能够超过实际warehouse数目，充分利用warehouse能够减少各个用户之间的冲突）

startWarehouseID：每个进程使用的warehouse的起始id

slaves文件可以自己写脚本自动生成，否则如果设置很多个slaves很容易产生错误，可以根据实际情况使用create_slaves.sh脚本和slaveXX.properties文件来自动生成slave配置文件。

当master.properties文件和slave.properties文件都配置完成后，可以开始执行测试，为了方便测试的进行，可以将测试命令以脚本的形式运行。

测试中需要启动先启动master端，具体命令如下：

*java -cp bin/TPCC_CMCC_v2.jar:lib/mysql-connector-java-5.1.7-bin.jar iomark.TPCCRunner.Master conf/example/mysql/master.properties*

master.properties就是我们修改后的master配置文件

master端启动会后会在屏幕输出如下信息等待slave端的连接：

![master等待slave连接](https://github.com/aolitianya/work/blob/master/%E6%95%B0%E6%8D%AE%E5%BA%93/TPCC%E6%B5%8B%E8%AF%95/%E6%88%AA%E5%9B%BE/TPCC_master.PNG)

master端启动后，启动slave，master中指定了多少个slave就需要启动多少个slave进程，具体命令如下：

*nohup java -cp bin/TPCC_CMCC_v2.jar:lib/mysql-connector-java-5.1.7-bin.jar iomark.TPCCRunner.Slave conf/example/mysql/slave01.properties &*

*nohup java -cp bin/TPCC_CMCC_v2.jar:lib/mysql-connector-java-5.1.7-bin.jar iomark.TPCCRunner.Slave conf/example/mysql/slave02.properties &*

*nohup java -cp bin/TPCC_CMCC_v2.jar:lib/mysql-connector-java-5.1.7-bin.jar iomark.TPCCRunner.Slave conf/example/mysql/slave03.properties &*

*nohup java -cp bin/TPCC_CMCC_v2.jar:lib/mysql-connector-java-5.1.7-bin.jar iomark.TPCCRunner.Slave conf/example/mysql/slave04.properties &*

………………

slave启动之后在master端能够看到slave已经开始连接，当所有slave都连接完成后，会显示Start transactions表示开始执行事务处理测试，如下：

All slaves are connected

Sync properties with slaves

Start transactions

Transactions started at 2020-01-08 08:55:16.956

![slave连接完成](https://github.com/aolitianya/work/blob/master/%E6%95%B0%E6%8D%AE%E5%BA%93/TPCC%E6%B5%8B%E8%AF%95/%E6%88%AA%E5%9B%BE/slave%E8%BF%9E%E6%8E%A5%E5%AE%8C%E6%88%90.PNG)

之后在测试过程中，每一分钟会输出一分钟内的事务处理量，测试会先warmup在master.properties中warmupMinutes指定的分钟数，然后正式运行runMinutes时长，运行完成后会在屏幕上打印最终结果，最终结果为runMinutes时间内的每分钟事务处理量的平均值，warmup时长不计入最终结果。
在每分钟打印的结果和最终的输出结果中，会显示每一种事务类型的事务处理量，测试结果例如：

              timestamp          type         tpm      avg_rt      max_rt   avg_db_rt   max_db_rt
2020-01-08 09:10:57.156       payment               0.00        0.00           0        0.00           0

2020-01-08 09:10:57.156   stock_level   208819.00        8.22          76        8.22          76

2020-01-08 09:10:57.156  order_status   938470.00        5.73         221        5.72         221

2020-01-08 09:10:57.156      delivery  3188913.00        5.27         217        5.27         217

2020-01-08 09:10:57.156     new_order        0.00        0.00           0        0.00           0

2020-01-08 09:10:57.156         total  4336202.00       19.23         514       19.22         514



timestamp打印输出的时间戳

type表示不同的事务处理类型，total是五种事务处理量的总和

tpm是每分钟事务处理量

avg_rt表示事务处理平均延迟，这一延迟包括从java连接池开始建立连接之前到连接池回收连接为止的平均时长

max_rt表示事务处理最大延迟，这一延迟是从java连接池开始建立连接之前到连接池回收连接为止的最大时长

avg_db_rt表示数据库事务处理平均延迟，这一延迟是从java连接池中建立连接之后到连接池回收之前的平均时长

max_db_rt表示数据库事务处理最大延迟，这一延迟是从java连接池中建立连接之后到连接池回收之前的最大时长

（大多数情况下，avg_rt和avg_db_rt，max_rt和max_db_rt的值基本上是差不多的，从java连接池中建立连接的延迟基本可以忽略）

当runtime时间截止，屏幕会打印出最终测试结果Run End并输出最终测试结果，最终测试结果例如：

Run End.

              timestamp          type         tpm      avg_rt      max_rt   avg_db_rt   max_db_rt
                average       payment        0.00        0.00           0        0.00           0
                average   stock_level   217123.60        8.18         224        8.18         224
                average  order_status   975287.40        5.69         227        5.69         227
                average      delivery  3298896.10        5.27         228        5.27         228
                average     new_order        0.00        0.00           0        0.00           0
                average         total  4491307.10       19.15         679       19.14         679

   All phase Transactions: 66906040
   
Warmup phase Transactions: 21992969

   Run phase Transactions: 44913071

Waiting slaves to terminate users.

All slaves disconnected.

最终测试结果是在runtime时间内的平均值，在最后还输出了在测试过程中所有的transactions和在runtime时长内的transaction以及在warmup时长内的transaction。

当测试完成后，master会等待slave断开连接，最终显示all slaves disconnected。表示所有slave连接已经释放，此时在Mysql中能够看到slave连接已经断开。












