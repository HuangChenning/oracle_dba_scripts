select name,parameter1,parameter2,parameter3 from v$event_name where name='db file sequential read';


select name,parameter1,parameter2,parameter3 from v$event_name where name='enqueue'


select * from v$session_wait;

/*v$session_wait 
根据session id可以得到这个session的等待情况。 
event字段表示等待事件。 
p1、 p2、p3告诉我们等待事件的具体含义，


select name,parameter1,parameter2,parameter3 from v$event_name where name='db file scattered read';
1	db file scattered read	file#	block#	blocks


如果wait event是db file scattered read，
p1=file_id p2=block_id p3=blocks，然后通过dba_extents即可确定出热点对象；

如果是latch free的话，p2为闩锁号，它指向v$latch。 

P1RAW,P2RAW,P3RAW列对应P1,P2,P3的十六进制值；
P1TEXT,P2TEXT,P3TEXT列对应P1,P2,P3列的解释。 */


  


SELECT SID, SEQ#, EVENT, P1TEXT, P1, P2TEXT, P2, P3TEXT, P3, STATE
  FROM V$SESSION_WAIT;

--求等待事件及其对应的latch 
col event format a32 
col name format a32 

select sid,event,p1 as file_id, p2 as "block_id/latch", p3 as blocks,l.name 
from v$session_wait sw,v$latch l 
where event not like '%SQL%' and event not like '%rdbms%' 
and event not like '%mon%' and sw.p2 = l.latch#(+); 

/*
利用v$session_wait中的p2与V$latch中的latch#来进行匹配

SELECT * FROM v$latch WHERE latch#=
*/



--求等待事件及其热点对象 
/*
SELECT SID, SEQ#, EVENT, P1TEXT, P1 file_id, P2TEXT, P2 block_id, P3TEXT, P3 blocks, STATE
  FROM V$SESSION_WAIT 

*/
col owner format a18 
col segment_name format a32 
col segment_type format a32 


select owner,segment_name,segment_type 
from dba_extents 
where file_id = &file_id and &block_id between block_id 
and block_id + &blocks - 1; 


--综合以上两条sql，同时显示latch及热点对象(速度较慢) 
SELECT SW.SID, EVENT, L.NAME, DE.SEGMENT_NAME
  FROM V$SESSION_WAIT SW, V$LATCH L, DBA_EXTENTS DE
 WHERE EVENT NOT LIKE '%SQL%'
   AND EVENT NOT LIKE '%rdbms%'
   AND EVENT NOT LIKE '%mon%'
   AND SW.P2 = L.LATCH#(+)
   AND SW.P1 = DE.FILE_ID(+)
   AND P2 BETWEEN DE.BLOCK_ID AND DE.BLOCK_ID + DE.BLOCKS - 1;


--如果是非空闲等待事件，通过等待会话的sid可以求出该会话在执行的sql 
select sql_text 
from v$sqltext_with_newlines st,v$session se 
where st.address=se.sql_address and st.hash_value=se.sql_hash_value 
and se.sid =&wait_sid order by piece; 

/*
其中 STATE 列 的描述如下(参考 Oracle Database Reference 10g Release 1 Part Number B10755-01): 
• 0 - WAITING (当前等待的 Session) 
• -2 - WAITED UNKNOWN TIME (最后等待持续时间未知) 
• -1 - WAITED SHORT TIME (最后的等待 <1/100 秒) 
• >0 - WAITED KNOWN TIME (WAIT_TIME = 最后等待持续时间) 
*/


/*
从v$session_wait中查询P3(原因编码)的值可以知道session等待的原因。原因编码的范围从0到300，下列为部分编码所代表的事项：
0 块被读入缓冲区。
100 我们想要NEW(创建)一个块，但这一块当前被另一session读入。
110 我们想将当前块设为共享，但这一块被另一session读入，所以我们必须等待read()结束。
120 我们想获得当前的块，但其他人已经将这一块读入缓冲区，所以我们只能等待他人的读入结束。
130 块被另一session读入，而且没有找到其它协调的块，所以我们必须等待读的结束。缓冲区死锁后这种情况也有可能产生。所以必须读入块的CR。
200 我们想新创建一个block，但其他人在使用，所以我们只好等待他人使用结束。
210 Session想读入SCUR或XCUR中的块，如果块交换或者session处于非连续的TX模式，所以等待可能需要很长的时间。
220 在缓冲区查询一个块的当前版本，但有人以不合法的模式使用这一块，所以我们只能等待。
230 以CR/CRX方式获得一个块，但块中的更改开始并且没有结束。
231 CR/CRX扫描找到当前块，但块中的更改开始并且没有结束。
*/

