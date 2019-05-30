#!/bin/bash

. ~/.bash_function

# tar -T : read from a file including file lists
# pv -s : byte size 
# du -c : total size
# du -b : byte size
# du -L : permit symlink files


if [ -f "$1" ] && [ $# -eq  2 ];then

	tar cfh - -T $1 | \
		pv -s $(cat $1 | xargs du -cbL | tail -n 1 | awk '{print $1}') | \
		gzip > $2

else
	
	usage "file_list out_tgz_file.tgz"

fi

