----------�鿴������Դ����SQL��
SELECT hash_value, executions, buffer_gets, disk_reads, parse_calls
FROM V$SQLAREA
WHERE buffer_gets > 10000000 OR disk_reads > 1000000
ORDER BY buffer_gets + 100 * disk_reads DESC;







---------�鿴ĳ��SQL������Դ���ģ�
SELECT hash_value, buffer_gets, disk_reads, executions, parse_calls
FROM V$SQLAREA
WHERE hash_Value = 228801498 AND address = hextoraw('CBD8E4B0');
