
perl -nle'print "$ARGV\t$_"' `find varscan.pass | grep COSMIC.genes60$`   > varscan.pass.txt
perl -nle'print "$ARGV\t$_"' `find varscan.hold | grep COSMIC.genes60$`   > varscan.hold.txt

perl -nle'/snuh\d+/;print $&'  varscan.pass.txt | sort | uniq -c | awk '{print $2"\t"$1}' | sort > varscan.pass.txt.summary
perl -nle'/snuh\d+/;print $&'  varscan.hold.txt | sort | uniq -c | awk '{print $2"\t"$1}' | sort > varscan.hold.txt.summary

perl -F'\t' -MMin -ane'/snuh\d+/;$geno = "$F[10] vs $F[11]"; $h{$geno}{$&}++ }{ mmfss("deamination", %h)'  varscan.hold.txt

R CMD BATCH --no-save --no-restore ~/src/short_read_assembly/bin/R/Deamination.R
