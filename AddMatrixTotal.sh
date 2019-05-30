#!/bin/bash

. ~/.bash_function

input_type=$(show_input_type)

if [ $input_type == "STDIN" ] && [ ! -f "$1" ]  ;then

		usage "matrix_file"
else

		input="${1:-/dev/stdin}"
		
		cat $input | \
		perl -F"\t" -MPDL -anle'
		if($.==1){
			print join "\t", @F, qw/subtotal/;
			$row=0;
		}else{
			map { $m[$row][$_-1] = $F[$_] =~ /^\d+$/ ? $F[$_] : 0 } 1..$#F;
			$row++;

			@num = map { $_ =~ /^\d+$/ ? $_ : 0 } @F[1..$#F];
#			print join ",", @num;

			$pdl = pdl \@num;
			print join "\t", @F, $pdl->sum();
		}

		}{

		$pdl = pdl \@m;
		#@row = $pdl -> sumover() -> list()
		@col =$pdl -> xchg(0,1) -> sumover() -> list();
		print join "\t", "subtotal", @col, pdl(\@col)->sum()

		'
fi

