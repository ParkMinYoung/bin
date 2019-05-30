#!/bin/bash

. ~/.bash_function

GOI=${2:-"GOI"}


if [ -f "$1" ] && [ -f "$GOI" ];then



		# execute time : 2019-03-04 14:38:37 : link *selectsample.snpeff.dbNSFP.vartype.gwas.opl.vcf.variant_summary.txt to here 
		ln -s $1 ./


		# execute time : 2019-02-27 15:10:34 : Gene, High & Moderate, Affected, only one variant
		perl -nle'@F=split "\t", $_, 35;  if(@ARGV){ $h{"`$F[0]"}++ }else{ if( ! $c++ ){ print }elsif( $h{$F[11]} && $F[10] =~/MODERATE|HIGH/ && ! $line{ join ":",@F[0..4] }++ && $F[33] > 0) { print  } }' $GOI $1 > Variants # 904.selectsample.snpeff.dbNSFP.vartype.gwas.opl.vcf.variant_summary.txt.step1 


		# execute time : 2019-02-27 15:32:14 : create symlink to simplify
		#ln -s 904.selectsample.snpeff.dbNSFP.vartype.gwas.opl.vcf.variant_summary.txt.step1 Variants


		# execute time : 2019-02-27 15:32:29 : simple version
		cut -f1-41 Variants > Variants.simple


		# execute time : 2019-02-27 15:32:58 : filter affected sample number < 40 (filter out for some criteria)
		# perl -F'\t' -anle'if($.==1){print}elsif($F[33]<40){print}' Variants > step1 
		ln -s Variants step1

		# get number of samples 
		NumOfSamples=$(( $(( $( head -1 step1 | tr "\t" "\n" | wc -l ) - 40  )) / 4  ))
		NumOfID_Column=$(( 40 + $NumOfSamples ))


		# execute time : 2019-02-27 15:49:43 : 
		#perl -F'\t' -MMin -asne'BEGIN{ $ab="\`0/1"; $bb="\`1/1"; $g{$ab}=1; $g{$bb}=2; $num+=40 } $k=join "\t", ( @F[11,0,1,3,4,9,10,17..22,33], $F[39].$F[40] ); if($.==1){ @head=@F}else{ map { $h{$k}{$head[$_]} = $g{$F[$_]} } 41..$num } }{ mmfss("step2", %h)' -- -num=$NumOfSamples step1
		perl -F'\t' -MMin -asne'BEGIN{ $ab="\`0/1"; $bb="\`1/1"; $g{$ab}=1; $g{$bb}=2; $num+=40 } $k=join "\t", ( @F[11,0,1,3,4,9,10,17..22,33], $F[39].$F[40] ); if($.==1){ @head=@F}else{ map { $h{$k}{$head[$_]} = $F[$_] } 41..$num } }{ mmfss("step2", %h)' -- -num=$NumOfSamples step1


		# execute time : 2019-02-27 15:59:51 : 
		AddHeader.sh step2.txt step2 Gene_Name CHROM POS REF ALT Effect Impact HGVS.c HGVS.p "cDNA.pos/cDNA.length" "CDS.pos/CDS.length" "AA.pos/AA.length" Distance NumSamplesAffected List $(head -1 step2.txt | cut -f2-$NumOfID_Column)


		# execute time : 2019-02-27 16:00:47 : 
		ln -s step2 Variants.bySNVs


		# execute time : 2019-02-27 16:00:54 : 
		tblmutate -e  '$gene = "`$Gene"; $gene' -l NewGene  /home/adminrig/Genome/OncoKB/allActionableVariants.txt > allActionableVariants.txt


		# execute time : 2019-02-27 21:19:59 : 
		cut -f1-15 Variants.bySNVs > Variants.bySNVs.simple


		# execute time : 2019-02-27 21:20:20 : 
		ThreeLetter2OneLetter.sh 9 Variants.bySNVs.simple 


		# execute time : 2019-02-27 21:42:36 : 
		Add.CancerDB_info.sh Variants.bySNVs.simple.3to1 > Variants.bySNVs.simple.3to1.CancerDB


		# execute time : 2019-02-27 21:45:04 : 
		tab2xlsx.sh Variants.bySNVs.simple.3to1.CancerDB


		# execute time : 2019-02-27 21:47:33 : link
		#RmdLink.sh Variants.bySNVs.simple.3to1.CancerDB.xlsx /home/adminrig/workspace.min/DNALink/Project/DNALink.PDX/_APC/

else
	
	usage "/dlst/wes/workspace.krc/PDX/20181214/SCP/SCP.selectsample.snpeff.dbNSFP.vartype.gwas.opl.vcf.variant_summary.txt [GOI]"

fi


