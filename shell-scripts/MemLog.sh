#!/bin/bash

# this shell program is to acquire memory information with format:
# Time                  total   used    free    used_percentage EWMA
# yyyy-mm-dd HH:MM:SS   xxxM    xxxM    xxxM    xx.xx%          xx.xx%

# this program have one argument other than program's name
# arg[1]: initial Estimated average used percentage (unit: %)

function usage_error() {
    echo "Usage: $0 \${{initial EWMA of used memory}}"
    exit 1
}

if [[ $# -lt 1 ]]
then
    usage_error
fi


Estimated=$1
Date=`date "+%Y-%m-%d__%H:%M:%S"`

read Total Used Free <<< \
    $(echo `free -m | tail -n +2 | head -n 1 | awk '{printf("%d %d %d", $2, $3, $4);}'`)

UsedPct=`echo "scale=2; x=${Used}*100/${Total}; if (x < 1) print 0; x" | bc`
EWMAPct=`echo "scale=2; x=${Estimated}*0.7+${UsedPct}*0.3; if (x < 1) print 0; x" | bc`

echo ${Date} ${Total} ${Used} ${Free} ${UsedPct}% ${EWMAPct}%
