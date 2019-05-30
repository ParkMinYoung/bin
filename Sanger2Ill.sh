#!/bin/sh
 perl -nle'
 if($.%4==1){
		 @l[0,2]=($_,$_);
		 $l[2]=~s/^\@/\+/
 }elsif($.%4==2){
		 s/\./N/g;
		 $l[1]=$_
 }elsif($.%4==0){
		 print join "\n",@l, (join "",map {chr(ord($_)+31)}split "");
		 @l=()
 }' $1

 # usage 
 # Sanger2Ill.sh s_3.1.ReadFilter.sanger.fastq > s_3.1.fastq
 # Sanger2Ill.sh s_3.2.ReadFilter.sanger.fastq > s_3.2.fastq

