##  SomaticSniper.output2VEP.sh samples.ssniper.vcf.somatic.vcf.annot.frequencies
##  SomaticSniper.output2VEP.sh samples.varscan.snp.somatic.snp.annot.frequencies
##  
##  VEP.sh samples.varscan.snp.somatic.snp.annot.frequencies.VEP.input
##  VEP.sh samples.ssniper.vcf.somatic.vcf.annot.frequencies.VEP.input
##  
##  VEP.parsing.sh samples.ssniper.vcf.somatic.vcf.annot.frequencies.VEP.input.vep
##  VEP.parsing.sh samples.varscan.snp.somatic.snp.annot.frequencies.VEP.input.vep


cat samples.ssniper.vcf.somatic.vcf.annot.frequencies samples.varscan.snp.somatic.snp.annot.frequencies > Merge.frequencies
SomaticSniper.output2VEP.sh Merge.frequencies

	echo -ne "Merge.frequencies.VEP.input Line : $(wc -l Merge.frequencies.VEP.input)\n"
	cat Merge.frequencies.VEP.input.hist 

VEP.sh Merge.frequencies.VEP.input
VEP.parsing.sh Merge.frequencies.VEP.input.vep
VEP.parsing.UniqAnno.sh Merge.frequencies.VEP.input.vep.txt 

VEP.parsing.UniqAnno.Samples.sh

 

