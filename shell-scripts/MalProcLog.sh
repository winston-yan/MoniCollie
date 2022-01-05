#!/bin/bash

# Requirements:
# 1. if CPU or Memory usage rate up to 50%, the process is marked as suspicious
# 2. traverse all the processes, find all the suspicious processes
# 3. if any processes are marked, wait for 5 seconds for next traverse
# 4. if marked process(es) is(are) still meet the threshold, marked as MALICIOUS


eval `ps -aux --sort=-%cpu -h | awk -v cnt=0 '{
    if ($3 < 50) {
        exit
    } else {
        ++cnt;
        printf("CpuPid["cnt"]=%d;", $2);
    }
} END {
    printf("CpuCnt=%d;", cnt);
}'`


eval `ps -aux --sort=-%mem -h | awk -v cnt=0 '{
    if ($4 < 50) {
        exit
    } else {
        ++cnt;
        printf("MemPid["cnt"]=%d;", $2);
    }
} END {
    printf("MemCnt=%d;", cnt);
}'`

if [[ ${CpuCnt} -gt 0 || ${MemCnt} -gt 0 ]]; then
    sleep 5
else
    exit 0
fi

Date=`date "+%Y-%m-%d__%H:%M:%S"`

cnt=0
if [[ ${CpuCnt} -gt 0 ]]
then
    for i in ${CpuPid[*]}
    do
        eval `ps -aux -h -q $i | awk -v cnt=${cnt} '{
            if ($3 < 50) {
                exit
            } else {
                printf("ProcName["cnt"]=%s;\
                        Pid["cnt"]=%d;\
                        User["cnt"]=%s;\
                        CpuPct["cnt"]=%.2f;\
                        MemPct["cnt"]=%.2f;",
                        $11, $2, $1, $3, $4);
            }
        }'`
        cnt=$[$cnt + 1]
    done
fi

if [[ ${MemCnt} -gt 0 ]]
then
    for i in ${MemPid[*]}
    do
        eval `ps -aux -h -q $i | awk -v cnt=${cnt} '{
            if ($4 < 50) {
                exit
            } else {
                printf("ProcName["cnt"]=%s;\
                        Pid["cnt"]=%d;\
                        User["cnt"]=%s;\
                        CpuPct["cnt"]=%.2f;\
                        MemPct["cnt"]=%.2f;",
                        $11, $2, $1, $3, $4);
            }
        }'`
        cnt=$[$cnt + 1]
    done
fi

for ((i = 0; i < ${cnt}; i++));do
    echo "${Date} ${ProcName[$i]} ${Pid[$i]} ${User[$i]} ${CpuPct[$i]}% ${MemPct[$i]}%"
done

