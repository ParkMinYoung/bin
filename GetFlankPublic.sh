#!/bin/sh

. ~/.bash_function

if [ -f "$1" ]; then

		## get flankig seq

		ref=/home/adminrig/Genome/BosTau/ContentCandidates/Merging/Reference/UMD.3.1.fa
		BED=$1
		LEN=250

		# SNV ref allele
		# bedtools getfasta -fi $ref -bed $BED -fo $BED.ref_allele -tab   &> $BED.ref_allele.stderr
		perl -F'\t' -anle'print join "\t", @F[0..2], "$F[0]:$F[1]-$F[2]"' $BED | bedtools getfasta -fi $ref -bed stdin -fo $BED.ref_allele -tab -name &> $BED.ref_allele.stderr

		# SNV left flanking seq
		perl -F'\t' -anle'print join "\t", @F[0..2], "$F[0]:$F[1]-$F[2]"' $BED | bedtools flank -i stdin -g $ref.genome -l $LEN -r 0 | bedtools getfasta -fi $ref -bed stdin -fo $BED.left -tab -name &> $BED.left.stderr


		# SNV right flanking seq
		perl -F'\t' -anle'print join "\t", @F[0..2], "$F[0]:$F[1]-$F[2]"' $BED | bedtools flank -i stdin -g $ref.genome -l 0 -r $LEN | bedtools getfasta -fi $ref -bed stdin -fo $BED.right -tab -name &> $BED.right.stderr


		# Merging with BED
		perl -F'\t' -anle'print join "\t", $_ , "$F[0]:$F[1]-$F[2]"' $BED > $BED.key

		join.sh $BED.key $BED.left 9 1 2 > tmp1
		join.sh tmp1 $BED.ref_allele 9 1 2 > tmp2
		join.sh tmp2 $BED.right 9 1 2 > $BED.flanking

		rm -rf $BED.key tmp*

		DIR=$BED.`datenum.sh`
		mkdir $DIR

		mv `ls $BED.* | grep -v flanking` $DIR
		
		FindRefAllele.sh $BED.flanking 4 5 11 > $BED.flanking.FindRefAllele

else
	usage "XXX.bed"
fi


