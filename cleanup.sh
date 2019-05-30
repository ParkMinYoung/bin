#!/bin/bash

. ~/.bash_function



pattern=${1:-.cleanup}

if [ -f $pattern ];then
	
	pattern_cnt=$(grep -c \\w+ -P .cleanup)

	_M1 red blue Log "will find below patterned files using $pattern file"
	_M1 red blue Log "$pattern's pattern number : $pattern_cnt"
	
	parallel --tagstring pattern-[{}] --plus -a $pattern echo {#} of {##}


	find -type f | grep -f $pattern > ${pattern}_list
	_get_total_size_from_f.sh ${pattern}_list > ${pattern}_size

	_M1 red blue Log "finded "$(wc -l ${pattern}_list | awk '{print $1}')" files, and will save "$(awk '{print $1}' .cleanup_size)
	
	_M1 green red [-.-] "Wanna Delete? [y|n] : " 
	read anwser
	
	case $anwser in 

		y|Y)
				_cleanup_rm.sh ${pattern}_list
				_M1 blue red Log "Complete!"
				;;

		n|N)
				
				_M1 blue red Log "Nothing! Bye~"
				;;

	esac


else

	usage "deleted_file[default:.cleanup] : _list & _size"

fi

