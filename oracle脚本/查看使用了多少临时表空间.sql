
----�鿴ʹ���˶�����ʱ��ռ�

select te.CREATE_BYTES,sum(te.BLOCK_SIZE * so.BLOCKS), so.TABLESPACE
  from v$sort_usage so, v$tempfile te
 group by so.TABLESPACE,te.CREATE_BYTES;



-----�鿴��ʱ��ռ�Ĵ�С
select tablespace_name,sum(bytes)/1024/1024 from dba_temp_files group by tablespace_name

