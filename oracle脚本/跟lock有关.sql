/*�鿴�����Ķ��������ĸ��Ự*/
select * from v$session where sid in(
select session_id
  from v$locked_object
 where object_id in
       (select object_id from dba_objects where object_name = upper('dCustMsg')));




/*
���ֵΪdead����ʾ�����������ع���NONE��ʾ����
[K]ernel [T]ransaction [U]ndo Transa[x]tion [E]ntry(table)
��������У����ݿ�չʾ�˻ع���ͷ���������Ϣ��ͨ������ṹ��
���Ի�����ݿ������йص���Ϣ


x$KTUXE�����Ի���޷�ͨ��v$transaction���۲����������Ϣ��
��һ�����ݿⷢ���쳣�жϣ���������ӳ�����ָ�ʱ�����ݿ�����
���޷�ͨ��v$transaction���۲�������Ϣ������ͨ��x$KTUXE����á�

�ñ��е�ktuxecfl�����������flag��ǣ�ͨ�������ǿ����ҵ�
��Щdead����

ktuxesiz������¼����ʹ�õĻع��ο�����ͨ���۲�����ֶ�������
�ָ��ٶ�
*/
select addr,ktuxeusn,ktuxeslt,ktuxesqn,ktuxesiz
 from x$ktuxe where ktuxecfl='DEAD';




/*
dbholder 
select * from v$lock;
Type:
(User Type)
TX:Transaction �м���
TM��Table Manipulate ����
UL:PL/SQL USER LOCK
ST���ռ�������
TS: Temporary segment enqueue(ID2=0)
TS: New block allocation enqueue(ID=1)
lmode(lock mode)Lock mode in which the session holds the lock:
request:Lock mode in which the process requests the lock: 
0 - none
1 - null(NULL)
2 - row-S(SS)
3 - row-X(SX)
4 - share(S)
5 - S/Row-X(SSX)
6 - exclusive(X)

block:
0 - Not blocking any other processes
1 - This lock blocks other processes
2 - global

id1/id2
��TM��ID1Ϊ�����id��ID2Ϊ0
��TX��ID1��ʾ��������ռ�õĻع��κ�
��������ڸûع��ε����������ռ�õĲۺ�
ID2Ϊ��ʾ���ƣ�wrap�����������òۣ�slot�������õĴ���
id1/65536=v$transaction.xidusn
id2=v$transaction.xidsqn
*/

SELECT to_char(sysdate,'yyyymmdd hh24:mi:ss') as curtime,
DECODE(request,0,'Holder: ','Waiter: ')||'$1'||inst_id || ':' || sid sess,
id1, id2, lmode, type,ctime
FROM GV$LOCK
WHERE (id1, id2, type) IN (SELECT id1, id2, type FROM GV$LOCK WHERE request>0)
--and ctime>60
ORDER BY id1, request;



select to_char(sysdate, 'mmdd hh24:mi:ss') as curtime,
       a.sid || ',' || a.serial# as sess,
       a.program,
       a.username,
       to_char(a.logon_time, 'mmdd hh24:mi:ss') as logon_time,
       a.machine || '@' || a.osuser || '@' || a.process as client,
       decode(a.sql_hash_value, 0, a.prev_hash_value, a.sql_hash_value) as hash_value,
       b.event || ':' || b.p1 || ':' || b.p2 as event
  from v$session a, v$session_wait b
 where a.sid = $2
   and a.sid = b.sid;


select * from v$locked_object;



/*Lock Type  
System Type  
BL Buffer hash table instance 
CF Control file schema global enqueue 
CI Cross-instance function invocation instance 
CU Cursor bind 
DF Data file instance 
DL Direct loader parallel index create 
DM Mount/startup db primary/secondary instance 
DR Distributed recovery process 
DX Distributed transaction entry 
FS File set 
HW Space management operations on a specific segment 
IN Instance number 
IR Instance recovery serialization global enqueue 
IS Instance state 
IV Library cache invalidation instance 
JQ Job queue 
KK Thread kick 
LA .. LP Library cache lock instance lock (A..P = namespace) 
MM Mount definition global enqueue 
MR Media recovery 
NA..NZ Library cache pin instance (A..Z = namespace) 
PF Password File 
PI, PS Parallel operation 
PR Process startup 
QA..QZ Row cache instance (A..Z = cache) 
RT Redo thread global enqueue 
SC System change number instance 
SM SMON 
SN Sequence number instance 
SQ Sequence number enqueue 
SS Sort segment 
ST Space transaction enqueue 
SV Sequence number value 
TA Generic enqueue 
TS Temporary segment enqueue (ID2=0) 
TS New block allocation enqueue (ID2=1) 
TT Temporary table enqueue 
UN User name 
US Undo segment DDL 
WL Being-written redo log instance 
*/
