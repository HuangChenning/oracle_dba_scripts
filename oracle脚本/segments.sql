select owner, object_name, object_type, statistic_name, value
  from v$segment_statistics
 where object_name = upper('wLoginOpr201202');




/*查看分区表信息*/

select * from dba_tab_partitions where table_name=upper('wLoginOpr201202');

select * from dba_tab_partitions where table_name=upper('wLoginOpr201102');

/*查看分区表的分区信息*/
select * from dba_part_tables where table_name=upper('wLoginOpr201102');

