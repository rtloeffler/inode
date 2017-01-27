echo "
#!/bin/bash
COUNT=`df -i|grep '^/dev'|awk '{print $6, 100 - $5}'|tr -d '// '`
USED=20
SERVER=agp-tn
tstamp=`date +%m-%d-%Y:%H:%M:%S` #Define timestamp

if [[ $COUNT -lt $USED ]]; then
echo $tstamp
echo 'Error: Inodes useage High, Only' $COUNT 'Percent remaining on' $SERVER $tstamp | slacktee.sh -n -a "good" -o "warning" "^Warning:" -o "danger" "^Error:" -d "@here" "^Error:" -m link_names
else
echo $tstamp ':inodes range range healthy currently' $COUNT 'percent remaining'
fi" > /home/ubuntu/inodeuseage.sh && chmod +x /home/ubuntu/inodeuseage.sh && echo "/var/log/inodesuseage.log {
  su root root
  missingok
  notifempty
  size 100M
  create 0600 root root
  delaycompress
  compress
  rotate 4
  endscript
}" > /etc/logrotate.d/inodesuseage && crontab -l | { cat; echo "*/5 * * * * /home/ubuntu/inodeuseage.sh >> /var/log/inodesuseage.log 2>&1 &"; } | crontab -
