#!/bin/sh
source ~/.bash_function

if [ $# -ge 1 ] && [ -f "$1" ] ;then


perl -F'\t' -MList::MoreUtils=firstidx -asnle'BEGIN{
open $P1,">$p1.TrimLastRepeat"; 
}
push @p1, $_;
if($.%4==0){
	#print join "\n",@p1,@p2;
	
	if( $p1[1] =~ s/((TG){3,}|(GT){3,}|(CA){3,}|(AC){3,})(A|C|G|T)?$// ){
		$p1[3] = substr $p1[3], 0, length($p1[1])
	}

	$p1_len = length $p1[1];

	if( $p1_len > 0 ){
		$log{both.pass}++;
		print $P1 join "\n", @p1;
	}else{
		$log{both.fail}++
	}
@p1=();
$log{total}++
}
}{ close $P1;
map{print "$_\t$log{$_}" } sort keys %log 
' -- -p1=$1 -len=$LEN -singleF=$WSRF $1 > $1.TrimLastRepeat.SE.log
else
	usage "fastq1" 
fi

