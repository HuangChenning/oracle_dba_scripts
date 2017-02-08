select *
  from (select substr(a.event, 1, 25) waited,
               substr(b.program, 1, 25) program,
               count(*)
          from v$session_wait a, v$session b
         where a.sid = b.sid
           and a.WAIT_TIME = 0
           and a.event not like '%SQL%'
           and a.event not like '%message%'
           and a.event not like '%time%'
           and a.event not like 'PX Deq:%'
           and a.event not like 'jobq slave%'
         group by substr(a.event, 1, 25), substr(b.program, 1, 25)
         order by count(*) desc)
 where rownum < 11
