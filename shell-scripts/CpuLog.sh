#!/bin/bash

# this shell program is to acquire CPU information with format:
# Time  load(1min)  load(5min)  load(15min) Usage_rate(%)   CPUT('C)   cpu_warn_lv

# WARNING_LEVEL normal  note    warning
# mem(%)        0-70    70-80   80-100

Date=`date "+%Y-%m-%d__%H:%M:%S"`

read Load1 Load5 Load15 <<< \
    $(echo `cat /proc/loadavg | awk '{print $1" "$2" "$3}'`)

# default CPU temperature
CPUT=37.0
if [[ -f "/sys/class/thermal/thermal_zone0/temp" ]]
then
    CPUT=`cat /sys/class/thermal/thermal_zone0/temp | tr -cd "[0-9.]"`
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

# get CPU usage rate from file /proc/stat at interval 0.5s

function get_cpu_log() {
    CpuLog=(`cat /proc/stat | grep "cpu " | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}'`)
    CpuTotal=0
    CpuIdle=${CpuLog[3]}
    for log in ${CpuLog[*]}
    do
        CpuTotal=$[$CpuTotal+$log]
    done
    echo ${CpuTotal}" "${CpuIdle}
}

read T1 I1 <<< $(get_cpu_log)
sleep 0.5
read T2 I2 <<< $(get_cpu_log)

CPURate=`echo "scale=2; x=100 - ($I2 - $I1) * 100 / ($T2 - $T1); if (x < 1) print 0; x" | bc -l`

echo -e "${Date}\t${Load1}\t${Load5}\t${Load15}\t${CPURate}%\t${CPUT}\t${CPUWarning}"
