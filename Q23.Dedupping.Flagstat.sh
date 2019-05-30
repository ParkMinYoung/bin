#!/bin/sh

source ~/.bash_function
source ~/.GATKrc

if [ -f "$1" ] && [ -f "$1" ];then

                TMPDIR=$(dirname $1)

                in1=$1
                in2=$1


                out_file_pe_1=$in1.trimmed
                out_file_pe_2=$in2.trimmed
                out_file_pe_s=$in1.single

                #hsptrim-1.0.py pe -t sanger -f $in_file_pe_1 -r $in_file_pe_2 -o $out_file_pe_1 -p $out_file_pe_2 -s $out_file_pe_s -q 30 -l 20 -w 1 -e -10

                Q=20
                L=20


BaseQscore=23
reference=/home/adminrig/Genome/GATK.DATA/REF/ucsc.hg19.fasta
#reference=/home/adminrig/src/GATK/GATK.data/b37/Sequence/human_g1k_v37.fasta
 ##
 ##
 ##
 ## 2) BWA alignment:
                in1=$out_file_pe_1
                in2=$out_file_pe_2
                in3=$out_file_pe_s

#               bwa aln -n 0.08 -t 2 $reference $in1 > $in1.sai 2> $in1.sai.log
#               bwa aln -n 0.08 -t 2 $reference $in2 > $in2.sai 2> $in2.sai.log
#               bwa aln -n 0.08 -t 2 $reference $in3 > $in3.sai 2> $in3.sai.log


                #bwa sampe $reference $in_sai_1 $in_sai_2 $in_fastq_1 $in_fastq_2 > $out_file 2> /dev/null
#               bwa sampe $reference $in1.sai $in2.sai $in1 $in2 | gzip -c > $in1.PE.sam.gz 2> $in1.sam.log
#               samtools view -uS $in1.PE.sam.gz | samtools sort - $in1.PE.sorted


                #bwa samse $reference $in_sai $in_fastq > $out_file 2> /dev/null
#               bwa samse $reference $in3.sai $in3 | gzip -c > $in1.SE.sam.gz 2> $in3.sam.log
#               samtools view -uS $in1.SE.sam.gz | samtools sort - $in1.SE.sorted


#               samtools merge -f $in1.bam $in1.PE.sorted.bam $in1.SE.sorted.bam



 ##
 ##
 ## 3) Read filtering:
 ##     $samtools=/path/to/samtools/samtools
 ##
 ##     #                           Get up to 3 mismatches                     MapQ 23 filter
 ##     $samtools view -h $in_sam | grep -E "^@|NM:i:0|NM:i:1|NM:i:2|NM:i:3" | $samtools view -bS -q 23 - > $out_bam 2> /dev/null

                BAM=$in1.$BaseQscore.bam

samtools view -h $in1.bam | grep -E "^@|NM:i:0|NM:i:1|NM:i:2|NM:i:3" | samtools view -bS -q $BaseQscore - > $BAM  2> $BAM.log
samtools sort -m 1000000000 $BAM $BAM.sort
samtools index $BAM.sort.bam
samtools flagstat $BAM.sort.bam > $BAM.sort.bam.flagstats



#$## case Noindex
#$#RG=$(echo $BAM  | perl -nle'/\/(.+)?_\w{6}_L00\d/;print $1')
#$#
#$#in=$BAM
#$#out=$BAM.AddRG.bam
#$#log=$out.log
#$#
#$#java $JMEM12 -jar $PICARDPATH/AddOrReplaceReadGroups.jar                          \
#$#INPUT=$in                                                                                                                       \
#$#OUTPUT=$out                                                                                                                     \
#$#SORT_ORDER=coordinate                                                                                           \
#$#CREATE_INDEX=true                                                                                                       \
#$#MAX_RECORDS_IN_RAM=3000000                                                                                      \
#$#VALIDATION_STRINGENCY=LENIENT                                                                           \
#$#RGID=$RG                                                                                                                        \
#$#RGPL=illumina                                                                                                           \
#$#RGPU=DNALink.PE.$RG                                                                                                     \
#$#RGLB=DNALink.PE                                                                                                         \
#$#RGSM=$RG                                                                                                                        \
#$#RGCN=DNALink                                                                                                            \
#$#RGDS=NormalProcessingByMinYoung                                                                         \
#$#TMP_DIR=$TMPDIR                                                                                                         \
#$#>& $log
#$#
#$#
#$#
#$#in=$out
#$#out=$in.Dedupping.bam
#$#metrics=$out.metrics
#$#log=$out.log
#$#
#$#java $JMEM12 -jar $PICARDPATH/MarkDuplicates.jar                                  \
#$#I=$in                                                                                                                   \
#$#O=$out                                                                                                                  \
#$#REMOVE_DUPLICATES=false                                                                                 \
#$#VALIDATION_STRINGENCY=LENIENT                                                                   \
#$#AS=true                                                                                                                 \
#$#MAX_RECORDS_IN_RAM=1000000                                                                              \
#$#METRICS_FILE=$metrics                                                                                   \
#$#CREATE_INDEX=true                                                                                               \
#$#CREATE_MD5_FILE=true                                                                                    \
#$#TMP_DIR=$TMPDIR                                                                                                 \
#$#>& $log
#$#
#$#samtools flagstat $out > $out.flagstats

else
        usage "fastq1 fastq2"
fi

