select owner, object_name, object_type, statistic_name, value
  from v$segment_statistics
 where object_name = upper('wLoginOpr201202');




/*�鿴��������Ϣ*/

select * from dba_tab_partitions where table_name=upper('wLoginOpr201202');

select * from dba_tab_partitions where table_name=upper('wLoginOpr201102');

/*�鿴������ķ�����Ϣ*/
select * from dba_part_tables where table_name=upper('wLoginOpr201102');

