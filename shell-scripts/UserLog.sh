#!/bin/bash

Date=`date "+%Y-%m-%d__%H:%M:%S"`

eval $(awk -F: -v cnt=0 '{
    if ($3 >= 1000 && $3 != 65534) {
        ++cnt;
        printf("Usernames["cnt"]=%s;", $1);
    }
} END {
        printf("UserCnt=%d;", cnt);
}' /etc/passwd)

UserActive=`last -w | cut -d " " -f 1 |\
            grep -v wtmp | grep -v reboot | grep -v "^$" |\
            sort | uniq -c | sort -k1 -n -r |\
            awk -v num=3 '{
                if (num > 0) {
                    printf(",%s", $2);
                    --num;
                }
            }' | cut -c 2-`

eval $(awk -F: '{
    if ($3 == 0 && $4 == 0) {
        printf("Root=%s;", $1);
    }
}' /etc/passwd)

UserWithRoot=${Root}
Users=`cat /etc/group | grep sudo | cut -d : -f 4 | tr ',' ' '`

for i in ${Users};do
    if [[ $i == ${Root} ]] ;then
        continue
    fi
    UserWithRoot="${UserWithRoot},$i"
done

if [[ -r /etc/sudoers ]]
then
    for i in ${Usernames[*]}
    do
        grep -q "^${i}" /etc/sudoers
        if [[ $? -eq 0 ]]
        then
            UserWithRoot="${UserWithRoot},$i"
        fi
    done
fi

UserOnline=`w -h | awk '{
    printf(",%s_%s_%s", $1, $3, $2);
}' | cut -c 2-`

echo -e "${Date}\t${UserCnt}\t[${UserActive}]\t[${UserWithRoot}]\t[${UserOnline}]"
