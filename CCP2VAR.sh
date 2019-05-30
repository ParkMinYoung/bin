ln -s ../mapping ./
(cd Variant && unzip call.zip )
Index2ID.sh
(cd Analysis/VAR && find | grep -e alleles.xls -e vcf$ | perl -nle'if(/(.+)\/TSVC/){print "cp $_ $1.vcf;"}elsif(/(.+)\/alleles.xls/){print "cp $_ $1.xls;"}'| sh)
