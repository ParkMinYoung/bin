(head -10000 $1 | grep ^"#"; perl -F'\t' -anle'if(!/^#/ && !$h{join "\t",@F[0..4]}++){print}' $@ ) | sortBed -i stdin > Combined.vcf
igvtools index Combined.vcf 

