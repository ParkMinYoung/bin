#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

perl -F'\t' -MSet::IntSpan::Fast -asnle'
BEGIN{
	@colA = map { $_-1 } split ",", $keyA;
	@colB = map { $_-1 } split ",", $keyB;
	@colV = map { $_-1 } split ",", $value;
}

if(@ARGV){
	$key = join "\t", @F[@colB];
	if($.==1){

		$setA=Set::IntSpan::Fast->new( 0..$#F );
#		print $setA->as_string();
		$setB=Set::IntSpan::Fast->new( @colB );
#		print $setB->as_string();

		$xor  = $setA->xor($setB);
#		print $xor->as_string();
		@Add_col = $xor->as_array();

		if($value){
			@Add_col=@colV;
		}

	}

	$h{$key} = join "\t", @F[@Add_col];
	$space = join "\t", (("NA") x @Add_col);

	
}else{
	$key = join "\t", @F[@colA];
	
	if ( $h{$key} ){
		print join "\t", $_, $h{$key};
	}else{
		print join "\t", $_, $space;
	}

}' -- -keyA=$3 -keyB=$4 -value=$5 $2 $1

#}' merge.vcf.sort.annotated.snpeff.dbNSFP2.vcf.GT.txt merge.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt > merge.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT

else
	usage "XXX YYY \"1,2,3,4,5\" \"1,2,3,4,5\" \"3,5,6,7,9,10\" ## output format : X + Y "
fi


