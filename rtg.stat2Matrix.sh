#!/bin/bash


. ~/.bash_function



if [ ! $? ]; then
	
	_red "check the file : *.rtg.stat"

else
	
	#perl -MMin -ne'next if $.<4;  if(/^Sample Name: (.+)/){ $id=$1 }elsif(/^(.+)\s*: (.+)/){ $h{$1}{$id} = $2 } }{ show_matrix(%h)' *rtg.stat 
	perl -MMin -ne'next if $.<4;  
	if(/^Sample Name: (.+)/){ 
			$id=$1 
	}elsif(/^(.+?)\s*: (.+)/){ 
			($type, $value) = ($1,$2); 
			@data = split /\s+/, $value; 
			if(@data > 1){ 
					$h{$type}{$id} = $data[0];  
					$h{"$type detail"}{$id} = $data[1] 
			}else{ $h{$type}{$id} = $value 
			} 
	} 
	}{ show_matrix(%h)' *rtg.stat > step1

	t step1	
	rm -rf step1
			
fi
