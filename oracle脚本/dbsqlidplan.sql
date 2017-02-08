select '| Operation                         | PHV/Object Name                    |  Rows | Bytes|   Cost |'  
as "Optimizer Plan:" from dual
union all
select
    rpad('| '||substr(lpad(' ',1*(depth-1))||operation||
     decode(options, null,'',' '||options), 1, 35), 36, ' ')||'|'||
  rpad(decode(id, 0, '---------------------------------- '
    , substr(decode(substr(object_name, 1, 7), 'SYS_LE_', null, object_name)
       ||' ',1, 35)), 36, ' ')||'|'||
   lpad(decode(cardinality,null,'  ',
      decode(sign(cardinality-1000), -1, cardinality||' ',
      decode(sign(cardinality-1000000), -1, trunc(cardinality/1000)||'K',
      decode(sign(cardinality-1000000000), -1, trunc(cardinality/1000000)||'M',
      trunc(cardinality/1000000000)||'G')))), 7, ' ') || '|' ||
  lpad(decode(bytes,null,' ',
    decode(sign(bytes-1024), -1, bytes||' ',
    decode(sign(bytes-1048576), -1, trunc(bytes/1024)||'K',
       decode(sign(bytes-1073741824), -1, trunc(bytes/1048576)||'M',
         trunc(bytes/1073741824)||'G')))), 6, ' ') || '|' ||
    lpad(decode(cost,null,' ', decode(sign(cost-10000000), -1, cost||' ',
                decode(sign(cost-1000000000), -1, trunc(cost/1000000)||'M',
                       trunc(cost/1000000000)||'G'))), 8, ' ') || '|' as "Explain plan"
from v$sql_plan sp
where sp.sql_id='';



select * from table(dbms_xplan.display_cursor('axcn93h5nmpst'));
