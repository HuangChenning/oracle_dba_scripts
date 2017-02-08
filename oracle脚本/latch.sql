/*�鿴�ȴ��¼��Ƿ���latch free����*/
SELECT SID,event,p1,p1raw FROM v$session_wait; 
/*
������Щlatch free�ڵȴ����ܵ�ͳ��*/

SELECT addr,latch#,NAME,gets,spin_gets from v$latch ORDER BY spin_gets DESC

--�鿴��ǰlatch free�ڵȴ���latch��ʵʱ��
SELECT w.sid,w.event,l.name
  FROM V$LATCHNAME L, V$SESSION_WAIT W
 WHERE L.LATCH# = W.P2
   AND W.EVENT = 'latch free';


---�鿴��ǰ��latch�����ʵʱ�ģ�3.229�����dblatch�ű���
SELECT C.SID,
       C.SERIAL#,
       DECODE(C.SQL_HASH_VALUE, 0, C.PREV_HASH_VALUE, C.SQL_HASH_VALUE) HASH_VALUE,
       D.NAME EVENTNAME,
       C.OSUSER,
       C.PROGRAM
  FROM V$SESSION_WAIT B, V$SESSION C, V$LATCHNAME D
 WHERE B.EVENT = 'latch free'
   AND B.SID = C.SID
   AND B.P2 = D.LATCH#
   AND C.TYPE <> 'BACKGROUND';

/*ͨ��P2��v$latchname.latch#���ҵ���Ӧֵ*/
select * from v$session_wait where event='latch free';


select * from v$latchname;




select pool, name, bytes / 1024 / 1024
  from v$sgastat
 where pool = 'shared pool'
   and name = 'free memory'



select to_char(sysdate,'mmdd hh24:mi:ss') as curtime,pool,name,round(bytes/1024/1024) as shmem 
from v$sgastat where name like 'free%' and pool='shared pool';

/*�鿴��ǰ�ȴ��¼��Ƿ�Ϊlatch������ǿ�����v$latch_children�в�ѯ��ص���latch��Ϣ*/
select sid,seq#,event from v$session_wait;

/*
latch free:
address	
number	
tries
*/
select * from v$event_name where name='latch free';

/*ͨ��P2��v$latchname�鿴latch������*/

select * from v$session_wait where event='latch free';

select * from v$latch_children where addr='0700001AD0305128';

select * from v$latchname where latch#=157;

/*�鿴���ݿ���������������cache buffer chains��latch�����
gets����Ĵ�����misses����ʧ�ܵĴ�����sleep����ʧ�����ߵĴ���
ͨ��sleep����֪��latch�����Ƿ����أ���ӱ������ȵ��������Ƿ�����*/
select latch#,name,gets,misses,sleeps
from v$latch
where name like 'cache buffer%';

/*
v$latch_children.addr��¼�ľ������latch�ĵ�ַ
*/
select * from (
select addr,latch#,child#,gets,misses,sleeps
from v$latch_children
where name='cache buffers chains'
order by sleeps desc)
where rownum<21;


/*�����ҵ���ǰ�������ȵ����ݿ��latch��buffer��Ϣ*/
select b.addr,a.ts#, a.dbarfil, a.dbablk, a.tch, b.gets, b.misses, b.sleeps
  from (select *
          from (select addr, ts#, file#, dbarfil, dbablk, tch, hladdr
                  from x$bh
                 order by tch desc)
         where rownum < 11) a,
       (select addr, gets, misses, sleeps
          from v$latch_children
         where name = 'cache buffers chains') b
 where a.hladdr = b.addr

/*����v$latch_child.addr��������Ӧ��x$bh.hladdr(����buffer header�м�¼�ĵ�ǰbuffer������latch��ַ)��
ͨ��x$bh���Ի�ÿ���ļ���ź�block���*/

select dbarfil,dbablk
from x$bh
where hladdr in
(select addr
from (select addr
from v$latch_children order by sleeps desc) where rownum<11);

/*�ҵ��ȵ�Ķ�����Ϣ*/
select distinct a.owner,a.segment_name
from dba_extents a,
(select dbarfil,dbablk
from x$bh
where hladdr in
(select addr
from (select addr
from v$latch_children order by sleeps desc) where rownum<11)) b
where a.relative_fno = b.dbarfil
and a.block_id <= b.dbablk
and a.block_id + a.blocks > b.dbablk;


/*
���v$sqltext��v$sqlarea�������ҵ�������Щ�����SQL,ִ���ٶȺ���
*/
select /*+ rule*/
 hash_value, sql_text
  from v$sqltext
 where (hash_value, address) in
       (select a.hash_value, a.address
          from v$sqltext a,
               (select distinct a.owner, a.segment_name, a.segment_type
                  from dba_extents a,
                       (select dbarfil, dbablk
                          from x$bh
                         where hladdr in (select addr
                                            from (select addr
                                                    from v$latch_children
                                                   order by sleeps desc)
                                           where rownum < 11)) b
                 where a.relative_fno = b.dbarfil
                   and a.block_id <= b.dbablk
                   and a.block_id + a.blocks > b.dbablk) b
         where a.sql_text like '%' || b.segment_name || '%'
           and b.segment_type = 'TABLE')
 order by hash_value, address, piece;
 
 
/* dblatchsql

set termout on
SET PAGES 5000
set linesize 190
col program for a40
col username for a20
col eventname for a20
col osuser for a20
col sid for 99999
col serial# for 99999
select
c.sid,c.serial#,decode(c.sql_hash_value,0,c.prev_hash_value,c.sql_hash_value) hash_value,
d.name eventname,
c.osuser,c.program
from v\$session_wait b,v\$session c,v\$latchname d
where b.event='latch free' and b.sid=c.sid and b.p2=d.latch# and c.TYPE<>'BACKGROUND';
set termout off
exit
EOF
cat /tmp/huang.log
cat /tmp/huang.log|grep -v rows|grep  -v ^-|grep -v SID|awk '{print $3}'|grep -v ^$|sort|uniq|while read a
do
$1 <<EOF
set termout  off;
variable v_hash_value Number;
BEGIN
:v_hash_value :=$a;
END;
/
set termout  on;
set pages 0
set lines 1000
set feedback off
select to_char(sysdate,'yyyymmdd hh24:mi:ss') as curtime,hash_value,sql_text from v\$sqltext where hash_value=:v_hash_value order by
piece;
set termout  off;
undefine hash_value;
set termout  on;
exit
EOF
done
sleep 10
done
*/


select c.sid,
       c.serial#,
       decode(c.sql_hash_value, 0, c.prev_hash_value, c.sql_hash_value) hash_value,
       d.name eventname,
       c.osuser,
       c.program
  from v$session_wait b, v$session c, v$latchname d
 where b.event = 'latch free'
   and b.sid = c.sid
   and b.p2 = d.latch#
   and c.TYPE <> 'BACKGROUND';


select to_char(sysdate, 'yyyymmdd hh24:mi:ss') as curtime,
       hash_value,
       sql_text
  from v $sqltext
 where hash_value = :v_hash_value
 order by piece;



/*
cache buffers chains:�ȵ�龺��
*/
