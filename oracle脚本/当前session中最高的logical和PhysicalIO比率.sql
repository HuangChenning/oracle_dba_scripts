-------通过v$sesstat和v$statname连接查询某个SID各项信息
select a.*,b.name
from v$sesstat a,v$statname b
where a.sid=10 and a.statistic#=b.statistic#;

---先获得session逻辑读和物理读统计项的STATISTIC#值
select name, statistic#

  FROM V$STATNAME

 WHERE name IN ('session logical reads', 'physical reads');

------通过上面获得的STATISTIC#值执行下列语句
SELECT ses.sid,
       DECODE(ses.action, NULL, 'online', 'batch') "User",
       MAX(DECODE(sta.statistic#, 9, sta.value, 0)) /
       greatest(3600 * 24 * (sysdate - ses.logon_time), 1) "Log IO/s",
       MAX(DECODE(sta.statistic#, 40, sta.value, 0)) /
       greatest(3600 * 24 * (sysdate - ses.logon_time), 1) "Phy IO/s",
       60 * 24 * (sysdate - ses.logon_time) "Minutes"
  FROM V$SESSION ses, V$SESSTAT sta
 WHERE ses.status = 'ACTIVE'
   AND sta.sid = ses.sid
   AND sta.statistic# IN (9, 40)
 GROUP BY ses.sid, ses.action, ses.logon_time
 ORDER BY SUM(DECODE(sta.statistic#, 40, 100 * sta.value, sta.value)) /
          greatest(3600 * 24 * (sysdate - ses.logon_time), 1) DESC;




