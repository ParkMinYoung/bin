#!/bin/sh 

. ~/.bash_function

if [ -f "$1" ];then

#############
# update allele
# perl -F'\t' -anle'print if $.==1; print if "$F[11]$F[12]" =~ /-/' /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab > try

perl -F'\t' -anle'
BEGIN{
	print join "\t", qw/affy ori_A ori_B A B REF ALT ori_pos pos chr/;
}
next if $.==1;
($snv, $s, $flanking, $A, $B, $REF, $ALT, $pos, $chr) =  @F[0,7,10,11,12,13,14,5,4];
($A_ori, $B_ori)= ($A, $B);

if($s eq "-"){
    $flanking =~ tr/ACGTacgt/TGCAtgca/;
    $flanking = reverse( $flanking );
    $A =~ tr/ACGTacgt/TGCAtgca/;
    $B =~ tr/ACGTacgt/TGCAtgca/;

	$A = reverse ( $A );
	$B = reverse ( $B );
}

$ori_pos = $pos;

$flanking =~ /(\w)\[/;
$ref = $1;

if( $A eq "-" ){
	
    $A=$ref;
    $B=$ref.$B;
}elsif( $B eq "-" ){
    $B=$ref;
    $A=$ref.$A;
}

if($REF eq "-"){
	# insertion
	$REF = $ref;
	$ALT = $ref.$ALT;
}elsif($ALT eq "-"){
	# deletion
	$REF = $ref.$REF;
	$ALT = $ref;
	$pos = $pos -1;
}

print join "\t", $snv, $A_ori, $B_ori, $A, $B, $REF, $ALT, $ori_pos, $pos, $chr;
' $1 > $1.allele
# /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab > /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab.allele


echo "$1.allele : id A_ori B_ori VCF_A VCF_B"


cut -f1,6 $1.allele > $1.Affy2RefAllele
# Affy2RefAllele.sh $1 
## output :  $LIB_CSV.Affy2RefAllele


## perl -F'\t' -anle'
## if(@ARGV){
##     $h{$F[0]}{$F[1]}=$F[3];
##     $h{$F[0]}{$F[2]}=$F[4];
## }else{
##     print join "\t", $F[0], $h{$F[0]}{$F[1]}
## }' $1.allele $1.Affy2RefAllele  > $1.Affy2RefAllele.bak
## \mv -f $1.Affy2RefAllele.bak $1.Affy2RefAllele
## 

# create affy ref alt that vcf formed
# perl -F'\t' -anle'if(@ARGV){$h{$F[0]} = $F[1]}else{ $h{$F[3]} ? print join "\t", @F[0,3,4] : print join "\t", @F[0,4,3] } ' $1.Affy2RefAllele $1.allele >  $1.VCFformed.Affy2RefAllele
cut -f1,6,7 $1.allele > $1.VCFformed.Affy2RefAllele

echo "$1.Affy2RefAllele : id VCF_REF_allele"

else
	usage "/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab"
fi

