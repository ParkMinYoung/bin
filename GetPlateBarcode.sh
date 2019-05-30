#perl -nle's/[\000-\011\013-\037\177-\377]//g;print' Axiom_KORV1_000041_A01_NIH14D3368431.ARR | less



rm -rf PlateBarcode

ls /microarray/Genetitan/Axiom_KORV1*.ARR | xargs -n 100 -i perl -nle'
s/[\000-\011\013-\037\177-\377]//g;
if(/ArrayName=\"(.+)\"/){
		$name=$1;
}elsif(/AffyBarcode=\"(\d+)\"/){
		$barcode=$1;
}elsif(/\/ArraySetFile/){
	print join "\t", $ARGV, $name, $barcode;
}' {} >> PlateBarcode

#ArrayName="Axiom_KORV1_000041_B07_NIH14D3713549"
#AffyBarcode="5506044249686051916391"

