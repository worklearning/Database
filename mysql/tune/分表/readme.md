# 分表策略
## 分表策略适用于高并发场景
## 分表方法
根据TPCCRunner测试特点，按照数据表warehouse id进行分表；
## 分表策略原因
TPCCRunner测试中，mysql数据库表都基于warehouse id进行关联；因此按照warehouse id进行分表，能保持原表与表的关系。
