--2.COMMIT PHASE��

--2.1 Global Coordinator�����scn����commit point site��Ҫ����commit��
--2.2 commit point����commit����rollback���ֲ�ʽ�������ͷš�
--2.3 commit point֪ͨGlobal Coordinator�Ѿ�commit��
--2.4 Global Coordinator֪ͨ�ֲ�ʽ��������е����commit��


--������ݿ��ڴ˽׶γ������⣬���ǲ�ѯ

--���أ�
--1.    select local_tran_id,state from dba_2pc_pending�� 
--2.    LOCAL_TRAN_ID          STATE 
--3.	---------------------- ---------------- 
--4.	2.12.64845             prepared
--Զ�̣�
--1.	select local_tran_id,state from dba_2pc_pending�� 
--2.	LOCAL_TRAN_ID          STATE 
--3.	---------------------- ---------------- 
--4.	1.92.66874             commited


--��Զ�����ݿ�����Ѿ�commit�����Ǳ���Global Coordinatorδ֪Զ�����ݿ��״̬��
--���Ǵ���prepare��״̬��������Ҫ�����´���


--���أ�
--1.	commit force 'local_tran_id'; 
--2.	execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');
--Զ�̣�
--1.	execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');



--���������ڲ�ѯ��ʱ���������µ�״̬��

--���أ�
--1.	select local_tran_id,state from dba_2pc_pending�� 
--2.	LOCAL_TRAN_ID          STATE 
--3.	---------------------- ---------------- 
--4.	2.12.64845            commited

--Զ�̣�
--1.	select local_tran_id,state from dba_2pc_pending�� 
--2.	LOCAL_TRAN_ID          STATE 
--3.	---------------------- ---------------- 
--4.	1.92.66874             commited

--��Զ�����ݿ�ͱ������ݿ���Ѿ����commit�����Ƿֲ�ʽ�������Ϣ��δ�����
--������Ҫ�ڱ��غ�Զ�����У�

--���أ�
--1.	execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');

--Զ�̣�
--1.	execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');

