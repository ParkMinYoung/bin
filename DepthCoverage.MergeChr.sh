perl -F'\t' -MMin -ane'
BEGIN{@header=qw/total 
mean 
granular_third_quartile 
granular_median 
granular_first_quartile 
%_bases_above_1 
%_bases_above_5 
%_bases_above_10 
%_bases_above_15 
%_bases_above_20 
%_bases_above_25 
%_bases_above_30 
%_bases_above_35 
%_bases_above_40 
%_bases_above_45 
%_bases_above_50 
%_bases_above_55 
%_bases_above_60 
%_bases_above_65 
%_bases_above_70 
%_bases_above_75 
%_bases_above_80 
%_bases_above_85 
%_bases_above_90 
%_bases_above_95 
%_bases_above_100/;

}
chomp@F;
if(/^sample_id/){
	 @head=@F;
}elsif(/^Total/){
	next;
}else{
	$h{$F[0]}{Count}++;
	map { $h{$F[0]}{$head[$_]}+= $F[$_] } 1..$#F;
}

}{	

for $i( keys %h ){
	$h{$i}{mean} = $h{$i}{total}/3101804739;
	map { $h{$i}{$header[$_]} = $h{$i}{$header[$_]}/$h{$i}{Count} } 2..$#header;
}
	
	mmfss_ctitle("DepthCoverage.MergeChr", \%h, \@header) ' `find -type f | grep sample_summary$`
