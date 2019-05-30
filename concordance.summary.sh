#!/bin/sh 

perl -F'\t' -MMin -asne'
 BEGIN{
	$type{1}="SNP";
	$type{2}="INSERT";
	$type{3}="DELETE";
}
chomp@F;
if( ! $file{$ARGV}++ ){ 
	$c=0;
}

if(/^raw SNV/){
	$c++;
	$type = $type{$c};
	$h{$type."_01.uniq1"}{$ARGV} = $F[1];
	$h{$type."_01.uniq2"}{$ARGV} = $F[3];

	$h{"Total_01.uniq1"}{$ARGV} += $F[1];
	$h{"Total_01.uniq2"}{$ARGV} += $F[3];


}elsif(/^filterd/){
	$h{$type."_02.filtered_uniq1"}{$ARGV} = $F[1];
	$h{$type."_02.filtered_uniq2"}{$ARGV} = $F[3];	
	
	$h{"Total_02.filtered_uniq1"}{$ARGV} += $F[1];
	$h{"Total_02.filtered_uniq2"}{$ARGV} += $F[3];	
}elsif(/^intersect\t/){
	$h{$type."_03.intersect_uniq1"}{$ARGV} = $F[1];
	$h{$type."_03.intersect_uniq2"}{$ARGV} = $F[3];	
	$h{$type."_03.intersect"}{$ARGV} = $F[2];	
	
	$h{"Total_03.intersect_uniq1"}{$ARGV} += $F[1];
	$h{"Total_03.intersect_uniq2"}{$ARGV} += $F[3];	
	$h{"Total_03.intersect"}{$ARGV} += $F[2];	
}elsif(/^summary/){
	$f=1;
}elsif(/^count/ && $f){
	$h{$type."_04.conc_match"}{$ARGV} = $F[1];
	$h{$type."_04.conc_mismatch"}{$ARGV} = $F[2];
	$h{$type."_04.conc_sum"}{$ARGV} = $F[3];
	$h{$type."_04.conc_exclude"}{$ARGV} = $F[4];
	$h{$type."_04.conc_rate"}{$ARGV} = $F[2]/$F[3]*100;
	
	$h{"Total_04.conc_match"}{$ARGV} += $F[1];
	$h{"Total_04.conc_mismatch"}{$ARGV} += $F[2];
	$h{"Total_04.conc_sum"}{$ARGV} += $F[3];
	$h{"Total_04.conc_exclude"}{$ARGV} += $F[4];
	$h{"Total_04.conc_rate"}{$ARGV} = $h{"Total_04.conc_mismatch"}{$ARGV}/$h{"Total_04.conc_sum"}{$ARGV}*100;
	$f="";
}
}{ mmfss("$file.table", %h)' -- -file=$1 $@
