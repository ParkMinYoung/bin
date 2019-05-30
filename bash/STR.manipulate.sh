#! /bin/bash

# http://www.thegeekstuff.com/2010/07/bash-string-manipulation/




var="Welcome to the geekstuff"

# Get length of string
echo ${#var}
# 24



# Extract a Substring 
echo ${var:15}
# geekstuff
echo ${var:15:4}
# geek



# Shortest Substring Match

filename="bash.string.txt"

# After deletion of shortest match from front:
echo ${filename#*.}
# string.txt

# After deletion of shortest match from back:
echo ${filename%.*}
# bash.string


echo "After deletion of longest match from front:" ${filename##*.}
# After deletion of longest match from front: txt
echo "After deletion of longest match from back:" ${filename%%.*}
# After deletion of longest match from back: bash


# Find and Replace String Values

# Replace only first match
# ${string/pattern/replacement}

echo "After Replacement:" ${filename/str*./operations.}
# After Replacement: bash.operations.txt

# Replace all the matches
# ${string//pattern/replacement}

filename="Path of the bash is /bin/bash"

echo "After Replacement:" ${filename//bash/sh}
# After Replacement: Path of the sh is /bin/sh


# tab 2 space
B=${B/$(echo -e "\t")/ }

# Replace beginning and end
# ${string/#pattern/replacement}
# ${string/%pattern/replacement}


filename="/root/admin/monitoring/process.sh"

echo "Replaced at the beginning:" ${filename/#\/root/\/tmp}
# Replaced at the beginning: /tmp/admin/monitoring/process.sh
echo "Replaced at the end": ${filename/%.*/.ksh}
# Replaced at the end: /root/admin/monitoring/process.ksh

