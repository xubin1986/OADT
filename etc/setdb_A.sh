#!/usr/bin/sh
sid=$1
ostype=_OSTYPE_
dbname=_DBNAME_
rac=_RAC_
sql=/var/orainst/setdb.sql
>$sql
profile=/home/oracle/.profile
perl -i -pe "s/ORACLE_SID=.*/ORACLE_SID=$sid/" $profile
. $profile
export ORACLE_SID=$sid
if [ $rac = 1 ]
then
	/oracle/orahome/bin/srvctl stop database -db $dbname -stopoption IMMEDIATE -force > /dev/null 2>&1
else
	ps -ef|grep smon|grep $dbname|grep orcl$ > /dev/null 2>&1 && echo "shutdown immediate;" >> $sql
fi
echo "startup mount;" >> $sql
echo "alter database archivelog;" >> $sql
echo "alter database open;" >> $sql
echo "shutdown immediate;" >> $sql
echo "exit;" >> $sql
/oracle/orahome/bin/sqlplus / as sysdba @$sql
exit $?
