ls $@ | \
perl -nle'
/.+_(\d{6})_(\w{2,3})_(.+)\.CEL/; 
($set, $well, $id) = ($1,$2,$3); 
$id =~ s/_(2|3|4|5)$//; 
print join "\t", $set, $well,$id, $_'

#Axiom_KORV1_001033_G03_T7_2.CEL
