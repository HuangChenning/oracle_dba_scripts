

select local_tran_id,state from dba_2pc_pending;
--分布式事务在commit提交时候，会经历3个阶段：

--1.PREPARE PHASE：

--1.1 决定哪个数据库为commit point site。
--（注，参数文件中commit_point_strength值高的那个数据库为commit point site）
--1.2 全局协调者（Global Coordinator）要求所有的点
--（除commit point site外）做好commit或者rollback的准备。此时，对分布式事务的表加锁。
--1.3 所有分布式事务的节点将它的scn告知全局协调者。
--1.4 全局协调者取各个点的最大的scn作为分布式事务的scn。

--至此，所有的点都完成了准备工作，我们开始进入COMMIT PHASE阶段，此时除commit point site点外所有点的事务均为in doubt状态，直到COMMIT PHASE阶段结束。
--如果数据库在此阶段出现问题，我们查询（假设远程数据库为commit point site，且本地数据库为Global Coordinator）：






--本地的状态为collecting
--本地：
--1.    select local_tran_id,state from dba_2pc_pending； 
--2.    LOCAL_TRAN_ID          STATE 
--3.    ---------------------- ---------------- 
--4.    2.12.64845              collecting
--远程：
--1.    select local_tran_id,state from dba_2pc_pending； 
--2.    no rows selected

-- state为collecting状态的时候，表示本地数据库要求其他点做好commit或者rollback准备
-- 现在正在"收集"其他点的数据库的返回信息，但是远程数据库未知状态（in doubt）
-- 我们需要将本地的Global Coordinator的状态清除掉：
-- execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');






--本地状态为prepared

--本地：
--1.    select local_tran_id,state from dba_2pc_pending； 
--2.    LOCAL_TRAN_ID          STATE 
--3.    ---------------------- ---------------- 
--4.    2.12.64845             prepared

--远程：
--1.    select local_tran_id,state from dba_2pc_pending； 
--2.    no rows selected 
--3.    即表示本地Global Coordinator已经做好准备，已经将分布式锁放到各个事务的表上，
-- 但是远程数据库的状态再次未知（in doubt），
-- 我们需要手工的将本地的transaction rollback掉，并且清除分布式事务信息：


--本地：
--1.    rollback force 'local_tran_id'; 
--2.    execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('local_tran_id');
