perl -F"\t" -MList::MoreUtils=natatime -asnle'
BEGIN{ 
		@col= map {$_+2} split ",", $col; 
		@condition=map { $_ / 100 } split "[~,]", $value; 
		$i=0;
		$it = natatime 2, @condition;
		while ( @vals = $it->()) { 
				$str = "$vals[0] <= \$F[ $col[$i] ] &&  $vals[1] >= \$F[ $col[$i] ]";
				$i++; 
				push @cmd, $str  
		} 
		$cmd=join " && ", @cmd; 
#		print $cmd 
} 
if($.==1){
		print
}elsif(eval($cmd)){
		print
}' -- -col=$1 -value=$2 $3
#}' -- -col=1,3,6 -value=0~10,40~60,90~100 MethylCall


