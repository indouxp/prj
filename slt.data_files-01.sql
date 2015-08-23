whenever sqlerror exit failure rollback
set linesize 100
ttitle 'DBA_DATA_FILES|自動拡張'
column autoextensible heading '自動拡張' format a10
column file_name heading 'filename' format a70
column tablespace_name heading 'tablespace' format a10
select
  tablespace_name,
  file_name,
  autoextensible
from
  dba_data_files
;

exit 0
