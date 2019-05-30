#!/bin/sh

. ~/.bash_function


if [ -f "$1" ]; then 

		vcf2Genotype.num.sh $1 > $1.num

###### modify
####		head -1 $1.num | tr "\t" "\n" > header
####		perl -nle'push @l, $_ if !/(115026|34629)/ }{ print join "\n", @l, 115026,34629' header > header.reorder
####		OrderColumn.sh header.reorder $1.num | perl -nle'if($.==1){s/115026/X-1/; s/34629/X-2/} print' > $1.num.bak
####		\mv -f $1.num.bak $1.num
####
###### modify

		perl -F'\t' -anle'
		BEGIN{
						$h{"0/0"}=-1;
						$h{"0/1"}=0;
						$h{"1/1"}=1;
						$h{"./."}=-2;
						$h{"."}=-2
		}
		@data = @F[6..$#F];
		if($.==1){
				print join "\t", "Pos", @data
		}else{
				@num_geno = map { defined $h{$_} ? $h{$_} : -2 } @data;
				 
				%geno = ();
				map { $geno{$_}++ } @num_geno;
				next if ( keys %geno )+0 == 1;
				#print join "\t", "$F[0]_$F[1]_$F[5]", @num_geno;
				print join "\t", "$F[0]_$F[1]_$F[5]_".$., @num_geno;
		} ' $1.num > $1.num.score

		grep -v "\-2" -w $1.num.score  > $1.num.score.call
		R CMD BATCH --no-save --no-restore "--args $1.num.score $1.num.score.call" ~/src/short_read_assembly/bin/R/Genotype2Heatmap.R

		# VCF concordance
		VCF2ConcordantPlot.sh $1
	
		Concordance=$(basename $1 .vcf).VAR.txt
		dos2unix $Concordance
		TableColValFilter.sh 7 0.9 $Concordance > $Concordance.filter
		#OrderedValueListFromKey.sh 4 5 7 $Concordance.filter
		OrderedValueListFromKey.sh 5 4 7 $Concordance.filter

else
	usage "XXX.vcf"
fi

