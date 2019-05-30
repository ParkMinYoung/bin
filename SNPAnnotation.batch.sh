#!/bin/sh

. ~/.bash_function

if [ $# -gt 1 ];then

	for i in $@; do  SNPAnnotation.sh $i; done

else
	usage "NM_000....."
fi

