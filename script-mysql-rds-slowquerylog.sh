#!/bin/bash
#
# Please install aws-cli and Percona Toolkit for this report
#
# Get the RDS db instanceID from command line, you can change this variable to get the value from a cron or command line.
AWS_INSTANCE=instanceID
# Slowlog place
SLOWLOG=/tmp/rds_slow.log
# Today's date in a variable
TODAY=`/bin/date +\%m/\%d/\%Y-\%H:\%S`
# Report subject
SUBJECT="Slow Query Report -- $TODAY "
# Recipient
EMAIL="email@email.com"

# Fetch the latest slow query log from RDS
/usr/local/bin/aws rds download-db-log-file-portion --db-instance-identifier $AWS_INSTANCE --output text --log-file-name slowquery/mysql-slowquery.log > $SLOWLOG

# query report output
SLOWREPORT=/tmp/reportoutput.txt

# pt-query-digest location
MKQD=/usr/local/bin/pt-query-digest

# run the tool to get analysis report
$MKQD $SLOWLOG > $SLOWREPORT

# send an email using /bin/mail
/usr/bin/mailx -s "$SUBJECT" "$EMAIL" < $SLOWREPORT
