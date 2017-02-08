/*V$ACCESS displaysinformation about locks that 
are currently imposed on library cache objects.
The locks are imposed to ensure that they are 
not aged out of the library cachewhile they are required for SQL execution.*/

select * from v$access;

/*
library cache pinͨ���Ƿ����ڱ�������±���PL/SQL��view��types��objectʱ��
�ڴ�����library cache pin����������ܱ��������ʱ��Ӧ���object��Ч�����ԭ��
ͨ��object��'last_ddl'���Կɿ�����Щ�仯��

object�����Чʱ��oracle���ڵ�һ�η��ʴ�objectʱ��ͼȥ���±������������ʱ����session
�Ѿ��Ѵ�object pin��library cache�У��ͻ�������⣬�ر����д����session���Ҵ��ڽϸ���
��dependenceʱ
*/

-----------����һ��
/*
�鿴library cache�ĻỰ������PnRAWΪ16����,seq#����ȴ��Ĵ���(�ȴ�3��ʹ���ʱ)
p1����Library Cache Handle Address
*/
select * from v$session_wait where event like 'library cache%';

select sid,seq#,event,p1,p1raw,p2,p2raw,state from v$session_wait where event like 'library cache%';

/*
x$kglpn��X$KGLPN -- [K]ernel [G]eneric [L]ibrary Cache Manager object [p]i[N]s
������x$kgllk���Ӧ�ı��ǹ���pin�������Ϣ������Ҫ���ڽ��library cache pin
v$session_wait�е�p1_raw��x$kglpn�е�kglpnhdl����

����
desc x$kglpn
 Name       
 -----------
 ADDR       
 INDX       
 INST_ID    
 KGLPNADR   
 KGLPNUSE   �Ự��ַ(��Ӧv$session��saddr)
 KGLPNSES   owner��ַ
 KGLPNHDL   ���
 KGLPNLCK   
 KGLPNCNT   
 KGLPNMOD   ����pin��ģʽ(0Ϊno lock/pin held,1Ϊnull��2Ϊshare��3Ϊexclusive)
 KGLPNREQ   ����pin��ģʽ(0Ϊno lock/pin held,1Ϊnull��2Ϊshare��3Ϊexclusive)
 KGLPNDMK   
 KGLPNSPN   ��Ӧ�����ļ���savepoint��ֵ
 
�鿴session��ռ��pin��(kglpnmod=3),����session���ȴ���pin��(KGLPNREQ=2)
*/
select addr,
       indx,
       kglpnadr,
       kglpnuse,
       kglpnses,
       kglpnhdl,
       kglpnlck,
       kglpnmod,
       kglpnreq
  from x$kglpn
 where kglpnhdl like '%0700001C1DC80128%' ��


/*
X$KGLOB---[K]ernel [G]eneric [L]ibrary Cache Manager [OB]ject
���øû������ͼ�У�
GV$ACCESS\GV$OBJECT_DEPENDENCY\GV$DB_OBJECT_CACHE\
GV$DB_PIPES\DBA_LOCK_INTERNAL\DBA_DDL_LOCKS

��ѯx$kglob(Library Cache Object)��
���ҵ���ص�object����SQL�������
v$session_wait�е�p1_raw��x$kglob�е�kglhdadr����
KGLNAOBJ:���object������
*/
select * from x$kglob where kglhdadr like '0700001C1DC80128%';


/*��v$session��saddrl��x$kglpn��KGLPNUSE����������ѯv$session_wait��
���ɲ��ռ��pin����sessionĿǰ������ʲô*/
SELECT a.sid,
       a.username,
       a.program,
       b.kglpnadr,
       b.kglpnuse,
       b.kglpnses,
       b.kglpnhdl,
       b.kglpnlck,
       b.kglpnmod,
       b.kglpnreq
  from v$session a, x$kglpn b
 where a.saddr = b.KGLPNUSE
   and b.kglpnhdl like '0700001C1DC80128%'
   and b.KGLPNMOD <> 0;


/*�鿴�û����ڵȴ�ʲô*/
select * from v$session_wait where sid=<sid>;

/*�����������ִ�е�SQL���*/
select sid,sql_text
from v$session,v$sqlarea
where v$session.sql_address=v$sqlarea.address
and sid=;



---------��������
/*ͨ��v$session_wait�ҵ����ڵȴ�"library cache pin"��session(���ȴ���)��
��SQL������£�*/

select sid waiter, p1raw, p1text, p2raw, p2text
  from v$session_wait
 where wait_time = 0
   and event like 'library cache pin%';
   
   
/*ͨ����ѯdba_lock_internal��v$session_wait��
�ɵõ���"library cache pin"����ص�object�����֣���SQL������£�*/
select session_id,
       lock_type,
       lock_id1,
       mode_held,
       mode_requested,
       lock_id2 lock_addr
  from dba_lock_internal
 where mode_requested <> 'None'
   and mode_requested <> mode_held
   and session_id in (select sid
                        from v$session_wait
                       where wait_time = 0
                         and event like 'library cache pin%')
                         


/*
���"library cache pin"ռ���ߣ��������ߣ���session id,
��SQL������£�
*/
select sid holder, kglpnuse Sess, kglpnmod held, kglpnreq req
  from x$kglpn, v$session
 where kglpnhdl in (select p1raw
                      from v$session_wait
                     where wait_time = 0
                       and event like 'library cache pin%')
   and kglpnmod <> 0
   and v$session.saddr = x$kglpn.kglpnuse;
   
/*
���"library cache pin"ռ����(������)���ڵ�ʲô��
*/
select sid, substr(event, 1, 30), wait_time
  from v$session_wait
 where sid in (select sid
                 from x$kglpn, v$session
                where KGLPNHDL in
                      (select p1raw
                         from v$session_wait
                        where wait_time = 0
                          and event like 'library cache pin%')
                  and kglpnmod <> 0
                  and v$session.saddr = x$kglpn.kglpnuse)
                  

/*�����������ִ�е�SQL���*/
select sid,sql_text
from v$session,v$sqlarea
where v$session.sql_address=v$sqlarea.address
and sid=;


/*
lock��Ҫ������ģʽ: Null,share(2),Exclusive(3).
�ڶ�ȡ���ʶ���ʱ,ͨ����Ҫ��ȡNull(��)ģʽ�Լ�share(����)ģʽ������.
���޸Ķ���ʱ,��Ҫ���Exclusive(����)����.

ͬ��pin������ģʽ,Null,shared(2)��exclusive(3).
ֻ��ģʽʱ��ù���pin,�޸�ģʽ�������pin.

ģʽΪshared(2)��pin�������κ�exclusive(3)��pin����
ģʽΪshared(3)��pinҲ�������κ�exclusive(2)��pin����

��ͬ�Ĳ�����Զ�������ͬ��lock/pin
1�����е�DDL����Ա�����Ķ��������������͵�lock��pin

2��
��Ҫ��һ�����̻��ߺ������б���ʱ����Ҫ��library cache��pin�ö���
��pin�ö�����ǰ����Ҫ��øö���handle�������������ȡʧ�ܣ��ͻ����library cache lock�ȴ���
����ɹ���ȡhandle��lock���������library cache��pin�ö���
���pin����ʧ�ܣ�������library cache pin�ȴ���
����Ǵ洢���̻��ߺ���������������Ϊ���������library cache lock�ȴ���
��һ������library cache pin�ȴ������������������library cache pin�ȴ���
��һ�������library cache lock�ȴ���
������Ǳ�����ģ���һ��ֻ��library cache lock�ȴ�����һ������library cache pin��

���ܷ���library cache pin��library cache lock�������
1���ڴ洢���̻��ߺ�����������ʱ�����롣
2���ڴ洢���̻��ߺ�����������ʱ�������ǽ�����Ȩ�������Ƴ�Ȩ�޵Ȳ�����
3����ĳ����ִ��DDL�ڼ䣬������ĻỰ�Ըñ�ִ��DML����DDL��
4��PL/SQL����֮����ڸ��ӵ�������

ÿ����ʹ�û��޸��Ѿ�locked/pin�Ķ����SQL���,����ȴ��¼�'library cache pin'��'library cache lock'ֱ����ʱ.
��ʱ,ͨ��������5���Ӻ�,Ȼ��SQL�������ORA-4021�Ĵ���.�����������,������ORA-4020����

*/


/*library cache pin
��ѯv$session_wait��ͼ��library cache pin��Ӧ��P1��P2��P3
P1 = Handle address
�����������library cache pin�ȴ��Ķ���pin��library cache�е�handle��һ����P1RAW(ʮ������)����p1(ʮ����)
����������sql��ѯ�Ǹ��û��µ��Ǹ��������ڱ�����pin��
SELECT kglnaown "Owner", kglnaobj "Object"
FROM x$kglob
WHERE kglhdadr='&P1RAW'
; 
���ص�OBJECT�����Ǿ���Ķ���Ҳ������һ��SQL��

P2 = Pin address
�����pin��ַ��һ����P2RAW(ʮ������)����P2(ʮ����)

P3 = Encoded Mode & Namespace 
*/




