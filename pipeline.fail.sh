#!/bin/sh

source ~/.bash_function

	if [ -f "$1" ];then
	
		rm -rf $1.gz
		bgzip $1;
		tabix -p vcf $1.gz


			zcat $1.gz | \
			perl -F'\t' -MList::MoreUtils=firstidx,all,pairwise,indexes -MMin -asnle'next if !/^chr/;
			@l=split ":",$F[8];
			$in_DP=firstidx { $_ eq "DP" } @l;
			$in_GQ=firstidx { $_ eq "GQ" } @l;
			$in_GT=firstidx { $_ eq "GT" } @l;
			@data=@F[9..$#F];
			if(++$f==1){ print join "\t", map { "S$_" } 1 .. @data }
			@depth=map{ ${[split ":", $_]}[$in_DP] } @data;
			@GQs=map{ ${[split ":", $_]}[$in_GQ] } @data;
			@GTs=map{ ${[split ":", $_]}[$in_GT] } @data;
			@test=pairwise { 1 if $a>=$depth && $b>=$gq } @depth, @GQs;
			@index=indexes { $_ == 1 } @test;
			if ( @index ){
			@out=();
			@out[@index]=@GTs[@index];
		#	print "@index|@depth|@GQs|@GTs|@out";
		#	print join "\t", map { "G:$.:$_" if $_} @out
			print join "\t", map { "G:$." if $_} @out
			}' -- -depth=10 -gq=50 > $1.gz.fail.ObervedGenotype.VennInput

			# get VennDiagram
			VennDiagram_1.sh $1.gz.fail.ObervedGenotype.VennInput.pdf $1.gz.fail.ObervedGenotype.VennInput "Fail Observed Variations"

			
			# get genotype type count
			zcat $1.gz | \
			perl -F'\t' -MList::MoreUtils=firstidx,all -MMin -asnle' next if !/^chr/;
			@l=split ":",$F[8];
			$in_DP=firstidx { $_ eq "DP" } @l;
			$in_GQ=firstidx { $_ eq "GQ" } @l;
			$in_GT=firstidx { $_ eq "GT" } @l;
			@data=@F[9..$#F];
			@depth=map{ ${[split ":", $_]}[$in_DP] } @data;
			@GQs=map{ ${[split ":", $_]}[$in_GQ] } @data;
			@GTs=map{ ${[split ":", $_]}[$in_GT] } @data;
			if ( (all { $_ >= $depth } @depth) && (all { $_ >= $gq } @GQs) ){
			$h{join ",", @GTs}++; $h{Total}++
			}
			}{ h1c(%h)' -- -depth=10 -gq=50  > $1.gz.fail.TypeCnt


			# get VennInput
			zcat $1.gz | \
			perl -F'\t' -MList::MoreUtils=firstidx,all -asnle'
			next if !/^chr/;
			@l=split ":",$F[8];
			$in_DP=firstidx { $_ eq "DP" } @l;
			$in_GQ=firstidx { $_ eq "GQ" } @l;
			$in_GT=firstidx { $_ eq "GT" } @l;
			@data=@F[9..$#F];
			if(++$f==1){ print join "\t", map { "S$_" } 1 .. @data }
			@depth=map{ ${[split ":", $_]}[$in_DP] } @data;
			@GQs  =map{ ${[split ":", $_]}[$in_GQ] } @data;
			@GTs  =map{ ${[split ":", $_]}[$in_GT] } @data;
			if ( (all { $_ >= $depth } @depth) && (all { $_ >= $gq } @GQs) ){
			print join "\t", map { "G:$.:$_" } @GTs
			}' -- -depth=10 -gq=50 > $1.gz.fail.Shared.VennInput

			# get VennDiagram
			VennDiagram.sh $1.gz.fail.Shared.VennInput.pdf $1.gz.fail.Shared.VennInput "shared Variation"

			
			zcat $1.gz | \
			perl -F'\t' -MList::MoreUtils=firstidx,all -asnle'
			print && next if /^#/;
			@l=split ":",$F[8];
			$in_DP=firstidx { $_ eq "DP" } @l;
			$in_GQ=firstidx { $_ eq "GQ" } @l;
			$in_GT=firstidx { $_ eq "GT" } @l;
			@data=@F[9..$#F];
			@depth=map{ ${[split ":", $_]}[$in_DP] } @data;
			@GQs  =map{ ${[split ":", $_]}[$in_GQ] } @data;
			@GTs  =map{ ${[split ":", $_]}[$in_GT] } @data;
			if ( (all { $_ >= $depth } @depth) && (all { $_ >= $gq } @GQs) ){
			print
			}' -- -depth=10 -gq=50 > $1.gz.fail.Shared.vcf

			rm -rf $1.gz.fail.Shared.vcf
			bgzip $1.gz.fail.Shared.vcf
			
			vcf-stats $1.gz.fail.Shared.vcf.gz > $1.gz.fail.Shared.vcf.gz.stats
			zcat $1.gz.fail.Shared.vcf.gz | vcf-to-tab > $1.gz.fail.Shared.vcf.gz.geno

	else
		usage "xxxx.fail.vcf"
	fi


