
-----�鿴��Ĵ�С

select segment_name,bytes/1024/1024 from dba_segments d where d.segment_name=upper('t');

---�鿴��Ĵ�С
select * from dba_segments s where s.segment_name='T';



-----�鿴��Ĵ�С
select e.segment_name, sum(e.bytes)
  from dba_extents e
 where e.tablespace_name = 'ZLY001'
 group by e.segment_name;
