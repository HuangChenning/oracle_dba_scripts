

select * from dba_objects o where o.object_name ='ACCT_HOST_ROUTE';





select owner,
       segment_name,
       segment_type,
       tablespace_name,
       file_id,
       block_id,
       blocks
  from dba_extents
 where segment_name =('DCUSTMSG_PHONENO2')
   and file_id =1599
   and 225007 between block_id and block_id+ blocks -1;
   
   
   


select * from dba_data_files where file_name ='/dev/racc_data1633lv';


select * from dba_segments s where s.segment_name='SP_ACCT_HOST_ROUTE';


select distinct a.route_seg
  from acct_host_route a, dcustmsg b
 where a.route_seg = substr(b.phone_no, 1, 7)
   and a.acct_home = '/account2';


select * from dba_indexes i where i.index_name='DCUSTMSG_PHONENO_HEAD'

/*
select \*+ parallel(a,16)*\ count(*) from dcustmsg;
select \*+ parallel(a,16) index(a,DCUSTMSG_PHONENO2)*\ count(phone_no) from DCUSTMSG a;
*/

---DBCUSTADM.DCUSTMSG_PHONENO_HEAD (SUBSTR(PHONE_NO,1,7))   ±íÃû£ºDBCUSTADM.DCUSTMSG
