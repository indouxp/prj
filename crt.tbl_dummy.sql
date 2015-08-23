
whenever sqlerror continue
drop table tbl_dummy;

whenever sqlerror exit failuer rollback
create table tbl_dummy(
  fld010 varchar2(10),
  fld020 varchar2(256),
  fld030 varchar2(256)
);

select owner, object_name from dba_objects where object_name = 'TBL_DUMMY'

exit 0
