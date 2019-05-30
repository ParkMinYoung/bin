#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] & [ $# -eq 2 ]; then

	perl -MPDL -MList::Util=sum -MList::MoreUtils=after_incl -snle'
	if(/>/){
		$id=$_;
	}else{
		$h{$id}+=length $_;
	}
	}{
		@contigs = sort {$b<=>$a} values %h;
		@filter_contigs = after_incl { $_ >= $min_len } (sort{$a<=>$b} @contigs);

		$total_contigs = @contigs;
		$filter_contigs = @filter_contigs;
		$bases = sum @filter_contigs;
		
		for ( @filter_contigs ){
			$c++;
			$sub_sum+=$_;
			if($sub_sum >= $bases*0.5){
				$N50=$_;
				$NN50=$c;
				last;
			}
		}

		$piddle = pdl @filter_contigs;
		($mean,$prms,$median,$min,$max,$adev,$rms) = statsover $piddle;
		
		@str = qw/max min mean median N50 NN50 prms rms adev total_contigs filter_contigs bases/;
		
		map { 
				$number_zero=sprintf("%02d", ++$number);
				print "$number_zero.$_\t",eval ("\$$_") 
		} @str;

' -- -min_len=$2 $1 
else
	usage "abyss.contigs.fa min_len"
fi


#	print eval ("\$$str")	
