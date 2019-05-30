perl -F'\t' -MList::MoreUtils=firstidx -anle'
        next if /^##/;

		if( /^#CHROM/ ){
			print join "\t", qw/CHROM START END REF ALT ID/, @F[9..$#F];
		}else{

			@l=split ":",$F[8];
			$in_GT=firstidx { $_ eq "GT" } @l;
			@data=@F[9..$#F];
			@GTs=map{ ${[split ":", $_]}[$in_GT] } @data;

			%h=();
			$h{"0/0"} = "$F[3]/$F[3]";
			$h{"0/1"} = "$F[3]/$F[4]";
			$h{"1/1"} = "$F[4]/$F[4]";
			$h{"./."} = "NN";

			$F[5]=$F[2];
			$F[2] = $F[1] + length($F[3])-1;

			print join "\t", @F[0,1,2,3,4,5],map{ $h{$_} } @GTs
		}
' $1
