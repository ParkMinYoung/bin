#!/bin/bash

. ~/.bash_function

		if [ $# -eq 2 ];then

		[ ! -d $2 ] && mkdir $2

		BAM=$(readlink -f $1)
		cd $2

		ln -s $BAM ./
		bamtools split -in $( basename $BAM ) -reference

		for i in `ls *bam | grep REF` 
			do 
			echo `date`
			samtools sort -o $i.sort.bam $i
			samtools index $i.sort.bam
			# Bam_sort_index.sh $i
		done
		  
		mkdir trash && mv `ls *bam | grep REF| grep -v sort` trash
		rename ".bam.sort" "" `ls | grep sort`

else
		usage "BAM DIR"

fi


