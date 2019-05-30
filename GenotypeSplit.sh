ln -s ../../SAM ../../MARKER ./
ln -s ../AxiomGT1.calls.txt ./

# sample QC
ln -s ../Plink/exclude_sample ./
cut -f1 exclude_sample | grep -v -f - SAM  > SAM.QC
# sample QC 

/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh SAM.QC MARKER AxiomGT1.calls.txt
Num2Geno.Affy.sh /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab AxiomGT1.calls.txt.extract > Genotype

perl -MMin -nle'
if($.==1){
	$header=$_
}else{
	$c++;
	push @l,$_;
	if($c%10000==0){ 
		$num= sprintf "%02s", $c/10000; 
		$line= join "\n",$header,@l; 
		print STDERR "line number : $c, file : $num.txt";
		Write_file($line,$num); 
		@l=();
	}
} 
}{ 
	$line= join "\n",$header,@l; 
	Write_file($line,++$num); 
' Genotype


perl -F'\t' -anle'print join "\t", $ARGV,$F[0] if /^A/' `ls ??.txt | sort` > MarkerInfo


ls ??.txt | xargs -n1 -P20 -I {} TAB2XLSX.sh {}

zip Genotype.Split.xlsx.zip ??.txt.xlsx MarkerInfo

