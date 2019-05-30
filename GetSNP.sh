mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A -D hg19 -e '
select
 K.geneName,
 K.name,
 K.strand,
 S.name,
 S.strand,
 S.avHet,
 S.chrom,
 S.chromStart,
 S.chromEnd,
 S.observed,
 S.func,
 K.txStart,
 K.txEnd
from snp138 as S
left join refFlat as K on
 (S.chrom=K.chrom and (K.txEnd>S.chromStart and S.chromEnd>K.txStart))
where
 S.name in ("rs25","rs100","rs75","rs9876","rs101")' > dbSNP
#(S.chrom=K.chrom and not(K.txEnd+60000<S.chromStart or S.chromEnd+60000<K.txStart))
#http://genome.ucsc.edu/goldenPath/gbdDescriptionsOld.html#RefFlat
#http://www.biostars.org/p/413/

