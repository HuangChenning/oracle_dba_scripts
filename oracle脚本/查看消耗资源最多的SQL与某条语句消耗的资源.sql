----------查看消耗资源最多的SQL：
SELECT hash_value, executions, buffer_gets, disk_reads, parse_calls
FROM V$SQLAREA
WHERE buffer_gets > 10000000 OR disk_reads > 1000000
ORDER BY buffer_gets + 100 * disk_reads DESC;







---------查看某条SQL语句的资源消耗：
SELECT hash_value, buffer_gets, disk_reads, executions, parse_calls
FROM V$SQLAREA
WHERE hash_Value = 228801498 AND address = hextoraw('CBD8E4B0');
