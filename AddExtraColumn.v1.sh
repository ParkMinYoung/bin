#!/bin/sh 

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ] & [ $# -eq 3 ]; then

perl -F'\t' -MMin -asne'
BEGIN{
@select_col = map { $_-1 } split ",", $columns;

%h = read_matrix_x($matrix_call);
@m_row = sort keys %h;
@m_col = sort keys %{$h{$m_row[0]}};

}
chomp@F;

if($. == 1){
	@header = @F;
	@add_header = @F[@select_col];
}else{
	map { $h{ $F[0] }{ $header[$_] } = $F[$_] } @select_col;
}

}{
	@title = (@add_header, @m_col);
	mmfss_ctitle("$matrix_call.AddColumns", \%h, \@title);
' -- -matrix_call=$1 -columns=$3 $2

else
		usage "genotype_matrix[call.txt.geno] Annotation.csv.tab extracted_column_list[2,3,4,5,6,8]"
fi

