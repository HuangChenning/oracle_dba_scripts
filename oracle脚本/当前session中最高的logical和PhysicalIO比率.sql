-------ͨ��v$sesstat��v$statname���Ӳ�ѯĳ��SID������Ϣ
select a.*,b.name
from v$sesstat a,v$statname b
where a.sid=10 and a.statistic#=b.statistic#;

---�Ȼ��session�߼����������ͳ�����STATISTIC#ֵ
select name, statistic#

  FROM V$STATNAME

 WHERE name IN ('session logical reads', 'physical reads');

------ͨ�������õ�STATISTIC#ִֵ���������
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




