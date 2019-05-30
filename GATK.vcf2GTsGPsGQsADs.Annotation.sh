#!/bin/sh
source ~/.bash_function

if [ -f "$1" ] && [ -f "$2" ];then

perl -F'\t' -MList::MoreUtils=firstidx,indexes,uniq -asnle'
if(@ARGV){
		$F[0]=~s/chr//;
		$h{"$F[0]:$F[2]"}=$F[3];
		next
}else{
		next if @F <9;
		@info=@F[0..4];
		@data=@F[9..$#F];
		@l=split ":",$F[8];

		$in_GT=firstidx { $_ eq "GT" } @l;
		$in_AD=firstidx { $_ eq "AD" } @l;
		$in_DP=firstidx { $_ eq "DP" } @l;
		$in_GQ=firstidx { $_ eq "GQ" } @l;

		@GTs=  map{ ${[split ":", $_]}[$in_GT] } @data;
		@ADs=  map{ ${[split ":", $_]}[$in_AD] } @data;
		@DPs=  map{ ${[split ":", $_]}[$in_DP] } @data;
		@GQs=  map{ ${[split ":", $_]}[$in_GQ] } @data;

		@ADs=@DPs if $in_AD eq -1;

		if($F[0]=~s/^#//){
			print join "\t", "rs", @info, ((@data)x5); 
			@sam = @data;
		}
		else{
			@AA=@GTs;
			map { s/\///; s/\./N/g; s/0/$info[3]/g; s/1/$info[4]/g } @AA;
			$id="$F[0]:$F[1]";
			print join "\t", $h{$id},@info,@AA,@GTs,@DPs,@GQs,@ADs;

			@low_depth = indexes { $_ < $depth } @DPs;
			@low_gq    = indexes { $_ < $gq    } @GQs;
			@filter_out_index = uniq @low_depth, @low_gq;
			
			map { print STDERR join "\t", $h{$id}, @info, $data[$_], $sam[$_] } @filter_out_index;
		}
}' -- -depth=10 -gq=50 $1 $2 2> $2.filterout 1> $2.report

else
	echo "rs_infofile : ~/Genome/GPS.lib/RS.region"
	echo "rs_infofile : ~/Genome/GPS.lib/RS.region.genectic"	
	usage "~/Genome/GPS.lib/RS.region XXX.vcf"
fi

