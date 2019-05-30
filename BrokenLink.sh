#!/bin/sh
# find . -type l | (while read FN ; do test -e "$FN" || ls -ld "$FN"; done)
# find -L . -type l -lname '*' 2>&1 | awk '{print $2}' | sed s/:$//
find -L . -type l -lname '*' 2>&1 | sort 
