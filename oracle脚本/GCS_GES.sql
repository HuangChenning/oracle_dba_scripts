select s.statistic_name stat, owner, object_name obj, sum(value) val
  from v$segment_statistics s
 where s.statistic_name like 'global%'
   and s.value > 0
 group by s.statistic_name, owner, object_name
 order by val desc;
