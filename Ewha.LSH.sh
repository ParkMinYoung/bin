. ~/.perl
. ~/.GATKrc

(cd Variant && unzip call.zip )

Index2ID.sh
batch.SGE.sh IonProton.Ewha.300k.sh `find Analysis/BAM/ -type f | grep bam$ | sort` > 01.depthcoverage
sh 01.depthcoverage
waiting Ion.

#GenomeAnalysisTK.UnifiedGenotyper.EachInterval.WrapperSGE.hg19 /home/adminrig/Genome/IonAmpliSeq/SNU.430/Custom.Interval2EachChr.Size.1000 `find Analysis/BAM/ | grep AddRG.bam$`  > 02.call
#sh 02.call

GenomeAnalysisTK.DepthOfCoverage.summary
GenomeAnalysisTK.DepthOfCoverage.interval.summary /home/adminrig/Genome/IonAmpliSeq/Ewha.LSH/Ewha.LSH.270k.pool_1.bed /home/adminrig/Genome/IonAmpliSeq/Ewha.LSH/Ewha.LSH.270k.pool_2.bed 

read.len.dist.sh `find Analysis/FASTQ/ | grep fastq$`

batch.SGE.sh fastqc `find Analysis/FASTQ/ | grep fastq$` > 03.fastq
sh 03.fastq
waiting fas

SeqSummaryV2.sh
flagstat.parsing.v2.sh `find | grep flagstats$`

BED=/home/adminrig/Genome/IonAmpliSeq/Ewha.LSH/Ewha.LSH.300k.bed

GenomeAnalysisTK.DepthOfCoverage.Gene.summary 1 $BED
GenomeAnalysisTK.DepthOfCoverage.Gene.summary 50 $BED
GenomeAnalysisTK.DepthOfCoverage.Gene.summary 100 $BED
GenomeAnalysisTK.DepthOfCoverage.Gene.summary 200 $BED

# VCF naming
(cd Analysis/VAR && find | grep vcf$ | perl -nle'/(\w+)\/TSVC/; print "cp $_ $1.vcf"'| sh)
