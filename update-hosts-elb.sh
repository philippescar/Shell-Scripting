#!/bin/bash
## This script grab a list of ELB or any CNAME and update the respective IP Address on hosts file

ELBLIST="/tmp/elblist.txt"

while read -r a b; do
   echo "Checking $b"
   IP=$(gethostip -d $a)
if grep -q "$b" /etc/hosts; then
    echo "$b Exists - Updating"
    sed -i "/$b/ s/.*/$IP\t$b/g" /etc/hosts
else
    echo "$b don't Exist - Adding $IP $b"
    echo -e "$IP $b" >> /etc/hosts
fi
done < "$ELBLIST"
