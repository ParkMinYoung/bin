TrimRmDuplicate.sh $1 $2 150 
#$1.FixLenRMduplicate

cutadapt.sh $1.FixLenRMduplicate.fastq
cutadapt.sh $2.FixLenRMduplicate.fastq
#$1.FixLenRMduplicate.cutadapt

Q10Trim.sh $1.FixLenRMduplicate.fastq.cutadapt $2.FixLenRMduplicate.fastq.cutadapt 20 1 10
