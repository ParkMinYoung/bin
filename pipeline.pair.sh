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
	perl -F'\t' -anle'if(/^#/){
	print STDOUT $_;
	print STDERR $_;
	}elsif(@F>10 && $F[4]=~/,/){
	print STDERR $_
	}else{print STDOUT $_}
	' 2> $1.fail 1> $1.pass

	cp $1.pass $1.pass.vcf
	vcf2CommonCall.sh $1.pass.vcf	
	for i in *gz.pass.vcf *gz.fail *gz.pass.vcf.CommonCall.vcf; do echo -ne "$i\t" && grep ^chr -c $i;done > count.txt


	vcf2Annotation.pair.sh $1.pass.vcf

	# passed variation vcf to bgzip 
	rm -rf $1.pass.gz
	bgzip $1.pass

	############################
	# passed bcf working 
	############################

	# get stat
	vcf-stats $1.pass.gz > $1.pass.gz.stats
	# get geno
	zcat $1.pass.gz | vcf-to-tab > $1.pass.gz.geno

	# get genotype type count
	# line number is variation call [No sample pair filter]
	# only filter depth and genotype qaulity [GP, GQ]
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
	}' -- -depth=10 -gq=50 > $1.pass.NoSamplePairFilter.ObervedGenotype.VennInput

	# get VennDiagram
	# VennDiagram_1.sh $1.pass.ObervedGenotype.VennInput.pdf $1.pass.ObervedGenotype.VennInput "Observed Variations"



		# get pair sample filter 
		# pair genotype depth and GQ 

        zcat $1.pass.gz | \
#        zcat KKM.tmp.bam.bcf.var.raw.vcf.gz.pass.gz | \
        perl -F'\t' -MList::MoreUtils=firstidx,all,pairwise,indexes,natatime  -MMin -asnle'next if !/^chr/;
        @l=split ":",$F[8];
        $in_DP=firstidx { $_ eq "DP" } @l;
        $in_GQ=firstidx { $_ eq "GQ" } @l;
        $in_GT=firstidx { $_ eq "GT" } @l;
        @data=@F[9..$#F];
        if(++$f==1){ print join "\t", map { "S$_" } 1 .. @data/2 }
        @depth=map{ ${[split ":", $_]}[$in_DP] } @data;
        @GQs=map{ ${[split ":", $_]}[$in_GQ] } @data;
        @GTs=map{ ${[split ":", $_]}[$in_GT] } @data;
        @test=pairwise { 1 if $a>=$depth && $b>=$gq } @depth, @GQs;
#       print "[@test]";
        $it = natatime 2, @test;
        @Ntest=();
        while (my @vals = $it->()){
                if($vals[0]+$vals[1] == 2){
                push @Ntest, 1;
                }else{ push @Ntest, 0 }
        }
        @index=indexes { $_ == 1 } @Ntest;

        if ( @index ){
        @out=();
        @out[@index]=@GTs[@index];
#       print "@index|@depth|@GQs|@GTs|@out";
#       print join "\t", map { "G:$.:$_" if $_} @out
        print join "\t", map { "G:$." if $_} @out
        }' -- -depth=10 -gq=50  > $1.pass.SamplePairFilter.ObervedGenotype.VennInput 

        # get VennDiagram
        VennDiagram_1.sh $1.pass.SamplePairFilter.ObervedGenotype.VennInput.pdf $1.pass.SamplePairFilter.ObervedGenotype.VennInput "Filterd Pair Samples"


        zcat $1.pass.gz | \
#       zcat KKM.tmp.bam.bcf.var.raw.vcf.gz.pass.gz | \
        perl -F'\t' -MList::MoreUtils=firstidx,all,pairwise,indexes,natatime  -MMin -asnle'next if !/^chr/;
        @l=split ":",$F[8];
        $in_DP=firstidx { $_ eq "DP" } @l;
        $in_GQ=firstidx { $_ eq "GQ" } @l;
        $in_GT=firstidx { $_ eq "GT" } @l;
        @data=@F[9..$#F];
        if(++$f==1){ print join "\t", map { "S$_" } 1 .. @data/2 }
        @depth=map{ ${[split ":", $_]}[$in_DP] } @data;
        @GQs=map{ ${[split ":", $_]}[$in_GQ] } @data;
        @GTs=map{ ${[split ":", $_]}[$in_GT] } @data;
        @test=pairwise { 1 if $a>=$depth && $b>=$gq } @depth, @GQs;
#       print "[@test]";
        $it = natatime 2, @test;
        @Ntest=();
        while (my @vals = $it->()){
                if($vals[0]+$vals[1] == 2){
                push @Ntest, @vals;
                }else{ push @Ntest, (0,0) }
        }
        @index=indexes { $_ == 1 } @Ntest;
        if ( @index == @data ){
        @out=();
        @out[@index]=@GTs[@index];
#       print "@index|@depth|@GQs|@GTs|@out";
#       print join "\t", map { "G:$.:$_" if $_} @out
#       print join "\t", map { "G:$." if $_} @out
        @pair=();
        $it = natatime 2, @out;
        while (my @vals = $it->()){
                push @pair, join ":", "G$.",@vals;
        }
        print join "\t", @pair;
        }' -- -depth=10 -gq=50 > $1.pass.SamplePairFilter.geno.ObervedGenotype.VennInput

        # get VennDiagram
        VennDiagram.sh $1.pass.SamplePairFilter.geno.ObervedGenotype.VennInput.pdf  $1.pass.SamplePairFilter.geno.ObervedGenotype.VennInput "Shared Genotype Pair Samples"


		# get genotype pattern count
        zcat $1.pass.gz | \
#       zcat KKM.tmp.bam.bcf.var.raw.vcf.gz.pass.gz | \
        perl -F'\t' -MMin -MList::MoreUtils=firstidx,all,pairwise,indexes,natatime,uniq  -MMin -asne'next if !/^chr/;
        chomp@F;
        @l=split ":",$F[8];
        $in_DP=firstidx { $_ eq "DP" } @l;
        $in_GQ=firstidx { $_ eq "GQ" } @l;
        $in_GT=firstidx { $_ eq "GT" } @l;
        @data=@F[9..$#F];
        if(++$f==1){ print join "\t", map { "S$_" } 1 .. @data/2 }
        @depth=map{ ${[split ":", $_]}[$in_DP] } @data;
        @GQs=map{ ${[split ":", $_]}[$in_GQ] } @data;
        @GTs=map{ ${[split ":", $_]}[$in_GT] } @data;
        @test=pairwise { 1 if $a>=$depth && $b>=$gq } @depth, @GQs;
#       print "[@test]";
        $it = natatime 2, @test;
        @Ntest=();
        while (my @vals = $it->()){
                if($vals[0]+$vals[1] == 2){
                push @Ntest, @vals;
                }else{ push @Ntest, (0,0) }
        }
        @index=indexes { $_ == 1 } @Ntest;
        if ( @index == @data ){
        @out=();
        @out[@index]=@GTs[@index];
#       print "@index|@depth|@GQs|@GTs|@out";
#       print join "\t", map { "G:$.:$_" if $_} @out
#       print join "\t", map { "G:$." if $_} @out
        @pair=();
        $it = natatime 2, @out;
        while (my @vals = $it->()){
                push @pair, join ":", @vals;
        }
        my @count = uniq @pair;
        if( @count == 1){
                @geno=split ":",$count[0];
                $h{$geno[0]}{$geno[1]}++;
        }
        }
        }{mmfss("common.genotype.count",%h)' -- -depth=10 -gq=50

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

else
	usage "XXXX.bam.bcf.var.raw.vcf.gz"
fi





########################################################################################################################
########################################################################################################################







########################################################################################################################
########################################################################################################################




