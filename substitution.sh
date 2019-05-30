#!/bin/sh

. ~/.bash_function

if [ $# -eq 5 ];then


Target=$1
Target_K=$2

DB=$3
DB_K=$4
DB_V=$5

perl -F'\t' -asnle'
BEGIN{
    $target_key--;
    $db_key--;
    $db_value--;
}

if(@ARGV){
    $h{$F[$db_key]}=$F[$db_value]
}else{
    if( $h{$F[$target_key]} ){
	    $F[$target_key] = $h{$F[$target_key]};
    	print join "\t", @F;
	}else{
		print
	}
}
' -- -target_key=$Target_K -db_key=$DB_K -db_value=$DB_V $DB $Target

else
	usage "TargetFile TaretFile_key DBFile DB_key DB_value"
fi

