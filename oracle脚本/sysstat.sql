/*
查看当前系统的sql解析情况
(total - hard)/total的值来计算软解析率

*/
select * from v$sysstat where name like '%parse%';

select (7529-983)/7529 from dual;



select * from v$sqlarea s order by s.version_count desc;

/*该视图给出了SQL不能共享的具体原因*/
select * from v$sql_shared_cursor
