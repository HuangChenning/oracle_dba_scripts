--�鿴�����Ϣ������partitioned�����yes����ñ��Ƿ�����
select a.partitioned from dba_tables a where a.table_name='WPAY200906';

--���b.partition_name�ж�����ֵĻ���Ҳ˵���ñ��Ƿ�����
select b.partition_name from dba_extents b where b.segment_name='WPAY200906';
DBACCADM.WPAY200906

