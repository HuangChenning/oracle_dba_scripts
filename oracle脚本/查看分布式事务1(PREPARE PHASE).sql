

select local_tran_id,state from dba_2pc_pending;
--�ֲ�ʽ������commit�ύʱ�򣬻ᾭ��3���׶Σ�

--1.PREPARE PHASE��

--1.1 �����ĸ����ݿ�Ϊcommit point site��
--��ע�������ļ���commit_point_strengthֵ�ߵ��Ǹ����ݿ�Ϊcommit point site��
--1.2 ȫ��Э���ߣ�Global Coordinator��Ҫ�����еĵ�
--����commit point site�⣩����commit����rollback��׼������ʱ���Էֲ�ʽ����ı������
--1.3 ���зֲ�ʽ����Ľڵ㽫����scn��֪ȫ��Э���ߡ�
--1.4 ȫ��Э����ȡ�����������scn��Ϊ�ֲ�ʽ�����scn��

--���ˣ����еĵ㶼�����׼�����������ǿ�ʼ����COMMIT PHASE�׶Σ���ʱ��commit point site�������е�������Ϊin doubt״̬��ֱ��COMMIT PHASE�׶ν�����
--������ݿ��ڴ˽׶γ������⣬���ǲ�ѯ������Զ�����ݿ�Ϊcommit point site���ұ������ݿ�ΪGlobal Coordinator����






--���ص�״̬Ϊcollecting
--���أ�
--1.    select local_tran_id,state from dba_2pc_pending�� 
--2.    LOCAL_TRAN_ID          STATE 
--3.    ---------------------- ---------------- 
--4.    2.12.64845              collecting
--Զ�̣�
--1.    select local_tran_id,state from dba_2pc_pending�� 
--2.    no rows selected

-- stateΪcollecting״̬��ʱ�򣬱�ʾ�������ݿ�Ҫ������������commit����rollback׼��
-- ��������"�ռ�"����������ݿ�ķ�����Ϣ������Զ�����ݿ�δ֪״̬��in doubt��
-- ������Ҫ�����ص�Global Coordinator��״̬�������
-- execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');






--����״̬Ϊprepared

--���أ�
--1.    select local_tran_id,state from dba_2pc_pending�� 
--2.    LOCAL_TRAN_ID          STATE 
--3.    ---------------------- ---------------- 
--4.    2.12.64845             prepared

--Զ�̣�
--1.    select local_tran_id,state from dba_2pc_pending�� 
--2.    no rows selected 
--3.    ����ʾ����Global Coordinator�Ѿ�����׼�����Ѿ����ֲ�ʽ���ŵ���������ı��ϣ�
-- ����Զ�����ݿ��״̬�ٴ�δ֪��in doubt����
-- ������Ҫ�ֹ��Ľ����ص�transaction rollback������������ֲ�ʽ������Ϣ��


--���أ�
--1.    rollback force 'local_tran_id'; 
--2.    execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');
