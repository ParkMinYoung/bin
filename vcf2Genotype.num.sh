perl -F'\t' -MList::MoreUtils=firstidx -anle'
        next if /^##/;

		if( /^#CHROM/ ){
			print join "\t", qw/CHROM START END REF ALT ID/, @F[9..$#F];
		}else{

			@l=split ":",$F[8];
			$in_GT=firstidx { $_ eq "GT" } @l;
			@data=@F[9..$#F];
			@GTs=map{ ${[split ":", $_]}[$in_GT] } @data;


			$F[5]=$F[2];
			$F[2] = $F[1] + length($F[3])-1;
			
			## modified section
			$F[5]= $1 if /VARTYPE=(\w+)/;
			## modified section

			print join "\t", @F[0,1,2,3,4,5], @GTs
		}
' $1
