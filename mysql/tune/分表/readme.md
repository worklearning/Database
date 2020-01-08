# 分表策略
## 分表策略适用于mysql高并发测试场景
## 分表方法
根据TPCCRunner测试特点，按照数据表warehouse id进行分表，每十个warehouse分成一个分区；上述分表脚本是针对300 warehouse场景分表策略，不同warehouse数量相应修改分表脚本；
## 分表策略理由
TPCCRunner测试中，mysql数据库表都基于warehouse id进行关联；因此按照warehouse id进行分表，能保持原表与表的关系。
## 使用说明
1 在TPCCRunner测试目录创建sql/part目录;将sql脚本拷贝到sql/part目录。

2 将part_table.sh拷贝到TPCCRunner目录。

3 执行sh [part_table.sh](./part_table.sh "part")
