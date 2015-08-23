whenever sqlerror exit failure rollback
set linesize 100
set pagesize 100
ttitle 'DBA_TABLESPACES|自動セグメント領域管理|（ASS Management）の確認'
column tablespace_name heading 'tablespace' format a30
column segment_space_management heading '自動|セグメント|領域管理' format a20
select
  tablespace_name,
  segment_space_management
from
  dba_tablespaces
order by
  tablespace_name
;
exit 0 
