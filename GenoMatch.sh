perl -MMin -MArray::Utils=intersect -se'
BEGIN{
%A=read_matrix_x($A);
%B=read_matrix_x($B);
}

@A_row_key =  sort keys %A;
@A_col_key =  sort keys %{ $A{$A_row_key[0]} };
		
#print @A_row_key+0,"\n";
#print @A_row_key,"\n";

@B_row_key =  sort keys %B;
@B_col_key =  sort keys %{ $B{$B_row_key[0]} };

@row = intersect( @A_row_key, @B_row_key);
@col = intersect( @A_col_key, @B_col_key);

#print @row+0,"\n";
#print @B_row_key+0,"\n";



#print @B_row_key,"\n";
#print @col+0,"\n";

for $i ( @row ){
	for $j ( @col ){
		$A= $A{$i}{$j};
		$B= $B{$i}{$j};
		
		#print "$A $B\n";
		if( "$A$B" =~ /NN/ ){
			$type = "NA";
		}elsif( $A eq $B){
			$type = 1;
		}elsif( $A ne $B){
			$type = 0;
		}
		$h{$i}{$j} = $type;
	}
}

mmfss("GenoMatchResult", %h)
' -- -A=$1 -B=$2
#' -- -A=TaqManGenotype.txt.Num2Geno -B=TaqManExpResult.txt.GenoSort

