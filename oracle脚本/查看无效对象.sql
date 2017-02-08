select a.owner,
       a.object_name,
       a.object_type,
       to_char(a.created,'yyyy-mm-dd hh24:MI:SS') created,
       to_char(a.last_ddl_time, 'yyyy-mm-dd hh24:MI:SS') last_ddl,
       a.status
  from dba_objects a
 where  owner = upper('PUBLIC')
        and status = 'INVALID'
      and object_name in
          ('DBA_HIST_FILESTATXS','DBA_HIST_SQLSTAT')
   and object_type in ('FUNCTION', 'PROCEDURE', 'PACKAGE');


--ALARM_IVR_COMPARE_OLD_NEW
--ALARM_IVR_COMPARE_NEW_OLD


alter PROCEDURE DAPP.P_AP_SJ045 compile;

/*查看索引无效*/
select owner,index_name, compression, status,partitioned
  from dba_indexes
 where status='UNUSABLE' and index_name = 'IDX_MD_PAR_BRAND_DAILY';


alter index DBACCADM.IDX_DEXTFEE1_A rebuild online;

select bytes/1024/1024 from dba_segments where segment_name='IDX_DEXTFEE1_A'

select * from dba_objects where object_name ='DCHNGSMDATA201202_MS'

select * from dba_objects where object_type like 'SYNON%' and owner='';


/*dbindex的脚本

set lines 200
set pages 500
col owner for a10
col indexname for a30
col ANALYZED for a20
col columnname for a20
col bytes for a10
col tablespacename for a15
col temp for a4
set feedback off
set serveroutput on
variable i_index_name varchar2(30);
BEGIN
:i_index_name :=upper('$2');
END;
/

Select a.Owner Owner,
       a.table_name Tablename,
       a.Index_name Indexname,
       To_Char(a.Last_Analyzed, 'YYYY-MM-DD HH24:Mi:ss') Analyzed,
       a.Partitioned Partition,
       a.temporary temp,
       Bytes || 'M' bytes,
       a.pct_free,
       a.ini_trans
  From Dba_Indexes a,
       (Select b.Segment_Name Segment_Name, Sum(b.Bytes / 1024 / 1024) Bytes
          From Dba_Segments b
         Where b.Segment_Name = :i_index_name
         Group By Segment_Name) c
 Where a.Index_Name = c.Segment_Name;
 
Select b.Index_Owner     Owner,
       b.Index_Name      Indexname,
       b.Column_Name     Columnname,
       b.Column_Position Columnpost,
       a.Tablespace_Name Tablespacename
  From Dba_Indexes a, Dba_Ind_Columns b
 Where a.Index_Name = :i_index_Name
   And b.Index_Name = a.Index_Name
 order by Indexname
*/
