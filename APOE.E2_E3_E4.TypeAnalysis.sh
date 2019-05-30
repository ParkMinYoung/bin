#!/bin/sh

. ~/.bash_function

if [ -f "Genotype" ];then


#######################
## get APOE genotype ##
#######################

perl -nle'
BEGIN{
		$rs{"AX-59878588"}="rs429358"; 
	#	$rs{"AX-95861335"}="rs429358"; 
		$rs{"AX-59878593"}="rs7412"
} 
($snp, $remain)=split "\t",$_,2; 

#print STDERR $snp;
if($.==1){
	print
}elsif( $rs{$snp} ){ 
	print join "\t", $rs{$snp}, $remain 
}' Genotype > APOE.genotype


##########################
## get APOE Type Result ##
##########################

perl -MMin -sle' 
BEGIN{
		$type{"TT"}="E2";
		$type{"TC"}="E3";
		$type{"CT"}="E3r";
		$type{"CC"}="E4";
}

%h=read_matrix($file); 

@sample = sort keys %h;
@rs = qw/rs429358 rs7412/;


print join "\t", qw/sample_id call type1 type2 Type rs429358 rs7412/;
for $sam ( @sample ){
	$rs429358 = $h{$sam}{"rs429358"};
	$rs7412   = $h{$sam}{"rs7412"};


	if($rs429358=~/NN/ || $rs7412=~/NN/){
		print join "\t", $sam, "Nocall","","","Nocall",$rs429358, $rs7412;
	}else{
		$rs429358=~/(\w)(\w)/;
		($A_1,$B_1)=($1,$2);
		$rs7412=~/(\w)(\w)/;
		($A_2,$B_2)=($1,$2);

		$type1= $A_1.$A_2;
		$type2= $B_1.$B_2;

		$type = join "/", sort( $type{$type1}, $type{$type2} );

		print join "\t", $sam, "call", $type1, $type2, $type, $rs429358, $rs7412;
	}

}


' -- -file=APOE.genotype > APOE.genotype.AnalysisResult

cut -f5 APOE.genotype.AnalysisResult | grep -v ^Type | sort | uniq -c | awk '{print $2,"\t",$1}' > APOE.genotype.AnalysisResult.count

else
	usage "Genotype"
fi

