set linesize 150
column name format a80
column member format a80
column tablespace_name format a30
column file_name format a100
column file_name a80

select NAME, STATUS from v$controlfile;  
select MEMBER, GROUP# from v$logfile; 
select
  dt.tablespace_name,
  dtf.file_name,
  dt.status
from
  dba_tablespaces dt,
  dba_temp_files dtf
where
  dt.tablespace_name = dtf.tablespace_name;

select
  dt.tablespace_name,
  ddf.file_name,
  dt.status
from
  dba_tablespaces dt, dba_data_files ddf
where
  dt.tablespace_name = ddf.tablespace_name;
