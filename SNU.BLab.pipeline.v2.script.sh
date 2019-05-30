#!/bin/sh

source ~/.bash_function
source ~/.GATKrc

if [ -f "$1" ] && [ -f "$2" ];then

		TMPDIR=$(dirname $1)

		in1=$1
		in2=$2


		out_file_pe_1=$in1.trimmed
		out_file_pe_2=$in2.trimmed
		out_file_pe_s=$in1.single

		#hsptrim-1.0.py pe -t sanger -f $in_file_pe_1 -r $in_file_pe_2 -o $out_file_pe_1 -p $out_file_pe_2 -s $out_file_pe_s -q 30 -l 20 -w 1 -e -10
		
		Q=20
		L=20

		sickle pe -f $in1 -r $in2 -q $Q -t sanger -l $L -o $out_file_pe_1 -p $out_file_pe_2 -s $out_file_pe_s >& $out_file_pe_1.log

BaseQscore=23
#reference=/home/adminrig/src/GATK/GenomeAnalysisTK-1.6-11-g3b2fab9/resource.bundle/1.5/hg19/ucsc.hg19.fasta
reference=/home/adminrig/workspace.min/IonTorrent/IonTorrentDB/hg19.fasta
#reference=/home/adminrig/src/GATK/GATK.data/b37/Sequence/human_g1k_v37.fasta
 ## 
 ## 
 ## 
 ## 2) BWA alignment:
		in1=$out_file_pe_1
		in2=$out_file_pe_2
		in3=$out_file_pe_s

# 	 	bwa aln -n 0.08 -t 2 $reference $in1 > $in1.sai 2> $in1.sai.log
# 	 	bwa aln -n 0.08 -t 2 $reference $in2 > $in2.sai 2> $in2.sai.log
# 	 	bwa aln -n 0.08 -t 2 $reference $in3 > $in3.sai 2> $in3.sai.log
		 	 	
 	 	bwa aln -n 0.08 -t 2 $reference $in1 > $in1.sai 2> $in1.sai.log
 	 	bwa aln -n 0.08 -t 2 $reference $in2 > $in2.sai 2> $in2.sai.log
 	 	bwa aln -n 0.08 -t 2 $reference $in3 > $in3.sai 2> $in3.sai.log
		
		#bwa sampe $reference $in_sai_1 $in_sai_2 $in_fastq_1 $in_fastq_2 > $out_file 2> /dev/null
#		bwa sampe $reference $in1.sai $in2.sai $in1 $in2 | gzip -c > $in1.PE.sam.gz 2> $in1.sam.log
#	 	samtools view -uS $in1.PE.sam.gz | samtools sort - $in1.PE.sorted
		
		bwa sampe $reference $in1.sai $in2.sai $in1 $in2 | gzip -c > $in1.PE.sam.gz 2> $in1.sam.log
	 	samtools view -uS $in1.PE.sam.gz | samtools sort - $in1.PE.sorted

		#bwa samse $reference $in_sai $in_fastq > $out_file 2> /dev/null
#		bwa samse $reference $in3.sai $in3 | gzip -c > $in1.SE.sam.gz 2> $in3.sam.log 
#	 	samtools view -uS $in1.SE.sam.gz | samtools sort - $in1.SE.sorted
		
		bwa samse $reference $in3.sai $in3 | gzip -c > $in1.SE.sam.gz 2> $in3.sam.log
	 	samtools view -uS $in1.SE.sam.gz | samtools sort - $in1.SE.sorted

#		samtools merge -f $in1.bam $in1.PE.sorted.bam $in1.SE.sorted.bam
		
		samtools merge -f $in1.bam $in1.PE.sorted.bam $in1.SE.sorted.bam


 ## 
 ## 
 ## 3) Read filtering:
 ## 	$samtools=/path/to/samtools/samtools
 ## 
 ## 	#                           Get up to 3 mismatches                     MapQ 23 filter
 ## 	$samtools view -h $in_sam | grep -E "^@|NM:i:0|NM:i:1|NM:i:2|NM:i:3" | $samtools view -bS -q 23 - > $out_bam 2> /dev/null

		BAM=$in1.$BaseQscore.bam
# 	 	samtools view -h $in1.bam | grep -E "^@|NM:i:0|NM:i:1|NM:i:2|NM:i:3" | samtools view -bS -q 23 - > $BAM  2> $BAM.log 
 	 	
		samtools view -h $in1.bam | grep -E "^@|NM:i:0|NM:i:1|NM:i:2|NM:i:3" | samtools view -bS -q $BaseQscore - > $BAM  2> $BAM.log
 ## 
 ## 
 ## 
 ## 4) AddRG:
 ##         cmd="AddOrReplaceReadGroups" # Picard 1.63 AddOrReplaceReadGroups
 ##         cmd="$cmd INPUT=$in_file"
 ##         cmd="$cmd OUTPUT=$out_file"
 ##         cmd="$cmd SORT_ORDER=coordinate"
 ##         cmd="$cmd CREATE_INDEX=true"
 ##         cmd="$cmd MAX_RECORDS_IN_RAM=1500000"
 ##         cmd="$cmd VALIDATION_STRINGENCY=LENIENT"
 ##         cmd="$cmd RGID=$id"
 ##         cmd="$cmd RGPL=illumina"
 ##         cmd="$cmd RGPU=PU_$id"
 ##         cmd="$cmd RGLB=CGP"
 ##         cmd="$cmd RGSM=$id"
 ##         cmd="$cmd RGCN=DNALink"
 ## 
 ## 


RG=$(echo $BAM  | perl -nle'/\/(.+)?_\w{6,7}_L00\d/;print $1')
RG=$(echo $BAM  | perl -nle'/\/(NIH\w+)_\w{6,7}_L00\d/;print $1')

in=$BAM
out=$BAM.AddRG.bam
log=$out.log

java $JMEM -jar $PICARDPATH/AddOrReplaceReadGroups.jar				\
INPUT=$in															\
OUTPUT=$out															\
SORT_ORDER=coordinate												\
CREATE_INDEX=true													\
MAX_RECORDS_IN_RAM=1500000											\
VALIDATION_STRINGENCY=LENIENT										\
RGID=$RG															\
RGPL=illumina														\
RGPU=DNALink.PE.$RG													\
RGLB=DNALink.PE														\
RGSM=$RG															\
RGCN=DNALink														\
RGDS=NormalProcessingByMinYoung										\
TMP_DIR=$TMPDIR														\
>& $log


 ## 
 ## 5) GATK: # GATK v1.4, Picard v1.63
 ##         0. Index / Annotations:
 ##         0-1. FASTA file (ucsc.hg19)
 ##         0-2. VCF files (dbsnp, Miller-Devine indels)
 ## 
 ## 	1. MarkDuplicates
 ## 
 ##         cmd="MarkDuplicates3" # Picard v1.63
 ##         cmd="$cmd I=$in_file"
 ##         cmd="$cmd O=$out_file"
 ##         cmd="$cmd REMOVE_DUPLICATES=true"
 ##         cmd="$cmd VALIDATION_STRINGENCY=LENIENT"
 ##         cmd="$cmd AS=true"
 ##         cmd="$cmd MAX_RECORDS_IN_RAM=1000000"
 ##         cmd="$cmd METRICS_FILE=$dups_file"
 ##         cmd="$cmd CREATE_INDEX=true"
 ##         cmd="$cmd > $log_file 2>&1 &"
 ## 
 ## 


in=$out
out=$in.Dedupping.bam
metrics=$out.metrics
log=$out.log

java $JMEM -jar $PICARDPATH/MarkDuplicates.jar					\
I=$in															\
O=$out															\
REMOVE_DUPLICATES=true											\
VALIDATION_STRINGENCY=LENIENT									\
AS=true															\
MAX_RECORDS_IN_RAM=1000000										\
METRICS_FILE=$metrics											\
CREATE_INDEX=true												\
TMP_DIR=$TMPDIR													\
>& $log

GATKDIR=/home/adminrig/src/GATK/GenomeAnalysisTK-1.6-11-g3b2fab9
GATKPATH=/home/adminrig/src/GATK/GenomeAnalysisTK-1.6-11-g3b2fab9
GATK=GenomeAnalysisTK.jar
EGATK=$GATKPATH/$GATK

AC=AnalyzeCovariates.jar
EAC=$GATKPATH/$AC

R=/home/adminrig/src/R/R-2.12.0/bin/Rscript

#GATK_PYTHON=$GATKDIR/python
#GATK_PERL=$GATKDIR/perl
#GATK_R=$GATKDIR/R
#R_subdir=$GATKDIR/R



known_snp_file=/home/adminrig/src/GATK/GenomeAnalysisTK-1.6-11-g3b2fab9/resource.bundle/1.5/hg19/dbsnp_135.hg19.vcf 
known_indel_file=/home/adminrig/src/GATK/GenomeAnalysisTK-1.6-11-g3b2fab9/resource.bundle/1.5/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf


known_snp_file=/home/adminrig/src/GATK.2.0/resource.bundle/2.2/hg19/dbsnp_137.hg19.vcf
known_indel_file=/home/adminrig/src/GATK.2.0/resource.bundle/2.2/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf


 ## 
 ## 	2-1. RealignerTargetCreator
 ## 
 ##         cmd="GenomeAnalysisTK2"
 ##         cmd="$cmd -R $ref_file"
 ##         cmd="$cmd -I $in_file"
 ##         cmd="$cmd -T RealignerTargetCreator"
 ##         cmd="$cmd -o $intervals_file"
 ##         cmd="$cmd --minReadsAtLocus 10"
 ##         cmd="$cmd --windowSize 10"
 ##         cmd="$cmd --mismatchFraction 0.15"
 ##         cmd="$cmd --maxIntervalSize 500"
 ##         cmd="$cmd -known $known_snp_file"
 ##         cmd="$cmd -known $known_indel_file"
 ##         cmd="$cmd > $log_file 2>&1 &"
 ##

in=$out
out=$in.IndelRealigner.intervals
log=$out.log

java $JMEM -Djava.io.tmpdir=$TMPDIR -jar $EGATK				\
-R $reference												\
-I $in														\
-T RealignerTargetCreator									\
-o $out														\
--minReadsAtLocus 10										\
--windowSize 10												\
--mismatchFraction 0.15										\
--maxIntervalSize 500										\
-known $known_snp_file										\
-known $known_indel_file									\
>& $log


 ## 
 ## 	2-2. IndelRealigner
 ## 
 ##         cmd="GenomeAnalysisTK2"
 ##         cmd="$cmd -R $ref_file"
 ##         cmd="$cmd -I $in_file"
 ##         cmd="$cmd -T IndelRealigner"
 ##         cmd="$cmd -o $out_file"
 ##         cmd="$cmd -compress 5"
 ##         cmd="$cmd --LODThresholdForCleaning 5.0"
 ##         cmd="$cmd --consensusDeterminationModel USE_READS"
 ##         cmd="$cmd --maxReadsInMemory 300000"
 ##         cmd="$cmd --maxConsensuses 30"
 ##         cmd="$cmd --maxReadsForConsensuses 120"
 ##         cmd="$cmd -targetIntervals $intervals_file"
 ##         cmd="$cmd -known $known_snp_file"
 ##         cmd="$cmd -known $known_indel_file"
 ##         cmd="$cmd >> $log_file 2>&1 &"
 ## 
 ## 

interval=$out
in=$in
out=$in.IndelRealigner.bam
log=$out.log

java $JMEM -Djava.io.tmpdir=$TMPDIR -jar $EGATK				\
-R $reference												\
-I $in														\
-T IndelRealigner											\
-o $out														\
-compress 5													\
--LODThresholdForCleaning 5.0								\
--consensusDeterminationModel USE_READS						\
--maxReadsInMemory 300000									\
--maxConsensuses 30											\
--maxReadsForConsensuses 120								\
-targetIntervals $interval									\
-known $known_snp_file										\
-known $known_indel_file									\
>& $log


 ## 
 ## 	3-1. CountCovariates
 ## 
 ##         cmd="GenomeAnalysisTK2" # GATK v1.4
 ##         cmd="$cmd -R $ref_file"
 ##         cmd="$cmd -knownSites $known_snp_file"
 ##         cmd="$cmd -I $in_file"
 ##         cmd="$cmd -T CountCovariates"
 ##         cmd="$cmd -cov ReadGroupCovariate"
 ##         cmd="$cmd -cov QualityScoreCovariate"
 ##         cmd="$cmd -cov CycleCovariate"
 ##         cmd="$cmd -cov DinucCovariate"
 ##         cmd="$cmd -recalFile $csv_file"
 ##         cmd="$cmd -l INFO"
 ##         cmd="$cmd > $log_file 2>&1 &"



in=$out
out=$in.TableRecalibration.csv
log=$out.log

java $JMEM -Djava.io.tmpdir=$TMPDIR -jar $EGATK				\
-R $reference												\
-knownSites $known_snp_file									\
-I $in														\
-T CountCovariates											\
-cov ReadGroupCovariate										\
-cov QualityScoreCovariate									\
-cov CycleCovariate											\
-cov DinucCovariate											\
-recalFile $out												\
-l INFO														\
>& $log


 ## 
 ## 
 ## 	3-2. TableRecalibration
 ## 
 ##         cmd="GenomeAnalysisTK2"
 ##         cmd="$cmd -R $ref_file"
 ##         cmd="$cmd -I $in_file"
 ##         cmd="$cmd -T TableRecalibration"
 ##         cmd="$cmd -o $out_file"
 ##         cmd="$cmd -recalFile $csv_file"
 ##         cmd="$cmd -pQ 5"
 ##         cmd="$cmd -baq RECALCULATE"
 ##         cmd="$cmd -l INFO"
 ##         cmd="$cmd >> $log_file 2>&1 &"

csv=$out
in=$in
out=$in.TableRecalibration.bam
log=$out.log

java $JMEM -Djava.io.tmpdir=$TMPDIR -jar $EGATK				\
-R $reference												\
-I $in														\
-T TableRecalibration										\
-o $out														\
-recalFile $csv												\
-pQ 5														\
-baq RECALCULATE											\
-l INFO														\
>& $log



#SAMTOOLS=/home/adminrig/src/samtools/samtools-0.1.16/samtools
#$SAMTOOLS pileup -Q $BaseQscore  -f $reference $out > $out.pileup

else
	usage "R1.fastq.gz R2.fastq.gz"
fi

