
#mkdir Calling 
#cd Calling
#ln -s ../*IndelRealigner.ba{i,m} ./


RS_Genetic=/home/adminrig/Genome/GPS.lib/20130417/RS.region.genectic.CHR.intervals
RS_Region=/home/adminrig/Genome/GPS.lib/20130417/RS.region.CHR.intervals
D=/home/adminrig/Genome/GPS.lib/Disease.CHR.intervals

echo "REF=/home/adminrig/workspace.min/IonTorrent/IonTorrentDB/hg19.fasta" > .GATKrc
echo "VCF=/home/adminrig/Genome/dbSNP/dbSNP135/00-All.UCSChg19.vcf" >> .GATKrc

GenomeAnalysisTK.UnifiedGenotyper.GPS.sh $RS_Region $@ 
GenomeAnalysisTK.UnifiedGenotyper.GPS.Desease.interval.sh $D $@ 
GenomeAnalysisTK.UnifiedGenotyper.GPS.sh $RS_Genetic $@ 

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
