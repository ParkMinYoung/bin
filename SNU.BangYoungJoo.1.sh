#ln `find /home/adminrig/workspace.jin/SNU.BYJ.proton.varscan.20131112/ | grep tier` tier
COSMIC=/home/adminrig/Genome/IonAmpliSeq/SNU.430/SNU.BangYoungJoo.COSMIC.snp
find BAM/ | grep AddRG.bam$ | grep snuh | sort | xargs -n 2 | perl -snle'/(snuh\d+)/; print "cp $cosmic tier/$1.COSMIC.variant_tiers.snp\nIGV.img.somatic.FromBed.cosmic.sh $_ SNU.BangYoungJu.430k.bed tier/$1.COSMIC.variant_tiers.snp"' -- -cosmic=$COSMIC > IGV.snp
find BAM/ | grep snuh | grep AddRG.bam$ | sort | xargs -n 2 | perl -nle'/(snuh\d+)/; print "IGV.img.somatic.FromBed.sh $_ SNU.BangYoungJu.430k.bed tier/$1.variant_tiers.snp"' >> IGV.snp
sh IGV.snp

