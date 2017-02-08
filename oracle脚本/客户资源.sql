
select '89868888220474'||trim(a.region_code)||trim(to_char(rownum,'0000')),'468888480'||trim(a.region_code)||trim(to_char(rownum,'0000')),'15888'||trim(a.region_code),'10650','0',
b.group_id,a.region_code,'99','999','zzzzzz','2212',sysdate,'uadmin',
'60384798702','20080115','',a.sm_code ,c.INLAND_TOLL	 ,c.innet_name
from snotypecode  a,dchngroupmsg b,sInnetCode c
where b.boss_org_code(+)=a.region_code||'99'||'999'
  and a.region_code=c.region_code
  and  a.sm_code=c.sm_code 
  and c.power_right <= 8
   and c.allow_flag = 'Y';
  select * from sInnetCode 

select '15888'||trim(a.region_code)||trim(to_char(rownum,'0000')),no_type,'no_value','novalue','0','0.0000',
a.region_code,'99','999',sysdate,sysdate,'0.00',
'eeqc16','050501016','815655','20030218','0','zzzzzz',b.group_id,''---,c.innet_name
from snotypecode  a,dchngroupmsg b,sInnetCode c  
where b.boss_org_code(+)=a.region_code||'99'||'999'
  and a.region_code=c.region_code


select a.sm_code||'->'||a.sm_name,'15888'||trim(a.region_code)||trim(to_char(rownum,'0000')), '89868888220474'||trim(a.region_code)||trim(to_char(rownum,'0000')),c.INLAND_TOLL	 ,c.innet_name
from snotypecode  a,dchngroupmsg b,sInnetCode c
where b.boss_org_code(+)=a.region_code||'99'||'999'
  and a.region_code=c.region_code
  and  a.sm_code=c.sm_code 
  and c.power_right <= 8
   and c.allow_flag = 'Y';
  select * from sInnetCode 


select * from sInnetCode


