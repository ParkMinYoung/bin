cat - | \
perl -nle'
BEGIN{
	print join "\t", 
		  qw/set well id file dirname basename extention/
}

#/.+_(\d{6})_(\w{2,3})_(.+)\.CEL/; 
/.+_(\d{6})_(\w{2,3})_(.+)\.(\w+)$/; 
($set, $well, $id, $ext) = ($1,$2,$3,$4); 
$id =~ s/_(2|3|4|5)$//; 
/(.+)\/(Axiom_.+$)/;

print join "\t", $set, $well,$id, $_, $1,$2,$ext'

#Axiom_KORV1_001033_G03_T7_2.CEL
