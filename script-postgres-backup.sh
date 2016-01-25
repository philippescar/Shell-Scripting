#!/bin/bash
logfile="/opt/postgres/9.1/backup/pgsql.log"
backup_dir="/opt/postgres/9.1/backup"
touch $logfile
databases=`/opt/postgres/9.1/bin/psql -U postgres -q -c "\l" | sed -n 4,/\eof/p | grep -v rows\) | grep -v template0 | grep -v template1 | awk {'print $1'}`

echo "Starting backup of databases " >> $logfile
for i in $databases; do
       dateinfo=`date '+%Y%m%d'`
       timeslot=`date '+%Y%m%d%H%M'`
       /opt/postgres/9.1/bin/./vacuumdb -z -U postgres $i >/dev/null 2>&1
       /opt/postgres/9.1/bin/./pg_dump -U postgres -i -F c -b $i -f $backup_dir/$i-database-$timeslot.backup
       echo "Backup and Vacuum complete on $dateinfo for database: $i " >> $logfile
done
echo "Done backup of databases " >> $logfile

#Verifies if the backup have more than 30 days and delete the old ones
find $backup_dir -name '*.backup' -type f -mtime +30 -exec rm {} \;

#Filtra o log e envia apenas o backup do dia vigente por e-mail
cat $logfile | grep $dateinfo | mailx -s "Backup - Postgres" SEU_EMAIL@dominio.com.br
