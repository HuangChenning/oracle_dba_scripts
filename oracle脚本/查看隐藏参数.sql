
/*set lines 120
col name for a30
col value for a20
col describ for a60*/
select x.ksppinm name,y.ksppstvl value,x.ksppdesc describ
from sys.x$ksppi x,sys.x$ksppcv y
where x.indx=y.indx
and x.ksppinm like '%_shared%';


/*查看ASSM下的pool和db_cache_size的大小*/

select x.ksppinm name, y.ksppstvl value, x.ksppdesc describ
  from sys.x$ksppi x, sys.x$ksppcv y
 where x.inst_id = userenv('Instance')
   and y.inst_id = userenv('Instance')
   and x.indx = y.indx
   and x.ksppinm like '__%pool_size%'

select x.ksppinm name, y.ksppstvl value, x.ksppdesc describ
  from sys.x$ksppi x, sys.x$ksppcv y
 where x.inst_id = userenv('Instance')
   and y.inst_id = userenv('Instance')
   and x.indx = y.indx
   and x.ksppinm like '%db_cache_size%';
