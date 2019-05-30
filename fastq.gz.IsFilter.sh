#!/bin/sh

zcat $1 | \
perl -nle'
push @l,$_;
if($.%4==0){
	$l[0]=~/\d:([YN]):/;
	print join "\n", @l if $1 eq "N";
	@l=();
}
' | gzip -c > $1.N.fastq.gz
## fastqc $1.N.fastq.gz
## 
## zcat $1 | \
## perl -nle'
## push @l,$_;
## if($.%4==0){
## 	$l[0]=~/\d:([YN]):/;
## 	print join "\n", @l if $1 eq "Y";
## 	@l=();
## }
## ' | gzip -c > $1.Y.fastq.gz
## fastqc $1.Y.fastq.gz
## 

# @HWI-ST848:173:D04GHACXX:7:1101:1198:2087 1:N:0:TTAGGC
# NATTCCCAGCTCTACATCCTGTAGATTCTCACACCCAGGGCCTCCTTCGGCCTCTTCTCAGGGGAGTCTCAGAGCNNNAGCCTCTCTCCCTTGCCCAGTGA
# +
# #1:DDBDDHHHAFDHGGGGIIAF>><FGGIIH+CFFFFHIIDHGGIIGHHIIIGG:FHH:@C9A:9;@DC@CCCC###,,5<BCDDCADDD>?CCCDD>AC
# @HWI-ST848:173:D04GHACXX:7:1101:1240:2134 1:N:0:TTAGGC
# TTAAAGCACCTGTATTTTCTCCTCCCTTCAGCTGTGTGTGCCACTGAGGTTTTTAAAATAGCCACAAGGTAATAGGTTTCATTTTTAATATGCATGTAAAT
# +
# @CCDFFDBFHHHHIJIJJIIHIEFGGCHHFGBDFEEHGIJGHIGHGIIG9DDFHGBFIGIEEHIHGEHD@@ACEEEHCDDDEDFFFBACDCCCACCCDDDD
# @HWI-ST848:173:D04GHACXX:7:1101:1186:2164 1:N:0:TTAGGC
# GACTTCGTGCCTGAGATAATCAGCTCTACACCTATAACCCAGTCCCTCCCAGCCCCAGTACCTTTCTAATAATCCACTGCATCAGTCCCAGGTAGTACAGC