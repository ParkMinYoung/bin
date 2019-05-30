
perl -MMin -ne'if(/^>\d+ (\d+)/){
	$l=$1;
	for (0,100,500,1000,1500,2000,3000,4000,5000){
	if($l>=$_){
		$h{"contig.$_"}{len}+=$l;
		$h{"contig.$_"}{count}++;
		}
	}
} }{ mmfss("contig.length",%h)' $1

