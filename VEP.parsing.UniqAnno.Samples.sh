#!/bin/sh 


perl -F'\t' -anle'
if($ARGV =~ /(ssniper|varscan).+frequencies$/){
	$tool = $1;
	$key=$F[0].":".$F[1];
	$key=~s/^chr//;
	if(! $h{$key}{$tool}){
		$h{$key}{$tool} = $F[7];
	}elsif( $h{$key}{$tool} < $F[7] ){
		$h{$key}{$tool} = $F[7];
	}
#push @{$h{$key}{tools}}, $tool;

}elsif(/^Location/){
	print join "\t", $_, "Tool","Overlap Samples";
}elsif($h{$F[0]}{ssniper} && $h{$F[0]}{varscan}){
	print join "\t", $_,"ssniper,varscan","$h{$F[0]}{ssniper},$h{$F[0]}{varscan}";
}elsif($h{$F[0]}{ssniper}){
	print join "\t", $_,"ssniper",$h{$F[0]}{ssniper};
}elsif($h{$F[0]}{varscan}){
	print join "\t", $_,"ssniper",$h{$F[0]}{varscan};
}
		
' samples.ssniper.vcf.somatic.vcf.annot.frequencies samples.varscan.snp.somatic.snp.annot.frequencies Merge.frequencies.VEP.input.vep.txt.Uniq.Anno > Merge.frequencies.VEP.input.vep.txt.Uniq.Anno.Samples



##[adminrig@node01 somatic.analysis]$ ls samples*.frequencies | xargs head
 ##==> samples.ssniper.vcf.somatic.vcf.annot.frequencies <==
 ##chr17   21319860        KCNJ18  NM_001194958    exon-3  C       A,T     17
 ##chr17   21319860        KCNJ12  NM_021012       exon-3  C       A,T     17
 ##chr11   18428651        LDHA    NR_028500       intron-6        A       T       17
 ##chr11   18428651        LDHA    NM_005566       intron-7        A       T       17
 ##chr11   18428651        LDHA    NM_001165416    intron-6        A       T       17
 ##chr11   18428651        LDHA    NM_001165415    intron-6        A       T       17
 ##chr11   18428651        LDHA    NM_001165414    intron-7        A       T       17
 ##chr11   18428651        LDHA    NM_001135239    intron-6        A       T       17
 ##chr8    13072084        DLC1    NM_182643       intron-5        G       T       16
 ##chr11   18428650        LDHA    NR_028500       intron-6        C       T       16
 ##
 ##==> samples.varscan.snp.somatic.snp.annot.frequencies <==
 ##chr9    136577833       SARDH   NM_007101       intron-9        T       C       16
 ##chr9    136577833       SARDH   NM_001134707    intron-9        T       C       16
 ##chr11   1016907 MUC6    NM_005961       exon-31 G       T       16
 ##chr7    86822667        DMTF1   NR_024550       utr-5'  T       C       15
 ##chr7    86822667        DMTF1   NR_024549       utr-5'  T       C       15
 ##chr7    86822667        DMTF1   NM_021145       exon-17 T       C       15
 ##chr7    86822667        DMTF1   NM_001142327    exon-15 T       C       15
 ##chr7    86822667        DMTF1   NM_001142326    exon-14 T       C       15
 ##chr11   1016933 MUC6    NM_005961       exon-31 C       T       15
 ##chr11   1016910 MUC6    NM_005961       exon-31 G       A       15
 ##
 ##
 ##File : [Merge.frequencies.VEP.input.vep.txt.Uniq.Anno]
 ##0       Location        1:109825197
 ##1       HGNC    PSRC1
 ##2       Consequence     NON_SYNONYMOUS_CODING,SPLICE_SITE
 ##3       cDNA_position   164
 ##4       CDS_position    20
 ##5       Protein_position        7
 ##6       Amino_acids     D/V
 ##7       Codons  gAt/gTt
 ##8       PolyPhen        probably_damaging
 ##9       SIFT    deleterious
 ##10      Condel  deleterious
 ##11      PolyPhen_score  1
 ##12      SIFT_score      0
 ##13      Condel_score    0.945
 ##[2] : ################################################################################
 ##[2] : ################################################################################
 ##
