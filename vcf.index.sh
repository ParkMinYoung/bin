ls *vcf | perl -nle'print "igvtools index $_" if ! -e "$_.idx"' | sh
