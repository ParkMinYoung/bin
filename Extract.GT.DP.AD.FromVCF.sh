

#ID=SPNT_012
SIFT=/home/adminrig/src/SNPEFF/snpEff_4_3/SnpSift.jar
ID=$1
VCF=$2

cat $VCF | java -Xmx32g -jar $SIFT extractFields - CHROM POS ID GEN[$ID].GT GEN[$ID].DP GEN[$ID].AD| perl -F"\t" -anle'if($.>1 &&  $F[3] ne "./." ){($R,$A) = split "," , $F[5]; $A_Fre = $A==0 ? 0 : sprintf "%.2f", $A/$F[4]*100; print join "\t", $F[0], $F[1]-1, $F[1], @F[2..$#F], $A_Fre, $R, $A  if $F[3] !~ /(2|3|4|5|6|7|8|9)/}' > $ID.bed

bedtools sort -i  $ID.bed | bedtools intersect -b - -a /home/adminrig/src/short_read_assembly/bin/dependancy/human.genome.1Mb.bed -wo > $ID.bed.step1.bed

rm -rf $ID.bed

AddHeader.noheader.sh $ID.bed.step1.bed $ID.header chr start end vchr vstart vend rsid GT DP AD ALT_F REF ALT CNT

rm -rf $ID.bed.step1.bed



