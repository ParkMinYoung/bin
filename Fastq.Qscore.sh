#!/bin/sh

source ~/.bash_function

if [ -f $1 ];then
	perl -MIO::Zlib -MMin -se'$fh=IO::Zlib->new($f,"r");
	while(<$fh>){
		if(++$c%4==0){
			chomp;
			$b=0;
			map {++$b;$h{$b}{$_-34}++} unpack "C*", $_;
		}
	}
	
	for $cycle (keys %h){
		$n=0;
		for $score ( sort {$a<=>$b} keys %{$h{$cycle}} ){

			$m{$cycle}{$f} += $score * $h{$cycle}{$score};
			$m{Mean}{$f}  += $score * $h{$cycle}{$score};
			
			$n+=$h{$cycle}{$score};
			$overQ30_n += $h{$cycle}{$score} if $score > 29;
		}
		$mean_n+=$n;
		$m{$cycle}{$f}= $m{$cycle}{$f} / $n;
	}
	$m{Mean}{$f} = sprintf ("%.2f", $m{Mean}{$f}/$mean_n ) ;
	$m{Q30}{$f} = sprintf ("%.2f", $overQ30_n / $mean_n * 100 );
	
	mmfsn("$f.Qscore",%m)
' -- -f=$1  
else
	usage try.gz
fi


#print join "\n",@l, (join "",map {chr($_-31)} unpack "C*", $_ );

