 perl -F'\t' -anle'
 $F[0]=~/(snuh\d+)\.(.+)/; 
 $file1= "$1.variant_tiers.snp.IGV/$2.png";
 $file2= "$1.COSMIC.variant_tiers.snp.IGV/$2.png";
 
 if( -e $file1 ){
	 print "mv $file1 $1.variant_tiers.snp.IGV/$F[3]";
 }elsif( -e $file2 ){ 
	#print "mv $file2 $1.variant_tiers.snp.IGV/$F[3]"; 
	print "mv $file2 $1.COSMIC.variant_tiers.snp.IGV/$F[3]"; 
 }else{
	 print STDERR "$_ was already moved";
	 #print $file2;
} ' png | sh
