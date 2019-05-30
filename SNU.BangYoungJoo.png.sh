ID=$1
perl -F'\t' -anle'$k="$F[3].$F[0].$F[1]-$F[2]";$png="$ARGV.IGV/$k.png"; print if ! -f $png' $ID.variant_tiers.snp > $ID.variant_tiers.snp.bak
IGV.img.somatic.FromBed.sh ../BAM/${ID}_N.bam.AddRG.bam ../BAM/${ID}_T.bam.AddRG.bam ../SNU.BangYoungJu.430k.bed $ID.variant_tiers.snp.bak
#  find_d 1 | grep bak.IGV$ | perl -nle'$d=$_; s/\.bak//; print "mv $d/*png $_";' | sh 
