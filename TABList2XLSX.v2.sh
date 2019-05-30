
. ~/.bash_function


if [ $# -ge 2 ]; then


NUMLIST=$1
shift

perl -F'\t' -MExcel::Writer::XLSX -asnle'
BEGIN{
#   $cmd = "map { \$_-1 } $value";
#   map { $h{$_}++ } eval($cmd);

	$cmd = "map { \$h{ \$_-1 }++ } $value";
	eval($cmd);
	#show_hash(%h);
}



push @{ $line{$ARGV} }, [@F];
}{

$workbook = Excel::Writer::XLSX->new( "TABList2.xlsx" );

for $sheet ( keys %line ){
	
		$sheetName = $sheet;
		if(length($sheet)>20){
			$sheetName = substr($sheet, 0, 20);
		}
		$worksheet = $workbook->add_worksheet($sheetName);

		map { $worksheet->set_column( $_, $_ ,20 ) } sort keys %h;


		$format1= $workbook->add_format();
		$format1->set_font("Courier New");

		$format2= $workbook->add_format();
		$format2->set_font("Courier New");
		#$format2->set_num_format( "#,##0" );

		$format = $workbook->add_format();
		$format->set_font("Courier New");
		$format->set_bold();
		$format->set_color( "yellow" );
		$format->set_align( "left" );
		$format->set_fg_color( "black" );
		#$format->set_fg_color( "white" );
		$format->set_top(1);
		$format->set_bottom(6);

		@line = @{ $line{$sheet} };
		for $i ( 0 .. $#line ){

			@tmp = @{ $line[$i] };

			if( $i == 0 ){

				map { $worksheet->write( $i, $_, $tmp[$_], $format ) } 0..$#tmp;

			}else{
				for $j ( 0 .. $#tmp ){
					$form = $h{$j} ? $format2 : $format1;
					$worksheet->write( $i, $j, $tmp[$j], $form );
				}
			}
		}
}

$workbook->close()
' -- -value="$NUMLIST" $@ 

else
        usage "1..25 *_Cov"
fi

