#!/bin/bash

. ~/.bash_function

if [ $# -eq 2 ] & [ -f "$2" ];
then

perl -F"\t" -MMin -asnle'
BEGIN{ %aa=aa_hash() }

$var = $F[$col-1];
$str ="";
if($.==1){ print join "\t", @F, "oneLetter" }

if( $var=~ /(\w{3})(\d+)_(\w{3})(\d+)ins(\w+)/ ){
    $pre = $aa{$1}.$2."_".$aa{$3}.$4."ins";
    $remain = $5;
    @aa = $remain =~ /(\w{3})/g;

    $str = $pre.(join "", map { $aa{$_} } @aa);
	#print join "\t", $var, $str, $remain;
}elsif( $var =~ /(\w{3})(\d+)_(\w{3})(\d+)del/ ){
    $str = $aa{$1}.$2."_".$aa{$3}.$4."del";
}elsif( $var =~ /(\w{3})(\d+)del/ ){
	$str = $aa{$1}.$2."del"
}elsif( $var =~/(\w{3})(\d+)fs/ ){
	$str = $aa{$1}.$2."fs";
}elsif( $var =~/(\w{3})(\d+)\*/ ){
	$str = $aa{$1}.$2."*"
}elsif( $var =~/(\w{3})(\d+)(\w{3})/ ){
	$str = $aa{$1}.$2.$aa{$3};
}

$str = $str || ".";

if($.>1){ print join "\t", @F, $str }

' -- -col=$1 $2 > $2.3to1
#' -- -col=9 LungCancer_OnlyXeno.v1 

else
	usage "column_number filename"
fi


#1. p.Ala775_Gly776insTyrValMetAla
#2. p.Ser272_Tyr273del
#3. p.Val1578del 
#4. p.His179fs
#5. p.Arg796*
#6. p.Arg796Ser
