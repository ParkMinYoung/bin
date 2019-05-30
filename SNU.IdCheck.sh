mkdir -p VCF/original 
find * -type f |grep vcf$ | perl -nle'/^(.+)\//;print "cp $_ VCF/$1.vcf"' | sh

cd VCF

# for i in *.vcf; do perl -i.bak -ple'BEGIN{$ARGV[0]=~/(.+)_(N|T)/;$id=$1} s/FORMAT\t.+$/FORMAT\t$id/ if /^#CHR/' $i ;done
perl -i.bak -ple's/FORMAT\t.+$/FORMAT\tA/ if /^#CHR/' *vcf
mv *bak original


mkdir output
ls *vcf | perl -MMath::Combinatorics -nle'push @vcf,$_; }{ $DIR="output"; map { ($A,$B)= sort(@{$_}); $out="$DIR/$A-$B"; print "/home/adminrig/src/vcf-tools/vcftools_0.1.9/bin/vcftools --vcf $A --diff $B --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --remove-indels --remove-filtered-all --minGQ 90 --minDP 10 --maxDP 10000 --out $out"} combine(2, @vcf)' > com.sh

sh com.sh

#grep -v DIS output/*diff.indv | sort -nr -k3,3 | less
grep -v DIS output/*diff.indv | sort -nr -k3,3 | perl -F'\t' -anle'($A,$B) = $_ =~ /(snuh\d+)/g; print join "\t", $A,@F[1..3] if $A=~/snuh/ && $A eq $B'  > Discordance
#grep -v DIS output/*diff.indv | sort -nr -k3,3 | perl -F'\t' -anle'($A,$B) = $_ =~ /(snuh\d+)/g; print join "\t", $_, $A,@F[1..3] if $A=~/snuh/ && $A eq $B'  > Discordance
