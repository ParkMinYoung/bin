#!/bin/bash

. ~/.bash_function

#default_SQL=/home/adminrig/src/short_read_assembly/bin/AxiomDB.sql/KORV1_1.table.sql
#SQL=${2:-$default_SQL}

SQL=$2
TABLE=$3

if [ -f "$1" ];then

	perl -F"\t" -asnle'if(@ARGV){ push @col, $1 if /\"(.+)\"/ && !/timestamp/ }elsif(++$c > 1){ if(!$col){ @col = map { "\"$_\"" } @col; $col=join ",", @col }; @F = map { "\"$_\"" } @F;  $val = join ",", @F; print "insert or ignore into $table ( $col ) values( $val ) ;"  } ' -- -table=$3 $SQL $1

else

	usage "AxiomDataTable XXX.sql TABLE_Name"


fi


