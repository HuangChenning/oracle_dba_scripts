SELECT /*+ ORDERED */
 S.KSUSEMNM "O_HOSTNAME",
 S.KSUSEPID "O_SPID", --操作dblink用户信息  
 G.K2GTITID_ORA "O_TXID",  --global transaction
 S.INDX "S_SID",
 S.KSUSESER "S_SERIAL#", --dblink session信息  
 DECODE(BITAND(KSUSEIDL, 11),
        1,
        'ACTIVE',
        0,
        DECODE(BITAND(KSUSEFLG, 4096), 0, 'INACTIVE', 'CACHED'),
        2,
        'SNIPED',
        3,
        'SNIPED',
        'KILLED') "S_STATUS",
 S.KSUUDNAM "DBLINK_USER"
  FROM SYS.X$K2GTE G, SYS.X$KTCXB T, SYS.X$KSUSE S
 WHERE G.K2GTDXCB = T.KTCXBXBA
   AND G.K2GTDSES = T.KTCXBSES
   AND S.ADDR = G.K2GTDSES;
