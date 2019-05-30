perl -F'\t' -MMin -ane'next if /^#/; if(length("$F[3]$F[4]")==2){ $F[2]=~/^rs/ ? $h{$ARGV}{"dbSNP.SNP"}++ : $h{$ARGV}{"novel.SNP"}++; }else{ $F[2]=~/^rs/ ? $h{$ARGV}{"dbSNP.INDEL"}++ : $h{$ARGV}{"novel.INDEL"}++; } }{ mmfss("VCF.SNV.count", %h)' $@

