
perl -F'\t' -anle'$s=$F[1]-1000;$e=$F[2]+1000;print join "\t", "$F[0]:$s-$e",$F[18],$F[19]' miRNA.region.recode.vcf.gz.pass.vcf.RS.final.acc | sort | uniq > snp.20110414

