#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

perl -F'\t' -MSet::IntSpan::Fast -asnle'
BEGIN{

	$cmd1= "map { \$_-1 } $keyA";
	$cmd2= "map { \$_-1 } $keyB";
	$cmd3= "map { \$_-1 } $value";

	@colA = eval($cmd1);
	@colB = eval($cmd2);
	@colV = eval($cmd3);
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
		## 20170504 : add colnames
		$header=join "\t", @F[@Add_col];

	}

	$h{$key} = join "\t", @F[@Add_col];
	$space = join "\t", ((" ") x @Add_col);

	
}else{
	$key = join "\t", @F[@colA];

	if ( ++$c == 1 ){
		## 20170504 : add colnames 
		print join "\t", $_, $header;
	}elsif ( $h{$key} ){
		print join "\t", $_, $h{$key};
	}else {
		print join "\t", $_, $space;
	}

}' -- -keyA=$3 -keyB=$4 -value=$5 $2 $1

#}' merge.vcf.sort.annotated.snpeff.dbNSFP2.vcf.GT.txt merge.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt > merge.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT

else

	usage "XXX YYY \"1..5\" \"1..5\" \"3,5..7,9,10\" ## output format : X + Y "

fi


