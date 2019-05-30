
#mkdir Calling 
#cd Calling
#ln -s ../*IndelRealigner.ba{i,m} ./

GenomeAnalysisTK.UnifiedGenotyper.GPS.sh /home/adminrig/Genome/GPS.lib/RS.region.intervals `ls *.bam | sort` 
GenomeAnalysisTK.UnifiedGenotyper.GPS.Desease.interval.sh /home/adminrig/Genome/GPS.lib/Disease.intervals `ls *.bam | sort`
GenomeAnalysisTK.UnifiedGenotyper.GPS.sh /home/adminrig/Genome/GPS.lib/RS.region.genectic.intervals `ls *.bam | sort` 

mkdir shin yoo
cd shin
ln -s ../RS.region.intervals.GPS.snp.raw.vcf* ./
GATK.vcf2GTsGPsGQsADs.Annotation.sh ~/Genome/GPS.lib/RS.region RS.region.intervals.GPS.snp.raw.vcf
cd ..

cd yoo
ln -s ../RS.region.genectic.intervals.GPS.snp.raw.vcf* ../Disease.intervals.GPS.snp.raw.vcf* ./
GenomeAnalysisTK.CombineVariants.sh Disease.intervals.GPS.snp.raw.vcf RS.region.genectic.intervals.GPS.snp.raw.vcf 
GATK.vcf2GTsGPsGQsADs.Annotation.sh ~/Genome/GPS.lib/RS.region.genectic Disease.intervals.GPS.snp.raw.vcf.CombineVariants.vcf
cd ..


mkdir VCF.Handle
cd VCF.Handle
ln -s ../yoo/Disease.intervals.GPS.snp.raw.vcf.CombineVariants.vcf{,.idx} ./
vcf2Annotation.pair.sh Disease.intervals.GPS.snp.raw.vcf.CombineVariants.vcf
