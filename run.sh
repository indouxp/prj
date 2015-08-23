#!/bin/sh

SYS="/ as sysdba"
sqlplus "${SYS:?}" @ slt.tablespace-01.sql 
sqlplus "${SYS:?}" @ slt.data_files-01.sql 
./get-disk-usage-2.sh "${SYS:?}"
./mak.ls.data_files.sh "${SYS:?}"

#USERPASS="indou/indou"
USERPASS="/ as sysdba"

sqlplus -S ${USERPASS} @ crt.tbl_dummy.sql  > /dev/null

START=1
END=$((${START} + 9999))

OK=""
while [ "$OK" = "" ]; do
  echo "$START-$END"
  ./mak.ins.sh $START $END > insert.sql

  sqlplus -S ${USERPASS} @ insert.sql > /dev/null
  RC=$?
  if [ "${RC:?}" -ne "0" ]; then
    echo "insert.sql fail." 1>&2
    exit 1
  fi
  sqlplus -S ${USERPASS:?} @ cnt.tbl_dummy.sql
  ./get-disk-usage-2.sh "${SYS:?}"
  ./mak.ls.data_files.sh "${SYS:?}"

  START=$((${END} + 1))
  END=$((${START} + 9999))
  echo -n "OK?"
  read OK
done
