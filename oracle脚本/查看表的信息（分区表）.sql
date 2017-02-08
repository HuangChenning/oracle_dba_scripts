--查看表的信息（其中partitioned如果是yes代表该表是分区表）
select a.partitioned from dba_tables a where a.table_name='WPAY200906';

--如果b.partition_name有多个名字的话，也说明该表是分区表
select b.partition_name from dba_extents b where b.segment_name='WPAY200906';
DBACCADM.WPAY200906

