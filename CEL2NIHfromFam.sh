perl -F'\s+' -anle'
/.+_(\d{6})_(\w{2,3})_(.+)\.CEL/; 
($set, $well, $id) = ($1,$2,$3); 
$id =~ s/_(2|3|4|5)$//; 
@F[0,1]=($id,$id);
$_=join " ", @F;
print' $1 


