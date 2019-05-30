mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A -e  "select chrom, size from hg19.chromInfo"  > hg19.genome
