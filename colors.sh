#!/bin/sh

for i in {30..37}
	do 
	for j in {0..2}
		do
			for k in {0,{40..47}}
				do 
				if [ $k -eq 0 ];then
					I="\e[${j};${i}m $j;$i;$k \e[m"
				else
					I="\e[${j};${i};${k}m $j;$i;$k \e[m"
				fi
					IN=$(echo "$IN $I")
			done
		IN=$(echo "$IN\n")
		done
		echo -e "$IN"
		IN=
done
