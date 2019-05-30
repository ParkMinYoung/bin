samtools rmdup -S $1 $1.uniq.pair.bam >& $1.uniq.pair.bam.log

samtools index $1.uniq.pair.bam 
samtools idxstats $1.uniq.pair.bam $1.uniq.pair.bam.idstats
samtools flagstat $1.uniq.pair.bam > $1.uniq.pair.bam.flagstats

