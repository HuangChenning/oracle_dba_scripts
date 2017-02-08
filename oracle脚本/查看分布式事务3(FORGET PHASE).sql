-- 3.FORGET PHASE：
-- 
--3.1 参与的点通知commit point site他们已经完成commit，
-- commit point site就能忘记（forget）这个事务。
--3.2 commit point site在远程数据库上清除分布式事务信息。
--3.3 commit point site通知Global Coordinator可以清除本地的分布式事务信息。
--3.4 Global Coordinator清除分布式事务信息。

--此时如果出现问题，我们查询：
--本地：
--1.	select local_tran_id,state from dba_2pc_pending； 
--2.	LOCAL_TRAN_ID          STATE 
--3.	---------------------- ---------------- 
--4.	2.12.64845            commited

--远程：
--1.	select local_tran_id,state from dba_2pc_pending； 
--2.	no rows selected


--即远程commit point site已经完成commit，
--通知Global Coordinator清除本地的分布式事务信息，
--但是Global Coordinator没有收到该信息。我们需要这样处理：

--本地：
--1.	execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');
