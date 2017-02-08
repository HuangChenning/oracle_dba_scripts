SELECT 'crmc2',
       TO_CHAR(SYSDATE, 'mmdd hh24:mi:ss') AS CURTIME,
       POOL,
       NAME,
       ROUND(BYTES / 1024 / 1024) AS SHMEM
  FROM V$SGASTAT
 WHERE NAME LIKE 'free%'
   AND POOL = 'shared pool';
   
/*
�������Ҫ�ֳ������֣�library cache��dictionary cache��
library cache����Ҫ�洢����ִ�е�һЩSQL����䣬plsql���ȣ�
��dictionary cache����Ҫ�洢�������ݿ��һЩ�����ֵ���Ϣ��
library cache�б䶯�����ݽ϶࣬��dictionary cache���������˵�ȽϹ̶���
һ����˵share poolռ���ʸ߶���sql���£�����share pool���ռ�ù��ߣ�
����ֱ�Ӳ鿴���SQL
*/   
---ͨ�������sql��ѯռ��share pool�ڴ����10M��SQL��
SELECT SUBSTR(SQL_TEXT, 1, 100) "Stmt",
       COUNT(*),
       SUM(SHARABLE_MEM)/1024/1024 "Mem(Mb)",
       SUM(USERS_OPENING) "Open",
       SUM(EXECUTIONS) "Exec"
  FROM V$SQL
 GROUP BY SUBSTR(SQL_TEXT, 1, 100)
HAVING SUM(SHARABLE_MEM) > 10000000;





/*�鿴share_pool���ӻ����*/
select addr, name, gets, misses, spin_gets
  from v$latch_children
 where name = 'shared pool';


/*share pool�ռ�ķ����ʹ����������Ը����ڲ���ͼx$ksmsp���۲�
[K]ernal [S]torage [M]emory Management [S]GA Hea[P]
ksmchcom:ע���ֶΣ�ÿ���ڴ�鱻�����Ժ�ע�ͻ�����ڸ��ֶ���
ksmchsiz:������С
ksmchcls:�������ͣ���Ҫ��4��
    free:free Chunks:�������κζ����Chunk�����Բ������Ƶı����ɷ���
    recreate��Recreatable Chunks���������Ա���ʱ�Ƴ��ڴ�Ķ�������Ҫ
             ��ʱ�����������Ա����´��������磬���洢����SQL����
             ���ڴ涼�ǿ����ؽ���
    freeable��Freeable Chunks������session���ڻ���õĶ����������ͷš�
              �ⲿ���ڴ���ʱ�����ȫ�����򲿷���ǰ�ͷš�����ע�⣬����ĳЩ
              �������м���̲����ģ���Щ�����ܱ��Ƴ��ڴ�
    perm��Permanent Memory Chunks���������ö���ͨ�����ܶ����ͷš�
    
    
    
    alter system flush shared_pool;
*/

select * from x$ksmsp;


/*
��ѯv$shared_pool_reserved��ͼ�����жϹ�������������ԭ��

���request_failures>0��last_failure_size>shared_pool_reserved_min_alloc��
��ôORA-04031����Ϳ�������Ϊ����ر����ռ�ȱ�������ռ����¡�
Ҫ���������⣬���Կ��ǼӴ�shared_pool_reserved_min_alloc�����ͻ��������
�ر����ռ�Ķ�����Ŀ��������shared_pool_reserved_size��shared_pool_size���Ӵ�
����ر����ռ�Ŀ����ڴ�


���request_failures>0��last_failure_size < shared_pool_reserved_min_alloc��
����request_failure = 0��last_failure_size < shared_pool_reserved_min_alloc��
��ô�������ڿ���ٻ���ȱ�������ռ������0RA-04031���󣬶����������Ӧ�ÿ���
����shared_pool_reserved_min_alloc,�Է������Ķ��󵽹���ر����ռ��в��Ӵ�
shared_pool_size
*/
select free_space,
       avg_free_size,
       used_space,
       avg_used_size,
       request_failures,
       last_failure_size
  from v$shared_pool_reserved;


/*
ʹ��dbms_shared_pool.keepϵͳ�����԰�ָ������pin���ڴ���,
Ҫʹ��dbms_shared_poolϵͳ��������Ҫ����dbmspool.sql,�ýű�
���Զ�����prvtpool.plb�ű������������
*/


/*
�鿴��ǰ�Ự�е� library Cache pin
Library Cache Pin�Ĳ������£�
P1��KGL Handle address��Library Cache Handle Address��
P2��Pin address
P3��Encoded Mode & Namespace

Pn�ֶ���ʮ���Ʊ�ʾ��PnRAW�ֶ���ʮ�����Ʊ�ʾ
ͨ��p1��ַ����ѯx$kglob.kglhdadr��ͼ�Ϳ��Եõ�����ľ�����Ϣ
x$kglob�����ƺ���[K]ernel [G]eneric [L]ibrary Cache Manager [OB]ject
�����kglnahsh��������Hash value���ɴ˿�֪����pining������������
library cache pin�ĵȴ�

v$session_wait.p1raw=x$kglob.kglhdadr
*/

select sid, seq#, event, p1, p1raw, p2, p2raw, p3, p3raw, state
  from v$session_wait
 where event like 'library%';


select addr, kglhdadr, kglhdpar, kglnaown, kglnaobj, kglnahsh, kglhdobj
  from x$kglob
 where kglhdadr = ''

/*
x$kglpn��[K]ernel [G]eneric [L]ibrary Cache Manager object [P]i[N]s
x$kglpn.kgpnhdl=x$kglob.kglhdadr=v$session_wait.p1raw
ͨ������v$session�����Ի�õ�ǰ���и�handle���û���Ϣ
*/

select a.sid,a.username,a.program,a.sql_hash_value,a.sql_address,b.addr,b.kglpnadr,b.kglpnuse,b.kglpnses,b.kglpnhdl,
b.kglpnlck,b.kglpnmod,b.kglpnreq
from v$session a,x$kglpn b
where a.saddr=b.kglpnuse and b.kgpnhdl='' and b.kglpnmod<>0;


/*
�õ�SID���Ϳ���ͨ��v$session.sql_hash_value\v$session.sql_address���ֶι���v$sqltext��v$sqlarea����ͼ
��õ�ǰsession����ִ�еĲ���
*/
select sql_text from v$sqlarea a where a.hash_value='';
