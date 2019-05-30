
for i in $@
 do 
 perl -nle's/[\000-\011\013\014\016-\037]//g;  if(/affymetrix-array-type.(.+)/){print join "\t", $ARGV, $1 ;last }' $i
done

