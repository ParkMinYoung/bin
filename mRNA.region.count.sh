perl -F'\t' -MMin -ane'
chomp(@F);
$current=$F[3];

if($F[7] eq "."){
	$h{$ARGV}{unmapped}++;
}elsif($current eq $pre){
	next;
}else{
	$h{$ARGV}{$F[7]}++;
}

$pre=$current;
}{ mmfss("RNASeq.count", %h)' `find  | grep miRNA$` 

