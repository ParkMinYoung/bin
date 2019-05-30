#!/bin/sh

 zcat $1 | \
 perl -nle'
 if($.%4==1){
		 $l[0]=$_;
 }elsif($.%4==2){
		 s/\./N/g;
		 $l[1]=$_
 }elsif($.%4==3){
		 $l[2]=$_;
 }elsif($.%4==0){
		 print join "\n",@l, (join "",map {chr($_-31)} unpack "C*", $_ );
		 @l=()
 }' | gzip -c > $1.sol2sanger.fastq.gz 


