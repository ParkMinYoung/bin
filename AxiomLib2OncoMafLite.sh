perl -F'\t' -anle'if($.==1){print join "\t", qw/chr start end ref_allele alt_allele/}else{print join "\t",@F[4,5,6,13,14]}' $1 > $1.onco.MAFLite
oncotator -v --input_format=MAFLITE --output_format=TCGAMAF --db-dir ~/src/ONCOTATOR/oncotator_v1_ds_Jan262014/ $1.onco.MAFLite $1.onco.MAFLite.onco.maf hg19 &> $1.onco.MAFLite.onco.maf.log

