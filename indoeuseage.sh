#!/bin/bash
COUNT=`df -i|grep '^/dev'|awk '{print $6, 100 - $5}'|tr -d '// '`
USED=20
SERVER=`hostname`
tstamp=`date +%m-%d-%Y:%H:%M:%S`

if [[ $COUNT -lt $USED ]]; then
echo $tstamp 
echo 'Error: Inodes useage High, Only' $COUNT 'Percent remaining on' $SERVER HS Server at $tstamp | slacktee.sh -n -a "good" -o "warning" "^Warning:" -o "danger" "^Error:" -d "@here" "^Error:" -m link_names
else
echo $tstamp ':inodes range range healthy currently' $COUNT 'percent remaining'
fi
