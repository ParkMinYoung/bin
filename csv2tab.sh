 ##perl -nle'
 ##$c=$_;
 ##s/"//g;
 ##@F=split ",", $_;
 ##print join "\t", @F' $1


perl -MText::CSV::Simple -sle'
$p= Text::CSV::Simple->new();
@data = $p->read_file($file);
map { print join "\t", @{$_} } @data;
' -- -file=$1 

