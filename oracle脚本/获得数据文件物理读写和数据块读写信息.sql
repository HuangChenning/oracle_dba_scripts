select df.tablespace_name tsname,
       df.file_name       "file",
       f.phyrds           pyr,
       f.phyblkrd         pbr,
       f.phywrts          pyw,
       f.phyblkwrt        pbw
from v$filestat f, dba_data_files df where f.file# = df.file_id
order by df.tablespace_name;
