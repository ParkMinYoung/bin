#!/bin/bash

. ~/.bash_function


#([[ ${A##*.} -eq "gz" ]] && zcat $A) || ([[ ${A##*.} -eq "log" ]]) | cat $A | \


ext=${1##*.}

if [ $ext == "gz" ];then
	YEAR=${1:20:4}	
else
	YEAR=$(date +%Y)
fi


case ${1##*.} in
  
  gz)
  		zcat $1
		;;

  log)
 		cat $1
		;;
  *)
  		echo "Sorry, I don't understand"
		break
		;;
esac | \
perl -MDate::Calc=Decode_Month -MDateTime -snle'
BEGIN{print join "\t", qw/DATE ACC WHO PWD CMD OK/}
/^(\w{3})\s+(\d+) (\d{2}:\d{2}:\d{2}) \w+ (\w+): \[(.*)\]\[\d+\]\[(.+)\]: (.+) \[(\d)\]/; 
($mon, $day, $time, $acc, $whoami, $pwd, $cmd, $ok)=($1,$2,$3,$4,$5,$6,$7,$8);

($h,$m,$s) = split ":", $time;
$mon=Decode_Month($mon);

$dt = DateTime->new(year=> $year, month=> $mon, day=> $day, hour=> $h, minute=> $m, second=> $s);
$date = $dt->strftime( "%Y-%m-%d %H:%M:%S" );

print join "\t", $date, $acc, $whoami, $pwd, $cmd, $ok
' -- -year=$YEAR

