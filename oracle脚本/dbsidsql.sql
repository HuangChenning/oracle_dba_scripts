------���hash_value ��ֵ

select decode(sql_hash_value,0,prev_hash_value,sql_hash_value) hash_value_p from v$session where sid=;

----ͨ��hash_value��ֵ���鿴��sql�����ʲô
select sql_text
from v$sqltext
where HASH_VALUE = 
order by piece
