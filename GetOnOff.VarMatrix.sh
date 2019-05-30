
#!/bin/sh 

source ~/.bash_function

# $1=s_1.bam.sorted.bam.variation.pileup.D20.vcf.v4.snp.out.RS
# $2=s_1.bam.sorted.bam.variation.pileup.D20.vcf.v4.indel.out.RS
 TILE=~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.bed
# TILE=~/Genome/SureSelect/SureSelect_All_Exon_50mb_with_annotation_hg19_bed

if [ $# -eq 2 ]; then

	## divide to on and off target
	## single
	perl -F'\t' -anle'print join "\t", @F[0..2],(join ";",@F[3..$#F])' $1 > $1.tmp
	intersectBed -a $1.tmp -b $TILE -u | sed 's/;/\t/g' > $1.OnTarget
	intersectBed -a $1.tmp -b $TILE -v | sed 's/;/\t/g' > $1.OffTarget
	## INDEL
	perl -F'\t' -anle'print join "\t", @F[0..2],(join ";",@F[3..$#F])' $2 > $2.tmp
	intersectBed -a $2.tmp -b $TILE -u | sed 's/;/\t/g' > $2.OnTarget
	intersectBed -a $2.tmp -b $TILE -v | sed 's/;/\t/g' > $2.OffTarget
	## Rearrange
	#perl -F'\t' -anle'@F[15..18]=@F[18,15..17];($t,$s,$e)=split /\|/,$F[18]; @F[1,2]=($s-1,$e) if $t eq "deletion";print join "\t",@F' $2.OffTarget > $2.OffTarget.tmp
	#mv -f $2.OffTarget.tmp $2.OffTarget

	#perl -F'\t' -anle'@F[15..18]=@F[18,15..17];($t,$s,$e)=split /\|/,$F[18]; @F[1,2]=($s-1,$e) if $t eq "deletion";print join "\t",@F' $2.OnTarget > $2.OnTarget.tmp
	#mv -f $2.OnTarget.tmp $2.OnTarget


	## get Var dist matrix
	## single
	perl -F'\t' -MMin -asne'chomp@F;$type= $F[15]=~/\d+/ ?"dbSNP":"novel";  $F[6]=~s/ \d+$//; if($F[6]=~/CDS/){ $F[6] = $F[11] eq $F[12]?"CDS Syn":"CDS Nonsyn"} $h{"$F[0]:$F[2]"}{"$type-$F[6]"}++ }{ mmfss("$out.Var.count",%h)' -- -out=$1.OnTarget $1.OnTarget
	perl -F'\t' -MMin -asne'chomp@F;$type= $F[15]=~/\d+/ ?"dbSNP":"novel";  $F[6]=~s/ \d+$//; if($F[6]=~/CDS/){ $F[6] = $F[11] eq $F[12]?"CDS Syn":"CDS Nonsyn"} $h{"$F[0]:$F[2]"}{"$type-$F[6]"}++ }{ mmfss("$out.Var.count",%h)' -- -out=$1.OffTarget $1.OffTarget
	## INDEL
	perl -F'\t' -MMin -asne'chomp@F;$type= $F[15]=~/\d+/ ?"dbSNP":"novel";  $F[6]=~s/ \d+$//; if($F[6]=~/CDS/){ $F[6] = $F[11] eq $F[12]?"CDS Syn":"CDS Nonsyn"} $h{"$F[0]:$F[2]"}{"$type-$F[6]"}++ }{ mmfss("$out.Var.count",%h)' -- -out=$2.OnTarget $2.OnTarget
	perl -F'\t' -MMin -asne'chomp@F;$type= $F[15]=~/\d+/ ?"dbSNP":"novel";  $F[6]=~s/ \d+$//; if($F[6]=~/CDS/){ $F[6] = $F[11] eq $F[12]?"CDS Syn":"CDS Nonsyn"} $h{"$F[0]:$F[2]"}{"$type-$F[6]"}++ }{ mmfss("$out.Var.count",%h)' -- -out=$2.OffTarget $2.OffTarget

	## get Var Stat
	perl -F'\t' -MMin -anle'@col=split "\t" if $.==1; @idx=grep { $F[$_]>0 } 1..$#F; map { $h{$col[$_]}++ } @idx }{ h1c(%h)' $1.OnTarget.Var.count.txt > $1.OnTarget.Var.count.summary
	perl -F'\t' -MMin -anle'@col=split "\t" if $.==1; @idx=grep { $F[$_]>0 } 1..$#F; map { $h{$col[$_]}++ } @idx }{ h1c(%h)' $1.OffTarget.Var.count.txt > $1.OffTarget.Var.count.summary

	perl -F'\t' -MMin -anle'@col=split "\t" if $.==1; @idx=grep { $F[$_]>0 } 1..$#F; map { $h{$col[$_]}++ } @idx }{ h1c(%h)' $2.OnTarget.Var.count.txt > $2.OnTarget.Var.count.summary
	perl -F'\t' -MMin -anle'@col=split "\t" if $.==1; @idx=grep { $F[$_]>0 } 1..$#F; map { $h{$col[$_]}++ } @idx }{ h1c(%h)' $2.OffTarget.Var.count.txt > $2.OffTarget.Var.count.summary
	
	perl -F'\t' -MMin -ane'chomp@F;$h{$F[0]}{$ARGV}=$F[1]}{mmfss("merge.summary",%h)' *Var.count.summary
else
	usage snp indel
fi
