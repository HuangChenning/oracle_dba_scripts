select * from v$fixed_table where name like 'X$%';

select * from v$spparameter where name like '%max%';


select * from v$buffer_pool;

select * from v$sgastat where pool='shared pool' and name like '%memory%';


select * from v$sgainfo;
