#!/bin/sh

. ~/.bash_function


if [ -f "$1" ] && [ -f "$2" ];then

R1=$1
R2=$2

R1_len=51
R2_len=52
Read_len=102

R1_in_len=$3
R2_in_len=$4
Read_in_len=$5

R1_Trim=${R1_in_len:=$R1_len}
R2_Trim=${R2_in_len:=$R2_len}
Read_total_len=${Read_in_len:=$Read_len}

R1_range="1-$((R1_Trim-1))"
R2_range="$((R2_Trim+1))-$Read_total_len"

echo "`date` start $0"

# trim 51~end of R1
# [1-50]XXXXXXXXXXX:51-end
zcat $R1 | fastx_trimmer -l$R1_Trim -o $R1.$R1_range.gz -Q33 -z &
echo "zcat $R1 | fastx_trimmer -l$R1_Trim -o $R1.$R1_range.gz -Q33 -z"

# trim 1~52 of R2
# XXXXXXXXXXX:1-52[53-end]
zcat $R2 | fastx_trimmer -f$R2_Trim -o $R2.$R2_range.gz -Q33 -z &
echo "zcat $R2 | fastx_trimmer -f$R2_Trim -o $R2.$R2_range.gz -Q33 -z"

wait
echo "`date` end $0"

else
	usage "Read1.fastq.gz Read2.fastq.gz [R1 51-end trim length:51] [R2 1-52 trim length:52] [read_len:102]"
fi
