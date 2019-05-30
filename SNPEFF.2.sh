
perl -nle'
if(@ARGV){ 
@F=split "\t", $_; 
$sum=$F[3]+$F[4]; 
$ref=$F[3]/$sum; 
$alt=$F[4]/$sum; 
$h{$F[0]}=join "\t", $F[3],$F[4],$ref,$alt
}else{
	@F= split "\t", $_, 3;
	if(/^chr\tbp/){
		print join "\t", $_, "ref_count", "alt_count", "ref_freq", "alt_freq";
	}else{
		$loc = "$F[0]:$F[1]";
		print join "\t", $_, $h{$loc}
	}
}' $2  $1 > $1.freq
#../KNIH.DNALink.txt work.20140612.sort.annotated.snpeff.dbNSFP2.vcf.out > work.20140612.sort.annotated.snpeff.dbNSFP2.vcf.out.freq

cut.id $1.freq $(grep "^###" $0 | sed 's/^### //' | tr "\n" " ") > $1.freq.final.txt
## substitution cut.id command ## 
dbNSFP.Flagging.sh $1.freq.final.txt
cut -f6 $1.freq.final.txt | sort | uniq -c | awk '{print $2"\t"$1}' | sort -nr -k2,2 > $1.EffectCount

#perl -F'\t' -anle'print join "\t", @F[0,1,2,3,4,84,85,86,87,88,89,90,91,92,93,96,97,98,99,68,75,76,81,79,71,77,70,72,74,82,78,69,73,80,67,83]' $1.freq > $1.freq.final.txt 
#perl -F'\t' -anle'print join "\t", @F[0,1,2,3,4,84,85,86,87,88,89,90,91,92,93,96,97,98,99,68,75,76,81,79,71,77,70,72,74,82,78,69,73,80,67,83]' work.20140612.sort.annotated.snpeff.dbNSFP2.vcf.out.freq > work.20140612.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt 



### chr
### bp
### rs
### ref
### alt
### Effect
### Effect_Impact
### Functional_Class
### Codon_Change
### Amino_Acid_Change
### Amino_Acid_length
### Gene_Name
### Transcript_BioType
### Gene_Coding
### Transcript_ID
### ref_count
### alt_count
### ref_freq
### alt_freq
### dbNSFP_1000Gp1_ASN_AF
### dbNSFP_1000Gp1_EUR_AF
### dbNSFP_1000Gp1_AFR_AF
### dbNSFP_1000Gp1_AF
### dbNSFP_1000Gp1_AMR_AF
### dbNSFP_ESP6500_AA_AF
### dbNSFP_ESP6500_EA_AF
### dbNSFP_MutationTaster_pred
### dbNSFP_SIFT_pred
### dbNSFP_Polyphen2_HDIV_pred
### dbNSFP_Polyphen2_HVAR_pred
### dbNSFP_LRT_pred
### dbNSFP_Uniprot_acc
### dbNSFP_phastCons100way_vertebrate
### dbNSFP_GERP++_NR
### dbNSFP_GERP++_RS
### dbNSFP_Interpro_domain

