#!/bin/sh

# run as root (enter password)

# ./zones /Staging_Zone /Sandbox_Zone/HdpQuant /Sandbox_Zone/HdpCdt /Sandbox_Zone/HdpCst /Sandbox_Zone/HdpTechNL /Sandbox_Zone/HdpReportingNL /Sandbox_Zone/HdpFinance /Business_Data_Model_Zone

# destroy any previous ticket of hdfs user
echo "destroying any previous ticket from kdc server"
su - hdfs -c kdestroy || echo "kdestroy command failed"


# display the kerberos principle
echo "reading the keytab file to get the hdfs principle"
su - hdfs -c "klist -kt /etc/security/keytabs/hdfs.headless.keytab" || echo "klist command failed"

#  generate new ticket for hdfs

PRINCIPLE="$(su - hdfs -c 'klist -kt /etc/security/keytabs/hdfs.headless.keytab' | awk ' {print $4} ' | sort -u |sed '/./,$!d')"
echo "Getting hdfs ticket from kdc server"
COMMAND='kinit -kt /etc/security/keytabs/hdfs.headless.keytab '
sudo -u hdfs $COMMAND$PRINCIPLE || echo "Kinit command failed"

su - hdfs -c 'klist -e'

for i in "$@"

do

    # create zone and apply permissions

    printf "%s\n" "$i"

    sudo -u hdfs hdfs dfs -mkdir "$i" || echo "creating folder " + $i + " failed"

    sudo -u hdfs hdfs dfs -chmod 700 "$i" || echo "adding permissions to folder " + $i + " failed"

done
