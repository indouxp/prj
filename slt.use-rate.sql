whenever sqlerror exit failure rollback
set echo on
set colsep |
set pages 1000
set lines 1000

column TEMP_SIZE(MB)    format a15
column TEMP_HWM(MB)     format a15
column TEMP_HWM(%)      format a15
column TEMP_USED(MB)    format a15
column TEMP_USING(%)    format a15

SELECT
        d.tablespace_name,
        現サイズ "SIZE(MB)",
        round(現サイズ-空き容量) "USED(MB)",
        round((1 - (空き容量/現サイズ))*100) "USE(%)",
        空き容量 "AVAIL(MB)"
FROM
        (SELECT tablespace_name, round(SUM(bytes)/(1024*1024)) "現サイズ" FROM dba_data_files GROUP BY tablespace_name) d,
        (SELECT tablespace_name, round(SUM(bytes)/(1024*1024)) "空き容量" FROM dba_free_space GROUP BY tablespace_name) f
WHERE
        d.tablespace_name = f.tablespace_name
ORDER BY
        d.tablespace_name
;

SELECT
       d.tablespace_name,
       round(現サイズ) "SIZE(MB)",
       round(最大使用量) "USED(MB)",
       round(((最大使用量/現サイズ))*100) "USE(%)",
       round(現サイズ-最大使用量) "AVAIL(MB)"
FROM
       (SELECT tablespace_name, SUM(bytes)/(1024*1024) "現サイズ" FROM dba_temp_files GROUP BY tablespace_name) d,
       (SELECT tablespace_name, SUM(bytes_used)/(1024*1024) "最大使用量" FROM v$temp_extent_pool GROUP BY tablespace_name) f,
       dba_tablespaces t
WHERE
       (d.tablespace_name = f.tablespace_name) AND (d.tablespace_name = t.tablespace_name )
ORDER BY
       d.tablespace_name
;

exit 0
