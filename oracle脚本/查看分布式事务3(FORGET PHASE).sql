-- 3.FORGET PHASE��
-- 
--3.1 ����ĵ�֪ͨcommit point site�����Ѿ����commit��
-- commit point site�������ǣ�forget���������
--3.2 commit point site��Զ�����ݿ�������ֲ�ʽ������Ϣ��
--3.3 commit point site֪ͨGlobal Coordinator����������صķֲ�ʽ������Ϣ��
--3.4 Global Coordinator����ֲ�ʽ������Ϣ��

--��ʱ����������⣬���ǲ�ѯ��
--���أ�
--1.	select local_tran_id,state from dba_2pc_pending�� 
--2.	LOCAL_TRAN_ID          STATE 
--3.	---------------------- ---------------- 
--4.	2.12.64845            commited

--Զ�̣�
--1.	select local_tran_id,state from dba_2pc_pending�� 
--2.	no rows selected


--��Զ��commit point site�Ѿ����commit��
--֪ͨGlobal Coordinator������صķֲ�ʽ������Ϣ��
--����Global Coordinatorû���յ�����Ϣ��������Ҫ��������

--���أ�
--1.	execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');
