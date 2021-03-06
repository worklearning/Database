# TPCC测试概述

TPCC测试是由Transaction Processing Performance Council（事务处理性能委员会）制定的专门针对联机交易系统（OLTP）的规范。

TPC(Transaction Processing Performance Council，事务处理性能委员会)是由数十家会员公司创建的非盈利组织，总部设在美国。TPC的成员主要是计算机软硬件厂家，而非计算机用户，其功能是制定商务应用基准程序的标准规范、性能和价格度量，并管理测试结果的发布。

TPC不给出基准程序的代码，而只给出基准程序的标准规范。任何厂家或其他测试者都可以根据规范，最优地构造出自己的测试系统(测试平台和测试程序)。为保证测试结果的完整性，被测试者(通常是厂家)必须提交给TPC一套完整的报告(Full Disclosure Report)，包括被测系统的详细配置、分类价格和包含5年维护费用在内的总价格。该报告必须由TPC授权的审核员核实(TPC本身并不做审计)。 TPC在全球只有不到10名审核员，全部在美国。

TPC-C测试用到的模型是一个大型的商品批发销售公司，它拥有若干个分布在不同区域的商品仓库。当业务扩展的时候，公司将添加新的仓库。每个仓库负责为10个销售点供货，其中每个销售点为3000个客户提供服务，每个客户提交的订单中，平均每个订单有10项产品，所有订单中约1%的产品在其直接所属的仓库中没有存货，必须由其他区域的仓库来供货。同时，每个仓库都要维护公司销售的100000种商品的库存记录。

TPCC标准中指定了九个表及五种事务处理模型。九个表分别表示商品仓库，销售点，客户，订单，库存等。

五种事务处理模型分别是：

•	New-order：新订单操作，客户输入一笔新的订货交易。

•	Payment：支付操作，更新客户账户余额以及反映支付情况。

•	Order-status：订单状态，查询客户最近的交易状态。

•	Delivery：发货操作。

•	Stock-level：库存操作，查询仓库的库存状态。


在TPCCRunner中可以指定五种事务处理模型在完整测试中占据的比例，其中New-order和Payment主要为写操作，Order-status、Delivery、Stock-level主要为读操作。
TPCC测试结果主要有两个指标：

•	一是流量指标，即TPM，该指标描述了系统每分钟事务处理的数量，TPM值越大说明系统的联机事务处理能力越强。

•	二是性价比，在相同TPM情况下的价格。

TPCC测试模型中的九个表之间相互关联，具体每个表的大小与warehouse大小成正比，各个表之间大小关系如图

![TPCC各个表大小关系](https://github.com/aolitianya/work/blob/master/%E6%95%B0%E6%8D%AE%E5%BA%93/TPCC%E6%B5%8B%E8%AF%95/%E6%88%AA%E5%9B%BE/TPCC%E8%A1%A8%E5%A4%A7%E5%B0%8F.png)
