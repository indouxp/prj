#!/bin/sh
#
SCRIPT=`basename $0`
SQL=/tmp/${SCRIPT:?}.$$.sql
term() {
  rm -f /tmp/`basename $0`.$$.*
}

trap 'term' 0 1 2 15

usage() {
  cat <<EOT
usage
\$ ./${SCRIPT:?} USER/PASS
EOT
}
if [ "$#" -eq "0" ];then
  usage
  exit 1
fi
CONNECT_STRING=$1

cat <<EOT > ${SQL:?}
whenever sqlerror exit failure rollback
whenever oserror exit failure rollback

set lines 120
set pages 100
--set term off
tti off
clear col
col TABLESPACE_NAME     format a15
col "SIZE(KB)"          format a20
col "USED(KB)"          format a20
col "FREE(KB)"          format a20
col "USED(%)"           format 990.99
select
  tablespace_name,
  to_char(nvl(total_bytes / 1024,0),'999,999,999') as "size(KB)",
  to_char(nvl((total_bytes - free_total_bytes) / 1024,0),'999,999,999') as "used(KB)",
  to_char(nvl(free_total_bytes/1024,0),'999,999,999') as "free(KB)",
  round(nvl((total_bytes - free_total_bytes) / total_bytes * 100,100),2) as "rate(%)"
from
  ( select
      tablespace_name,
      sum(bytes) total_bytes
    from
      dba_data_files
    group by
      tablespace_name
  ),
  ( select
      tablespace_name free_tablespace_name,
      sum(bytes) free_total_bytes
    from
      dba_free_space
    group by tablespace_name
  )
where
  tablespace_name = free_tablespace_name(+)
order by
  tablespace_name
/

exit 0
EOT

sqlplus -s ${CONNECT_STRING:?} @ ${SQL:?}
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${SCRIPT:?}: sqlplus fail. RC=${RC:?}." 1>&2
  exit 1
fi
