#!/bin/bash

# this shell program is to acquire system information with format:
# Time  hostname    OS(version)  kernel(version)  run_time    avg_load    disk_total  disk_pct(%)   mem_total    mem_pct(%)   cpu(C)  disk_warn_lv  mem_warn_lv  cpu_warn_lv

# WARNING_LEVEL normal  note    warning
# disk(%)       0-80    80-90   90-100
# cpu(C)        0-50    50-70   70-100
# mem(%)        0-70    70-80   80-100

Date=`date "+%Y-%m-%d__%H:%M:%S"`
HostName=`uname -n`
OS=`uname -o`; OS+=`uname --version | head -n1 | cut -d ' ' -f 4`
Kernel=`uname -rs`
Uptime=`uptime --pretty`
AvgLoad=`cat /proc/loadavg | awk '{print $1" "$2" "$3}'`

eval `df -Tm -x tmpfs -x devtmpfs | tail -n +2 |\
    awk -v DiskTotal=0 -v DiskUsed=0 '{
        DiskTotal+=$3;
        DiskUsed+=$4;
    } END {
        printf("DiskTotal=%d; DiskPct=%.2f;", DiskTotal, DiskUsed * 100 / DiskTotal);
    }'`

read MemTotal MemPct <<< \
    $(echo `free -m | head -n 2 | tail -n 1 | awk '{printf("%d %.2f", $2, $3 * 100 / $2)}'`)

# default temperature for CPUT
CPUT=37.0
if [[ -f "/sys/class/thermal/thermal_zone0/temp" ]]
then
    CPUT=`cat /sys/class/thermal/thermal_zone0/temp | tr -cd "[0-9.]"`
fi

# judge Disk warning level
DiskWarning=warning
if [[ $(echo "${DiskPct} < 80" | bc -l) = 1 ]]
then
    DiskWarning=normal
elif [[ $(echo "${DiskPct} < 90" | bc -l) = 1 ]]
then
    DiskWarning=note
fi

# judge Memory warning level
MemWarning=warning
if [[ $(echo "${MemPct} < 70" | bc -l) = 1 ]]
then
    MemWarning=normal
elif [[ $(echo "${MemPct} < 80" | bc -l) = 1 ]]
then
    MemWarning=note
fi

# judge CPU warning level
CPUWarning=warning
if [[ $(echo "${CPUT} < 50" | bc -l) = 1 ]]
then
    CPUWarning=normal
elif [[ $(echo "${CPUT} < 70" | bc -l) = 1 ]]
then
    CPUWarning=note
fi

echo -e "${Date}\t${HostName}\t${OS}\t${Kernel}\t\
         ${Uptime}\t${AvgLoad}\t${DiskTotal}\t\
         ${DiskPct}%\t${MemTotal}\t${MemPct}%\t${CPUT}\t\
         ${DiskWarning}\t${MemWarning}\t${CPUWarning}"

