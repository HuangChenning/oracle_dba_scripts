-----查看数据库碎片

select * from ( select   total.tablespace_name  tsname, count(free.bytes)  nfrags
from dba_data_files  total, dba_free_space  free
where total.tablespace_name = free.tablespace_name(+)
  and total.file_id=free.file_id(+)
group by total.tablespace_name) a
where a.nfrags>100
order by a.nfrags;


----Tablespace Default Storage Management

select tablespace_name,EXTENT_MANAGEMENT,SEGMENT_SPACE_MANAGEMENT
from dba_tablespaces
where SEGMENT_SPACE_MANAGEMENT='MANUAL';
