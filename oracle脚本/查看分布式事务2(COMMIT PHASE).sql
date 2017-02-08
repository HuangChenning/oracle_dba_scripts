--2.COMMIT PHASE：

--2.1 Global Coordinator将最大scn传到commit point site，要求其commit。
--2.2 commit point尝试commit或者rollback。分布式事务锁释放。
--2.3 commit point通知Global Coordinator已经commit。
--2.4 Global Coordinator通知分布式事务的所有点进行commit。


--如果数据库在此阶段出现问题，我们查询

--本地：
--1.    select local_tran_id,state from dba_2pc_pending； 
--2.    LOCAL_TRAN_ID          STATE 
--3.	---------------------- ---------------- 
--4.	2.12.64845             prepared
--远程：
--1.	select local_tran_id,state from dba_2pc_pending； 
--2.	LOCAL_TRAN_ID          STATE 
--3.	---------------------- ---------------- 
--4.	1.92.66874             commited


--即远程数据库可能已经commit，但是本地Global Coordinator未知远程数据库的状态，
--还是处于prepare的状态。我们需要在如下处理：


--本地：
--1.	commit force 'local_tran_id'; 
--2.	execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');
--远程：
--1.	execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');



--或者我们在查询的时候发现是如下的状态：

--本地：
--1.	select local_tran_id,state from dba_2pc_pending； 
--2.	LOCAL_TRAN_ID          STATE 
--3.	---------------------- ---------------- 
--4.	2.12.64845            commited

--远程：
--1.	select local_tran_id,state from dba_2pc_pending； 
--2.	LOCAL_TRAN_ID          STATE 
--3.	---------------------- ---------------- 
--4.	1.92.66874             commited

--即远程数据库和本地数据库均已经完成commit，但是分布式事务的信息尚未清除，
--我们需要在本地和远程运行：

--本地：
--1.	execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');

--远程：
--1.	execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');

