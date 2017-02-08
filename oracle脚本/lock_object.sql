/*
0 - none
1 - null(NULL)
2 - row-S(SS) 行共享（RS）：共享表锁，sub share
3 - row-X(SX) 行独占（RX）：用于行的修改，sub exclusive
4 - share(S)  共享锁（S）：阻止其他DML操作，share
5 - S/Row-X(SSX) 共享行独占（SRX）：阻止其他事务操作，share/sub exclusive
6 - exclusive(X) 独占(X)：独占访问使用，exclusive
*/
SELECT L.SESSION_ID,
       L.ORACLE_USERNAME,
       L.LOCKED_MODE,
       L.OS_USER_NAME,
       L.PROCESS,
       O.OWNER,
       O.OBJECT_NAME,
       O.OBJECT_TYPE
  FROM V$LOCKED_OBJECT L, DBA_OBJECTS O
 WHERE L.OBJECT_ID = O.OBJECT_ID;
