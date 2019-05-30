#!/bin/bash

. ~/.bash_function

default_SQL=/home/adminrig/src/short_read_assembly/bin/AxiomDB.sql/KORV1_1.table.sql
SQL=${2:-$default_SQL}

if [ -f "$1" ];then

	perl -F"\t" -anle'if(@ARGV){ push @col, $1 if /\"(.+)\"/ && !/timestamp/ }elsif($F[0]=~/CEL/){ if(!$col){ @col = map { "\"$_\"" } @col; $col=join ",", @col }; @F = map { "\"$_\"" } @F;  $val = join ",", @F; print "insert or ignore into KORV1_1 ( $col ) values( $val ) ;"  } ' $SQL $1

else

	usage "AxiomDataTable [/home/adminrig/src/short_read_assembly/bin/AxiomDB.sql/KORV1_1.table.sql]"


fi


