#!/bin/bash
SHELL=/bin/bash
HOME=/root

message=`mysql -H -e "SELECT CONCAT(table_schema, '.', table_name) as Table_Name,
       CONCAT(ROUND(table_rows / 1000000, 2), 'M')                                    rows,
       CONCAT(ROUND(data_length / ( 1024 * 1024 * 1024 ), 2), 'G')                    DATA,
       CONCAT(ROUND(index_length / ( 1024 * 1024 * 1024 ), 2), 'G')                   idx,
       CONCAT(ROUND(( data_length + index_length ) / ( 1024 * 1024 * 1024 ), 2), 'G') total_size,
       ROUND(index_length / data_length, 2)                                           idxfrac
FROM   information_schema.TABLES
ORDER  BY data_length + index_length DESC
LIMIT  10;"`

echo "X-Mailer: NAME OF YOUR COMPANY .
X-Originating-IP:
From: Company Database Report <noreply@companymail.com>
Subject: Company Database Report from $HOSTNAME
To: admin@company.com.br
MIME-Version: 1.0
Content-Type: text/html; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
" > /tmp/msg.$$
TS=`date`
echo -e "<html><body><p><b><h2>[$TS] Report -- $HOSTNAME</h2></b>" >> /tmp/msg.$$
echo $message >> /tmp/msg.$$
echo "</p><p><table border=0 cellspacing=1 cellpading=0>" >> /tmp/msg.$$
df -Phl |awk 'NR>1 && NF==6'|sort|while read FS SIZE USED FREE PERC MOUNT
do
  echo '<TR><TD>'$FS'</TD><TD ALIGN=RIGHT>'$SIZE'</TD>' >> /tmp/msg.$$
  echo '<TD ALIGN=RIGHT>'$USED'</TD><TD ALIGN=RIGHT>'$FREE'</TD>' >> /tmp/msg.$$
 echo '<TD><FONT SIZE=-1 COLOR=black> '$PERC'</FONT></TD>' >> /tmp/msg.$$
  echo '</TD><TD>'$MOUNT'</TD></TR>' >> /tmp/msg.$$
done
echo "</table></p></body></html>" >> /tmp/msg.$$
cat /tmp/msg.$$ | /usr/sbin/sendmail -t
rm -rf /tmp/msg.$$
