
perl -F'\t' -MMin -ane'chomp;
if(/^(\d+) reads ([pw])/){ 
	$2 eq "p" ? 
	$h{Total}{$ARGV}=$1 : 
	$h{Trim}{$ARGV}=$1 
}
elsif(/^Statistics for/){ 
	$ID=$_ 
}
elsif(/(beginning|end) of the read$/){
	$ID.=" $1"
}
elsif(/^(\d+)\t(\d+)/){
	$h{"$ID\t$1"}{$ARGV}=$2
}
elsif(/^total: (\d+)/){
	$h{"$ID\ttotal"}{$ARGV}=$1
}
}{mmfss("cutadapt.output",%h)' $@ 

