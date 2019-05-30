perl -F'\t' -MMin -MList::MoreUtils=any -ane'
chomp@F;
if($F[21] ne "-"){
	%type=();
	map { /([+-]\d+\w+)/; $type{".".uc($1)}++} split /\|/, $F[21];
	$F[21] = join "\|", sort keys %type;
}
$indel = $F[17] ? "$F[17]($F[21])" : $F[17];
if(any { defined $_  } @F[13..17]){
	$data=join ",", @F[13..16],$indel
}else{ $data="[[[[X]]]]" }

$h{ join "\t", @F[0..2] }{$ARGV} = $data;
}{ mmfss("alleles.count",%h)' $@

# $@ = *.AlleleCnt

