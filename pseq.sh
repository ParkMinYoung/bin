 pseq new-project 96sample
 pseq 96samples new-project
 pseq 96samples load-vcf --vcf Call.snp.raw.vcf
 pseq 96samples load-pheno --file 96samples.phe 
 pseq 96samples v-assoc --phenotype phe1 | gcol VAR REF ALT MAF HWE MINA MINU OBSA OBSU REFA HETA HOMA REFU HETU HOMU P OR PDOM ORDOM PREC ORREC > 96samples.assoc
 sort -nr -k16 96samples.assoc | less -S 



pseq KBUniv new-project
pseq KBUniv load-vcf --vcf 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.header.dbsnp135.vcf.GRCh37.66.vcf
pseq KBUniv load-pheno --file New.phe
pseq KBUniv v-assoc --phenotype phe1 | gcol VAR REF ALT MAF HWE MINA MINU OBSA OBSU REFA HETA HOMA REFU HETU HOMU P OR PDOM ORDOM PREC ORREC > KBUniv.assoc

Eff.OutParsing.sh 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.header.dbsnp135.vcf.GRCh37.66.vcf
perl -F'\t' -anle'if($.==1){print}elsif($F[15] <= 0.05 || $F[17] <= 0.05 || $F[19] <= 0.05){print}' KBUniv.assoc > KBUniv.assoc.Pvalue0.05

Linker.SNPEFF2Assoc.sh 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.header.dbsnp135.vcf.GRCh37.66.vcf.SNPEFF.parsing.uniq KBUniv.assoc
Linker.SNPEFF2Assoc.sh 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.header.dbsnp135.vcf.GRCh37.66.vcf.SNPEFF.parsing.uniq KBUniv.assoc.Pvalue0.05 

