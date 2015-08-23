#!/bin/sh
TMP_SH=tmp-`basename $0`.sh

USERPASS=$1

sqlplus -S ${USERPASS:?} <<EOT > ${TMP_SH:?}
set heading off
select
  'ls -l '|| file_name
from
  dba_data_files
order by
  tablespace_name
;
exit 0

EOT

sh ./${TMP_SH:?}
