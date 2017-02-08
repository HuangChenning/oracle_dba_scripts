
-----查看表的大小

select segment_name,bytes/1024/1024 from dba_segments d where d.segment_name=upper('t');

---查看表的大小
select * from dba_segments s where s.segment_name='T';



-----查看表的大小
select e.segment_name, sum(e.bytes)
  from dba_extents e
 where e.tablespace_name = 'ZLY001'
 group by e.segment_name;
