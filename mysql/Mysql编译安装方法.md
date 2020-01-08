# Mysql编译安装方法

## 一、Mysql源码下载

目前yum源中没有提供Mysql的安装包，不能够使用yum install的方式安装Mysql，需要下载Mysql的源码包进行编译安装。

Mysql最新版本下载地址：https://dev.mysql.com/downloads/mysql/

可以在上述网址下载到Mysql的最新版本的安装包及源码包。
如果需要下载历史版本的Mysql，可以在如下网址进行下载

Mysql历史版本下载地址：https://downloads.mysql.com/archives/community/

需要注意的是，在Mysql5.7版本之后，有了许多新的变化，比如boost库的安装，某些组件需要boost库的支持，mysql的官网源码有带boost库的源码和不带boost库的源码两种，因此有两种安装方式，其实都是一样的，仅仅是不带boost库源码的需要单独安装boost。在不确定是否需要boost的情况下最好安装自带boost的Mysql版本。

## 二、Mysql源码编译

### 1. 依赖包安装
首先需要配置好yum源，安装编译mysql需要的相关依赖包，主要包括如下依赖：

*yum -y install glibc-headers**

*yum -y install gcc**

*yum -y install libgcc*

*yum -y install ncurses-devel*

*yum -y install cmake*

*yum -y install libaio**

*yum -y install numactl**

*yum -y install numad*

*yum -y install bison**

*yum -y install cmake*

*yum -y install gnutls**

*yum -y install libxml2**

*yum -y install openssl* openssh**

*yum -y install pcre**

*yum -y install zlib-devel bzip2-devel lz4-devel libevent-devel git*

### 2. AT编译器安装（非必选）

注意：在Openpower上使用AT11编译器性能会有更好的表现，需要安装AT11编译器

AT编译器下载地址：ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/redhat/RHEL7/

必须安装的AT包包括以下部分：

*rpm -ivh advance-toolchain-at11.0-runtime-11.0-3.ppc64le.rpm*

*rpm -ivh advance-toolchain-at11.0-devel-11.0-3.ppc64le.rpm*

*rpm -ivh advance-toolchain-at11.0-mcore-libs-11.0-3.ppc64le.rpm*

*rpm -ivh advance-toolchain-at11.0-perf-11.0-3.ppc64le.rpm*

如果不安装AT编译器可以使用系统自带的gcc编译器进行编译安装

### 3. Mysql源码包编译安装

Mysql源码包下载完成后，加压mysql源码包，本文以mysql-5.7.23版本为例。

解压源码包

*tar -xvf mysql-boost-5.7.23.tar.gz*

进入mysql-5.7.23目录下

*cd mysql-5.7.23*

创建build文件夹

*mkdir build*

进入到build目录下

*cd build*

创建cmp.sh文件

*vi cmp.sh*

#### AT11编译Mysql

cmp.sh文件内容中包含了mysql编译方法，针对Openpower P9的AT11编译选项如下：

*export PATH=/opt/at11.0/bin:$PATH*

*CC=/opt/at11.0/bin/gcc CXX=/opt/at11.0/bin/g++ CFLAGS="-O3 -mcpu=power9 -mtune=power9 -g" CXXFLAGS="-O3 -mcpu=power9 -mtune=power9 -g" cmake ../ -DWITH_BOOST=/home/mysql-5.7.23/boost/boost_1_59_0 -DCMAKE_C_COMPILER=${CC:-gcc} -DCMAKE_CXX_COMPILER=${CXX:-g++} -DCMAKE_C_FLAGS_RELWITHDEBINFO="-O3 -g" -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-O3 -g" -DWITH_SSL=bundled -DCMAKE_INSTALL_PREFIX=/usr/local/mysql/5.7*

*make -j32*

*make install*

执行cmp.sh文件

*sh cmp.sh*

cmp.sh执行完成后mysql编译安装完成，安装路径在cmp.sh中DCMAKE_INSTALL_PREFIX指定，编译过程时间较长。

编译安装完成后查看mysql版本

![Mysql版本信息](https://github.com/aolitianya/work/blob/master/%E6%95%B0%E6%8D%AE%E5%BA%93/Mysql/%E6%88%AA%E5%9B%BE/Mysql%E7%89%88%E6%9C%AC.PNG)

如上显示则表示mysql已经安装完成

#### gcc编译Mysql

如果没有安装AT11，可以使用gcc编译安装mysql，需要注意的是gcc的编译选项略有不同，在gcc中不支持-mcpu=power9和-mtune=power9的选项

*CC=/usr/bin/gcc CXX=/usr/bin/g++ CFLAGS="-O3 -g" CXXFLAGS="-O3 -g" cmake ../ -DWITH_BOOST=/home/mysql-5.7.23/boost/boost_1_59_0 -DCMAKE_C_COMPILER=${CC:-gcc} -DCMAKE_CXX_COMPILER=${CXX:-g++} -DCMAKE_C_FLAGS_RELWITHDEBINFO="-O3 -g" -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-O3 -g" -DWITH_SSL=bundled -DCMAKE_INSTALL_PREFIX=/usr/local/mysql/5.7*

*make -j32*

*make install*

使用gcc编译，以上的编译选项在x86上也是通用的。


