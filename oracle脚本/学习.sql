select to_char(update_TIME, 'yyyymmdd hh24:mi:ss'),
       ERROR_TIME,
       update_ACCEPT,
       UNPAY_NAME,
       SHOULD_ERR,
       update_FLAG,
       update_MONEY,
       update_note
  from dshoulderrmsghis a, sunpaycode b
 WHERE a.ERROR_CODE = b.UNPAY_CODE
   and b.region_code = '01'
   and a.phone_no = '13880885427'
 order by update_time


select * from dshoulderrmsghis where phone_no = '13880885427'


select to_char(update_TIME, 'yyyymmdd hh24:mi:ss'),
       ERROR_TIME,
       update_ACCEPT,
       UNPAY_NAME,
       SHOULD_ERR,
       update_FLAG,
       update_MONEY,
       update_note
  from dshoulderrmsghis a, sunpaycode b
 WHERE a.ERROR_CODE = b.UNPAY_CODE
   and b.region_code = '01'
   and a.phone_no = '13880885427'
 order by update_time


select * from dshoulderrmsghis where  update_ACCEPT ='413059524'

select * from dshoulderrmsghis where region_code = '01'


select to_char(a.contract_no), a.bank_cust, c.begin_ymd, c.end_ymd
  from dConMsg a, dCustMsg b, dConUserMsg c
 where a.contract_no = c.contract_no
   and c.serial_no = 0
   and b.phone_no = '13880885427'
   and substr(b.run_code, 2, 1) < 'a'
   and b.id_no = c.id_no


select *
  from dConMsg a, dCustMsg b, dConUserMsg c
 where a.contract_no = c.contract_no
   and c.serial_no = 0
   and b.phone_no = '13880885427'
   and substr(b.run_code, 2, 1) < 'a'
   and b.id_no = c.id_no
   


select jsp_name,function_name from sfunccode where function_code='1376'
select * from  sfunccode where function_code='1376'


select *
  from (SELECT a.FUNCTION_CODE, b.function_name
          FROM dfunclogin a, sfunccode b
         WHERE a.FUNCTION_CODE = b.function_code
           and USE_LOGINNO = 'aagh5F'
           and LOGIN_TYPE = '1'
         order by LOGIN_TIME desc)
 where rownum < 11


select to_char(update_TIME, 'yyyymmdd hh24:mi:ss'),
       ERROR_TIME,
       update_ACCEPT,
       UNPAY_NAME,
       SHOULD_ERR,
       update_FLAG,
       update_MONEY,
       update_note
  from dshoulderrmsghis a, sunpaycode b
 WHERE a.ERROR_CODE = b.UNPAY_CODE
   and b.region_code = '01'
   and a.phone_no = '13880885427'
 order by update_time



select to_char(a.contract_no), a.bank_cust, c.begin_ymd, c.end_ymd,b.id_no
  from dConMsg a, dCustMsg b, dConUserMsg c
 where a.contract_no = c.contract_no
   and c.serial_no = 0
   and b.phone_no = '13880885427'
   and substr(b.run_code, 2, 1) < 'a'
   and b.id_no = c.id_no


select * from dCustMsg where phone_no = '13880885427'

select * from dconusermsg where id_no = '14011055846'

select to_char(a.contract_no), a.bank_cust, c.begin_ymd, c.end_ymd,b.id_no
  from dConMsg a, dCustMsg b, dConUserMsg c
 where a.contract_no = c.contract_no
   and c.serial_no = 0
   and b.phone_no = :phoneno
   and substr(b.run_code, 2, 1) < 'a'
   and b.id_no = c.id_no


select to_char(update_TIME, 'yyyymmdd hh24:mi:ss'),
       ERROR_TIME,
       update_ACCEPT,
       UNPAY_NAME,
       SHOULD_ERR,
       update_FLAG,
       update_MONEY,
       update_note
  from dshoulderrmsghis a, sunpaycode b
 WHERE a.ERROR_CODE = b.UNPAY_CODE
   and b.region_code = '01'
   and a.phone_no = '13880885427'
 order by update_time

select * from dShouldErrMsg



                
select * from dshoulderrmsg where phone_no = '13608176991' 
select * from dshoulderrmsg where phone_no ='13880885427'

select count(*),phone_no from dshoulderrmsg where should_err > 200 having count(*)>5 group by phone_no

select * from dshoulderrmsg where phone_no = '13688101569 '

select * from sunpaycode




select id_no,sm_code,belong_code
        into :in_id_no,:sm_code,:belong_code
        from dCustMsg
        where phone_no=:in_phone_no;
        if (SQLCODE != 0)
        {
                sprintf(return_code, "%06d", 130100);
                printf("\n[%s]dSimMsg出错[%d],[%s]",return_code,SQLCODE,SQLERRMSG);
                goto end_Apply;
        }


select * from dcustmsg where phone_no = '13608176991'




select TOTAL_DATE,ERROR_TIME,LOGIN_ACCEPT,ERROR_CODE,SHOULD_ERR,unpay_name,
                a.error_msg,a.op_note,nvl(a.err_begin_date,'unknown')||'~'||nvl(a.err_end_date,'unknown'),nvl(a.ERR_SERIAL,'null')
                from  dShouldErrMsg a,sUnPayCode b
        where id_no='14011055846' and contract_no = '14011055847'
        and a.error_code=b.unpay_code
                and a.region_code=b.region_code
                order by total_date;

                
             select id_no from dshoulderrmsg where region_code = '01' and sm_code = 'qq'
 
 select * from dcustmsg 
 where phone_no in (select phone_no from dshoulderrmsg where region_code = '01' and sm_code = 'qq') 
 
 
 select * from dshoulderrmsg
 
 select * from dshoulderrmsg where phone_no in (select phone_no from dcustmsg where sm_code = 'qq')
 
 select * from dshoulderrmsg where phone_no = '13880885427'
 select * from dshoulderrmsg where sm_code = 'z1' and error_code ='02'
  
  select * from ssmcode where region_code = '01' and sm_name like'神州%'
  
  select * from dshoulderrmsg
  
  select * from dshoulderrmsg where phone_no = '13708011428 ' 
  select * from dcustmsg where id_no = '12021457039'
  
  select * from ssmcode where sm_name like '动感%'
  
 select count(*),phone_no from dshoulderrmsg where sm_code = 'dn' group by phone_no having count(*) > 5 order by count(*)
  
  select * from dshoulderrmsg where sm_code in ( select sm_code from ssmcode where sm_name like '神州%' )
  
  
  
  select * from dShouldErrMsg
  
  select * from sregioncode
