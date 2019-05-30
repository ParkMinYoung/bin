
sickle se -f $1 -q 20 -t illumina 20 -l 50 -o $1.trimmed.fastq
cutadapt.v2.sh $1.trimmed.fastq
tophat.single.sh $1.trimmed.fastq.cutadapt $2 $2
