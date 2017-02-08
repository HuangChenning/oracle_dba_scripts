select to_char(sysdate, 'yyyymmdd hh24:mi:ss') as curtime,
       sql_id,
       hash_value,
       sql_text
  from v$sqltext
 where sql_id = gu047r78gbwm3
 order by piece;
