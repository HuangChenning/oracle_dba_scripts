/*
aggregate PGA target parameter  pga_aggregate_target
aggregate PGA auto target       ʣ����ܱ�������ʹ�õ��ڴ�(pga_aggregate_target - �������ڴ�)
global memory bound             ����SQL������õ����ڴ�
total PGA inuse                 ���ڱ����ĵ�pga(����workarea pl/sql������ռ�õ�pga)
total PGA allocated             ��ǰʵ���ѷ����PGA�ڴ�������
һ����˵���ֵӦ��С��pga_aggregate_target��
����������������PGA�����������������ڳ���pga_aggregate_target���޶�ֵ

maximum PGA allocated           pga�������ŵ������ֵ
total freeable PGA memory       ���ͷŵ�pga
PGA memory freed back to OS     
total PGA used for auto workareas   ��ǰautoģʽ��ռ�õ�workara size��С
maximum PGA used for auto workareas    autoģʽ��ռ�õ�workara size����С
total PGA used for manual workareas    ��ǰmanualģʽ��ռ�õ�workara size��С
maximum PGA used for manual workareas   manualģʽ��ռ�õ�workara size����С
over allocation count                   ʹ��������pga��С�Ĵ���
bytes processed                         pgaʹ�õ��ֽ�
extra bytes read/written                ����ʱ��д���ֽ�
cache hit percentage
*/

select * from v$pgastat;  


