perl -F'\t' -anle'
if(@ARGV)
{
	($chr,$bp,$rs)=split ":",$F[0]; 
	($s,$e)=split /\.\./ ,$bp;
#print "$s,$e";
	$chr=~s/chr//;
	if(length $F[1] >1){
		$s++;
	}elsif(length $F[2] >1){
		$e= $s + length $F[2] - length $F[1];
	}

	@l=();
	$s == $e ? $e=0 : 1;

	map { push @l,$_  if $_ > 1 }  $s, $e;

	$key= "$chr:$s";
#$key= "$chr:".(join "-",@l);
#	print $F[15];	
	$h{$key}=$F[15];
#print $key;

}else{
	$F[10]=~/(\w+:\d+)/;
	$p=$1;
	print "$_\t$h{$p}"
}
' 96samples.assoc Call.snp.raw.vcf.vep.txt > Call.snp.raw.vcf.vep.txt.pvalue

