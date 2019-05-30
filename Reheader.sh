SAMTOOLS=/home/adminrig/src/SAMTOOLS/git.repo/samtools

#$SAMTOOLS view -h $1 | perl -F'\t' -anle'print if $F[6] !~/chrM/' | samtools view -bhS -o $1.filter.bam -
$SAMTOOLS view -h $1 |  awk '$7 !~ /chrM/ { print }' | samtools view -bhS -o $1.filter.bam -
#$SAMTOOLS sort $1.filter.bam $1.sort
#$SAMTOOLS index $1.sort.bam
#$SAMTOOLS reheader reheader.sam $1.sort.bam > $1.sort.bam.reheader.bam
$SAMTOOLS reheader reheader.sam $1.filter.bam > $1.filter.bam.reheader.bam
$SAMTOOLS index $1.filter.bam.reheader.bam




