perl -F'\t' -anle'if(@ARGV){
	if(/^Gene/){
		$header=$_;
	}elsif($F[14] eq "-"){
		$s=$F[11]-1;
		$k="$F[10]:$s";
	}else{
		$k="$F[10]:$F[11]";
	}
	$h{$k}=$_;
}else{
	if(/^VAR/){
		print "$_\t$header";
		next;
	}
	$F[0]=~/chr(\w+:\d+)/;
	$k=$1;
	print "$_\t$h{$k}";
}' $1 $2 > $2.Report

#Annotation/$VCF.QC.Site.recode.vcf.Pvalue.vcf/$VCF.QC.Site.recode.vcf.Pvalue.vcf.PASS.vcf.annovar.annotate.genome_summary.csv.tab.table $Project.assoc.Pvalue0.05 > $Project.assoc.Pvalue0.05.Report

#/home/adminrig/workspace.min/Project.Asan.KHS.20130207/BAM/Call/INTERVAL.VCF/Call/CaseControl/Annotation/Case14vsControl125.vcf.QC.Site.recode.vcf.Pvalue.vcf/Case14vsControl125.vcf.QC.Site.recode.vcf.Pvalue.vcf.PASS.vcf.annovar.annotate.genome_summary.csv.tab.table Case14vsControl125.assoc.Pvalue0.05 > Case14vsControl125.assoc.Pvalue0.05.Report

