#!/bin/sh


if [ $# -eq 1 ];then

	N=$1
	NODE=$(head -$N ~/src/short_read_assembly/bin/utl.q/hostlist | tail -n 1)
	
	exec ssh $NODE

else
	NODE=$(qstat -f | grep utl.q | sed 's/ \+/\t/g' | sort -nr -k4,4  | tail -n 1 | cut -f1 | sed 's/utl.q@//')

	exec ssh $NODE
fi

