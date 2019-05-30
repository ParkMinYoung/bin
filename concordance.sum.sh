 find -maxdepth 2 | sort |  grep vcf.concordance.summary$ |xargs grep ^count | grep com | perl -nle'print; print "\n" if $.%3==0'
