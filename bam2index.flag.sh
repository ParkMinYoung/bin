samtools index $1 
samtools idxstats $1 > $1.idstats 
samtools flagstat $1 > $1.flagstats

