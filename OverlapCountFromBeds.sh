#!/bin/sh


. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

perl -F"\t" -anle'
$k=join ":",@F[0..2]; 
if(@ARGV){
	$A=$ARGV;
	$Ac++;
	$h{$k}{A}++ 
}else{
	$B=$ARGV; 
	$Bc++; 
	$h{$k}{B}++ 
} 
}{ 
	for ( keys %h ){ 
		$intersect++ if keys %{ $h{$_} } == 2 
	}; 
	print join "\t", "$A uniq : $B uniq : overlap : $A total : $B total = ", $Ac - $intersect, $Bc - $intersect , $intersect, $Ac, $Bc
' $1 $2

else
	usage "XXX.bed YYY.bed"
fi

