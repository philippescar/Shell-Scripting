#!/bin/bash
#Backup MySQL - Philippe Carvalho - 15/10/2013
umask u=rw,g=,o=
logfile='/var/backup/mysql.log'
dumpdir='/var/backup'
backupdir='/var/backup/dumps'
myuser='root'
mypass='USER_PASSWORD'
touch $logfile


echo "Starting backup of the Server - $(date +%Y%m%d)" >> $logfile
while read database; do
echo "Starting backup of database -${database}- $(date +%Y%m%d-%H:%M:%S)" >> $logfile
dumpfile="${dumpdir}/${database}-$(date +%Y%m%d-%H:%M:%S).sql.bz2"
mysqldump -u $myuser -p${mypass} $database —single-transaction | bzip2 > $dumpfile
echo "Done backup of database -${database}- $(date +%Y%m%d-%H:%M:%S)" >> $logfile
mv $dumpfile ${backupdir}/
done < <(mysql -u $myuser -p${mypass} -e 'show databases' -s | sed '1d;$d')
find $backupdir -name '*.sql.bz2*' -type f -mtime +7 -exec rm {} \;
echo "Done backup of the Server - $(date +%Y%m%d)" >> $logfile
cat $logfile | grep $(date +%Y%m%d) | mailx -s "Backup - MySQL - NAME_OF_THE_SERVER" email@server.com.br
