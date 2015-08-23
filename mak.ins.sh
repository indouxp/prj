#!/bin/sh

start=$1
end=$2

seq -f "%010g" $start $end |
awk '
  BEGIN{
   printf("whenever sqlerror exit failure rollback;\n");
  }
  {
    printf("insert into tbl_dummy(fld010, fld020, fld030) values (%c%s%c, %c%s%c, %c%s%c);\n",
      39, $1, 39, 39, $1, 39, 39, 999999999-$1, 39  \
    );
  }
  END {
   printf("commit;\n");
   printf("exit 0\n");
  }' 
