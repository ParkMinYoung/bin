# excute time : 2016-10-25 10:21:07 : get statistics from vcf
rtg vcfstats $1 > $1.rtg.stat & 


# excute time : 2016-10-25 10:26:49 : using bcftools stats
bcftools stats -s - $1 > $1.bcftools.stat & 

wait

