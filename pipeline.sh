#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

	# $1=s_4.bam.sorted.bam.bcf.var.raw.vcf.gz

	# get original stat
	vcf-stats $1 > $1.stats


	# filter out 
	# fail : variation including multiple var
	# pass
	zcat $1 | \
	perl -F'\t' -anle'if(@F>10 && $F[4]=~/,/){
	print STDERR $_
	}else{print STDOUT $_}
	' 2> $1.fail 1> $1.pass

	cp $1.pass $1.pass.vcf
	vcf2Annotation.sh $1.pass.vcf

	perl -F'\t' -anle'if(@ARGV){$h{"$F[0]:$F[2]"}="$F[0]:$F[4]"}else{ $key="$F[0]:$F[2]"; if($h{$key}){ $F[19]=$h{$key}; print join "\t", @F} }' $1.pass.vcf.link $1.pass.vcf.RS > $1.pass.vcf.RS.link

	perl -F'\t' -MList::MoreUtils=firstidx -anle'if(@ARGV){$h{$F[19]}=$_}
	else{
			next if !/^chr/;
			$key="$F[0]:$F[1]";
			@l=split ":",$F[8];
			$in_DP=firstidx { $_ eq "DP" } @l;
			$in_GQ=firstidx { $_ eq "GQ" } @l;
			$in_GT=firstidx { $_ eq "GT" } @l;
			@data=@F[9..$#F];
			@depth=map{ ${[split ":", $_]}[$in_DP] } @data;
			@GQs=map{ ${[split ":", $_]}[$in_GQ] } @data;
			@GTs=map{ ${[split ":", $_]}[$in_GT] } @data;
			print join "\t", @F[0..8],@depth,@GQs,@GTs,$h{$key}
	}' $1.pass.vcf.RS.link $1.pass.vcf > $1.pass.vcf.final



	# passed variation vcf to bgzip 
	bgzip $1.pass

	############################
	# passed bcf working 
	############################

	# get stat
	vcf-stats $1.pass.gz > $1.pass.gz.stats
	# get geno
	zcat $1.pass.gz | vcf-to-tab > $1.pass.gz.geno


	# get genotype type count
	zcat $1.pass.gz | \
#	zcat s_4.bam.sorted.bam.bcf.var.raw.vcf.gz | \
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
	}' -- -depth=10 -gq=50 > $1.pass.ObervedGenotype.VennInput

	# get VennDiagram
	VennDiagram_1.sh $1.pass.ObervedGenotype.VennInput.pdf $1.pass.ObervedGenotype.VennInput "Observed Variations"

	
	# get genotype type count
	zcat $1.pass.gz | \
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
	}{ h1c(%h)' -- -depth=10 -gq=50  > $1.pass.gz.TypeCnt


	# get VennInput
	zcat $1.pass.gz | \
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
	}' -- -depth=10 -gq=50 > $1.pass.gz.VennInput

	# get VennDiagram
	VennDiagram.sh $1.pass.gz.VennInput.pdf $1.pass.gz.VennInput "Filtered Variation"



else
	usage "XXXX.bam.bcf.var.raw.vcf.gz"
fi
