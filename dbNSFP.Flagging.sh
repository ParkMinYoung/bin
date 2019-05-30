

perl -F'\t' -MMin -MList::MoreUtils=any -asne'
chomp@F;
if($.==1){
	print join "\t", @F, "dbNSFP_flag\n";
}else{
	$dbNSFP=0;
	if( any { /\w+/ } @F[26..30] ){
		$dbNSFP=1;
	}
	print join "\t", @F, "$dbNSFP\n";

	$h{$F[5]}{$dbNSFP}++;
	$h{total}{$dbNSFP}++;
	$h{$F[5]}{total}++;
	$h{total}{total}++;
}

}{ mmfss("$file.dbNSFPCount", %h) ' -- -file=$1 $1 > $1.dbNSFP.flag

