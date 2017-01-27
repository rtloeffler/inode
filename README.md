The following will create the file, set the file to executable, create a logrotate rule, and then create the cron job to run every 5 minutes

Change to super user

`sudo su -`

Create file manually otherwise bash strips a few things
`nano /home/ubuntu/inodeuseage.sh`

Add contents
```
#!/bin/bash
COUNT=`df -i|grep '^/dev'|awk '{print $6, 100 - $5}'|tr -d '// '`
USED=20
SERVER=agp-tn
tstamp=`date +%m-%d-%Y:%H:%M:%S`

if [[ $COUNT -lt $USED ]]; then
echo $tstamp
echo 'Error: Inodes useage High, Only' \$COUNT 'Percent remaining on' \$SERVER \$tstamp | slacktee.sh -n -a "good" -o "warning" "^Warning:" -o "danger" "^Error:" -d "@here" "^Error:" -m link_names
else
echo $tstamp ':inodes range range healthy currently' $COUNT 'percent remaining'
fi
```

Add logrotate file and change permission to executable and also create cron

```
chmod +x /home/ubuntu/inodeuseage.sh && echo "/var/log/inodesuseage.log {
  su root root
  missingok
  notifempty
  size 100M
  create 0600 root root
  delaycompress
  compress
  rotate 4
  endscript
}" > /etc/logrotate.d/inodesuseage && crontab -l | { cat; echo "* * * * * /home/ubuntu/inodeuseage.sh >> /var/log/inodesuseage.log 2>&1 &"; } | crontab -
```

Check log file to make sure its running
