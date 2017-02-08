/*
aggregate PGA target parameter  pga_aggregate_target
aggregate PGA auto target       剩余的能被工作区使用的内存(pga_aggregate_target - 其他的内存)
global memory bound             单个SQL最大能用到的内存
total PGA inuse                 正在被消耗的pga(包括workarea pl/sql等所有占用的pga)
total PGA allocated             当前实例已分配的PGA内存总量，
一般来说这个值应该小于pga_aggregate_target，
但是如果进程需求的PGA快速增长，它可以在超过pga_aggregate_target的限定值

maximum PGA allocated           pga曾经扩张到的最大值
total freeable PGA memory       可释放的pga
PGA memory freed back to OS     
total PGA used for auto workareas   当前auto模式下占用的workara size大小
maximum PGA used for auto workareas    auto模式下占用的workara size最大大小
total PGA used for manual workareas    当前manual模式下占用的workara size大小
maximum PGA used for manual workareas   manual模式下占用的workara size最大大小
over allocation count                   使用量超过pga大小的次数
bytes processed                         pga使用的字节
extra bytes read/written                向临时段写的字节
cache hit percentage
*/

select * from v$pgastat;  


