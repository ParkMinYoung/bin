#!/bin/sh 

source ~/.bash_function



if [ -f "$1" ];then
perl -F'\t' -MMin -MList::MoreUtils=firstidx,natatime,uniq,all,indexes -MList::Compare -ane'
if(/^#/){print}
else{
	chomp@F;
	@info=@F[0..4];
	$key = "$F[0]-$F[1]";
	@data=@F[9..$#F];
	@l=split ":",$F[8];


#$in_DP=firstidx { $_ eq "DP" } @l;
#$in_GQ=firstidx { $_ eq "GQ" } @l;
	$in_GT=firstidx { $_ eq "GT" } @l;

#@DPs=  map{ ${[split ":", $_]}[$in_DP] } @data;
#@GQs=  map{ ${[split ":", $_]}[$in_GQ] } @data;
	@GTs=  map{ ${[split ":", $_]}[$in_GT] } @data;

    $it = natatime 2, @GTs;
	while (my @vals = $it->())
	{
		$pair = join ":", @vals;
		if( $vals[0] eq $vals[1]){
			$h{$key}{Match}++
		}elsif( $pair =~ /\.\/\./ ){
			$h{$key}{NoCall}++
		}else{
			$h{$key}{$pair}++;
		}
	}


}

}{ mmfss("GT.pair.count",%h)
' $1


perl -F'\t' -anle'
if($.==1){
	@header=@F;
	print "$_\t#Candidates\t#MaxMisMatchPair\tCandidatesList"
}else{
	@list=();
	@list_num=();

	for ( 1..6 ){
		if($F[$_] >= 2){
			push @list, $header[$_];
			push @list_num, $F[$_];
		}
	}

	@sort_value = sort {$b<=>$a} @list_num;
	$max = $sort_value[0];
	print join "\t", @F, @list+0, $max, (join ",",@list) if @list;
}' GT.pair.count.txt | sort -nr -k 11 > GT.pair.count.candiate.txt

cut -f11 GT.pair.count.candiate.txt | sort | uniq -c | awk '{print $2,"\t",$1}' > GT.pair.count.candiate.MismatchPair.txt

perl -F'\t' -anle'
if(@ARGV){
	$h{$F[0]}++
}else{ 
	if(/^#/){
		print
	}elsif($h{"$F[0]-$F[1]"}){
		print
	}
} ' GT.pair.count.candiate.txt $1 > $1.GT.pair.candidate.vcf




else
        usage "XXX.vcf" 
fi


########################################## 
# vcf format description
########################################## 

# chr
# pos
# rs
# ref
# var

# per row (x sample count)
# Allele genotype
# number genotype
# depth
# genotype quality
# genotype ref, var count 

