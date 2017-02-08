select MEMBER_LEVEL,PACK_NUM,BAK_VALUE,to_char(CREATE_TIME,'yyyymmdd hh24:mi:ss'),LOGIN_NO,OP_FLAG from dWMusicUser where phone_no='13880954256'


select a.cust_name from dcustdoc a,dcustmsg b where a.cust_id=b.cust_id and b.phone_no='13880954256'


select * from dcustmsg where phone_no = '13708267551'
select * from dcustdoc where cust_id ='12026268232'
/*
查看电话号码*/
select * from dcustdoc where cust_id = (select cust_id from dcustmsg where phone_no = '13')


select to_char(title_number),
       to_char(op_time, 'YYYYMMDD'),
       title_name,
       info
  from supgradeinfo
 where op_type = '00'
   and (region_code = '00' or region_code ='01')
   and op_code = '1526'
   and use_flag = 'Y'
   and begin_time < sysdate
   and end_time > sysdate
 order by op_time desc
