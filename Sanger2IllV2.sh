#!/bin/sh

 zcat $1 | \
 perl -nle'
 if($.%4==1){
		 /(.+) (1|2):/;
		 @l[0]="$1#1/$2";
		 $l[2]=$l[0];
		 $l[2]=~s/^\@/+/;
 }elsif($.%4==2){
		 s/\./N/g;
		 $l[1]=$_
 }elsif($.%4==0){
		 print join "\n",@l, (join "",map {chr(ord($_)+31)}split "");
		 @l=()
 }' | gzip -c > $1.sanger2ill.fastq.gz 

 # usage 
 # Sanger2Ill.sh s_3.1.ReadFilter.sanger.fastq > s_3.1.fastq
 # Sanger2Ill.sh s_3.2.ReadFilter.sanger.fastq > s_3.2.fastq

