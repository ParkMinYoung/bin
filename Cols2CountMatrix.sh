#!/bin/sh

. ~/.bash_function
. ~/.perl

# usage :  Cols2Matrix.sh row_col_num file_name `find | grep stats.txt$` 

if [ $# -ge "3" ];then

# column number of target file
R_num=$(($1-1)) ## row header col

# created file name
TITLE=$2

shift
shift

# $@ : target file

perl -F'\t' -MMin -asne'next if ++$f{$ARGV}==1; chomp@F;$h{$F[$row]}{$ARGV}++;$h{Total}{$ARGV}++  }{ mmfsn($title, %h)' -- -row=$R_num -title=$TITLE $@

else
	echo "count specific column string per file"
	usage "row_col_num output_file_name \`find | grep stats.txt$\`"

fi




# #PASS    Basic Statistics        SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz
# #PASS    Per base sequence quality       SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz
# #PASS    Per sequence quality scores     SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz
# #FAIL    Per base sequence content       SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz
# #FAIL    Per base GC content     SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz
# #WARN    Per sequence GC content SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz
# #PASS    Per base N content      SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz
# #PASS    Sequence Length Distribution    SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz
# #FAIL    Sequence Duplication Levels     SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz
# #PASS    Overrepresented sequences       SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz
# #WARN    Kmer Content    SP_1_GCCAAT_L006_R2_001.fastq.gz.N.fastq.gz

