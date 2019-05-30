
#!/bin/bash

. ~/.bash_function

if [ $# -ge 1 ];then

	STRING=$1
	defaul_q=utl.q
	QUEUE=${2:-$default_q}

	qstat -f | grep qw | egrep -i $STRING | awk '{print $1}' | xargs qalter -q $QUEUE

else
	
	usage "String Queue[utl.q]"
fi


