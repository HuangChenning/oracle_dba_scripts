/*查看表空间的大小，文件名称，file_id*/
select tablespace_name, file_id, file_name,
round(bytes/(1024*1024),1) total_space
from dba_data_files d
where d.tablespace_name = 'UNDOTBSBAK0527'
order by tablespace_name;



/*查看表空间的剩余空间*/
select tablespace_name,round(total_bytes/1024/1024/1024,1)||'G' free from DBA_FREE_SPACE_COALESCED s order by s.tablespace_name;


select tablespace_name,round(total_bytes/1024/1024,1)||'M' free from DBA_FREE_SPACE_COALESCED s order by s.tablespace_name;


select tablespace_name, round(total_bytes / 1024 / 1024, 1) || 'M' free
  from DBA_FREE_SPACE_COALESCED f
  where f.tablespace_name like 'USER_TMP%'
  
SELECT * FROM DBA_TEMP_FILES;

/*查看表空间的名称及其大小*/
select t.tablespace_name, round(sum(bytes/(1024*1024)),1) ts_size
from dba_tablespaces t, dba_data_files d
where t.tablespace_name = d.tablespace_name
group by t.tablespace_name;


/*查看表空间的使用情况*/

select tablespace_name,total_space total_space,free_space ,round(nvl(free_space,0)/total_space*100,2)||'%' free,total_space-free_space used,
round(nvl(total_space-free_space,0)/total_space*100,2)||'%' Iused
from (
select f.tablespace_name,round(f.bytes/(1024*1024),1) total_space,round(total_bytes/(1024*1024),1) free_space
from (select tablespace_name,sum(bytes) bytes from dba_data_files group by tablespace_name )f,dba_free_space_coalesced s
where f.tablespace_name=s.tablespace_name
) t
where t.tablespace_name='OFFONHIS' 

select * from dba_temp_files;


select * from dba_tables t where t.tablespace_name='CUSTMSG02_LC';


---------查看表空间情况（日报中的检查脚本）------------
SELECT *
  FROM perfstat.stats$spacestat s
 WHERE to_char(start_date, 'YYYY-MM-DD') = to_char(SYSDATE, 'YYYY-MM-DD')
 order by s.used_percent desc;


SELECT *
  FROM perfstat.stats$spacestat s
 WHERE to_char(start_date, 'YYYY-MM-DD') = to_char(SYSDATE, 'YYYY-MM-DD')
 order by s.tableapce_name;


select * from perfstat.stats$spacestat s order by s.start_date desc;
