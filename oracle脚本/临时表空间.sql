/*******************  TEMP tablespace *****************/
Select *
From (Select c.Tablespace_Name,
Sum(Decode(c.Maxbytes, 0, c.Bytes, Maxbytes)) / 1024 / 1024 / 1024 Max_Gb,
Sum(c.Bytes) / 1024 / 1024 / 1024 Temp_Gb
From Dba_Temp_Files c
Group By Tablespace_Name) b;


/*Prompt ******************* USER TEMP TABLESPACE **************************/
Select Tablespace,
       Sum(a.Blocks * b.Value / 1024 / 1024 / 1024) Used_Temp_Gb
  From V$sort_Usage a, V$parameter b
 Where b.Name = 'db_block_size'
 Group By Tablespace;



/*Prompt ***************** USER % TEMP TABLESPACE ****************************/
Select d.Tablespace_Name,
       d.Max_Gb,
       d.Temp_Gb Allocated_Gb,
       d.Temp_Gb - e.Used_Gb Free_Gb,
       (d.Temp_Gb - e.Used_Gb) * 100 / d.Temp_Gb "Alloc_Free%",
       (d.Max_Gb - e.Used_Gb) * 100 / d.Max_Gb "Max_Free%"
  From (Select c.Tablespace_Name,
               Sum(Decode(c.Maxbytes, 0, c.Bytes, Maxbytes)) / 1024 / 1024 / 1024 Max_Gb,
               Sum(c.Bytes) / 1024 / 1024 / 1024 Temp_Gb
          From Dba_Temp_Files c
         Group By Tablespace_Name) d,
       (Select Sum(Nvl(a.Blocks, 0) * b.Value / 1024 / 1024 / 1024) Used_Gb
          From V$sort_Usage a, V$parameter b
         Where b.Name = 'db_block_size'
         Group By a.Tablespace) e;





/*Prompt ****************** ABOUT SESSION WITH USER TEMP tablespace ****************     */                  
Select /*+first_rows*/ s.Sid || ',' || s.Serial# As Sess,
                         s.Username,
                         s.Status,
                         s.Status,
                         Substr(s.Program, 1, 39) Program,
                         s.Osuser || '@' || s.Machine || '@' || s.Process As Client,
                         u.Blocks * b.Value / 1024 / 1024 Sort_Mb,
                         U.TABLESPACE,
                         s.Sql_Hash_Value Hash_Value,
                         s.Osuser,
                         To_Char(s.Logon_Time, 'mm-dd hh24:mi') As Logon_Time
        From V$session s, V$sort_Usage u, V$sqlarea a, V$parameter b
 Where s.Saddr = u.Session_Addr
         And s.Sql_Address = a.Address
         And s.Sql_Hash_Value = a.Hash_Value
         And b.Name = 'db_block_size'; 

/*
我写的脚本
Files_total(MB):临时表空间的总大小
Sort_total(MB):sort_segment中总共可分配的空间
Used(MB):标示为正在使用的临时表空间大小(实际上正在被使用的)
*/
set lines 300
set pages 200
col tablespace_name for a20
col Files_total(MB) for 9999999999999
col Sort_total(MB) for 9999999999999
col Used_blocks(%) for 9999999.99
col real_Used_blocaks(%) for 999999.99
col Used(%) for a10
col Real_Used(%) for a15
/* Formatted on 2011/03/29 10:46 (Formatter Plus v4.8.8) */
SELECT a.tablespace_name,
       b.total_blocks * 8192 / 1024 / 1024 "Files_total(MB)",
       a.total_blocks * 8192 / 1024 / 1024 "Sort_total(MB)",
       used_blocks * 8192 / 1024 / 1024 "Used(MB)",
       free_blocks * 8192 / 1024 / 1024 "Free(MB)",
       TO_CHAR ((used_blocks + free_blocks) / b.total_blocks * 100,'999.99') "Used(%)",
       TO_CHAR (used_blocks / a.total_blocks * 100,'999.99') "Real_Used(%)"
  FROM v$sort_segment a,
       (SELECT tablespace_name, SUM (blocks) total_blocks
            FROM dba_temp_files
        GROUP BY tablespace_name) b
 WHERE a.tablespace_name = b.tablespace_name;
