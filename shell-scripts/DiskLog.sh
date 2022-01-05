#!/bin/bash

# this shell program is to acquire disk information with format:
# Time                  Flag(all/partition) mount_path  total   used    free    used_percentage
# yyyy-mm-dd HH:MM:SS   0                   ALL         xxxM    xxxM    xxxM    xx.xx%
# yyyy-mm-dd HH:MM:SS   1                   /...        xxxM    xxxM    xxxM    xx.xx%

# no input argument

Date=`date "+%Y-%m-%d__%H:%M:%S"`;

eval `df -Tm -x tmpfs -x devtmpfs | tail -n +2 |\
    awk -v TotalAll=0 -v UsedAll=0 -v FreeAll=0 '{
        printf("TotalPart["NR"]=%d;\
                UsedPart["NR"]=%d;\
                FreePart["NR"]=%d;\
                PathPart["NR"]=%s;",
                $3, $4, $5, $7);
        TotalAll+=$3;
        UsedAll+=$4;
        FreeAll+=$5;
    } END {
        printf("Cnt=%d;\
                TotalAll=%d;\
                UsedAll=%d;\
                FreeAll=%d;", NR, TotalAll, UsedAll, FreeAll);
    }'`

UsedPctAll=`echo "scale=2; x=${UsedAll} * 100 / ${TotalAll}; if (x < 1) print 0; x" | bc`
echo -e "${Date}\t0\tALL\t${TotalAll}\t${UsedAll}\t${FreeAll}\t${UsedPctAll}%"

for (( i = 1; i <= ${Cnt}; ++i ))
do
    UsedPctPart=`echo "scale=2; x=${UsedPart[$i]} * 100 / ${TotalPart[$i]}; if (x < 1) print 0; x" | bc`
    echo -e "${Date}\t1\t${PathPart[$i]}\t${TotalPart[$i]}\t${UsedPart[$i]}\t${FreePart[$i]}\t${UsedPctPart}%"
done

