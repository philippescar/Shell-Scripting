#!/bin/bash
#Slow query Log for MySQL schedule - Philippe Carvalho - 20160201
# This script generates a report with the slowquery log on the server.
#Please ensure that you have created a mysql.cnf file, using password on command line is not secure

LOGFILE='/var/log/mysql/slowquery.log'
ATTACH='/var/log/mysql/slowquery.log.tar.gz'

echo > $LOGFILE

echo "Starting Slow Query Logging - $(date +%Y%m%d) - $(date +%H:%M)" >> $LOGFILE

mysql --defaults-file=/var/mysql/mysql.cnf --column-names=false -e "SET GLOBAL slow_query_log = 'ON';"

sleep 60m

echo "Stoping Slow Query Logging - $(date +%Y%m%d) - $(date +%H:%M)" >> $LOGFILE

mysql --defaults-file=/var/mysql/mysql.cnf --column-names=false -e "SET GLOBAL slow_query_log = 'OFF';"

echo "Creating tar file - $(date +%Y%m%d) - $(date +%H:%M)" >> $LOGFILE

tar -czf $ATTACH $LOGFILE

echo "SlowQuery Log for $(date +%Y%m%d) - $(date +%H:%M)" | mutt -a "$ATTACH" -s "MySQL Slow Report - $HOSTNAME" -- admin@domain.com
