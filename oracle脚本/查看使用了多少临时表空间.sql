
----查看使用了多少临时表空间

select te.CREATE_BYTES,sum(te.BLOCK_SIZE * so.BLOCKS), so.TABLESPACE
  from v$sort_usage so, v$tempfile te
 group by so.TABLESPACE,te.CREATE_BYTES;



-----查看临时表空间的大小
select tablespace_name,sum(bytes)/1024/1024 from dba_temp_files group by tablespace_name

