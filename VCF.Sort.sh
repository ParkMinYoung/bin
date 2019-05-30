
INPUT=$1
OUTPUT=${INPUT%.vcf}.sort.vcf

grep '^#' $INPUT > $OUTPUT && grep -v '^#' $INPUT | LC_ALL=C sort -k1,1 -k2,2n >> $OUTPUT
