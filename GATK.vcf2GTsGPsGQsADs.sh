perl -F'\t' -MList::MoreUtils=firstidx -anle'next if @F <9;
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
	$header= join "\t", @info, ((@data)x5); 
	$header =~ s/DNALink\.PE\.//g;
	print $header;
}
else{
	@AA=@GTs;
	map { s/\///; s/\./N/g; s/0/$info[3]/g; s/1/$info[4]/g } @AA;
	print join "\t", @info,@AA,@GTs,@DPs,@GQs,@ADs;
}' $@ 

