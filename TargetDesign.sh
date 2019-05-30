
F=SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.bed

if [ ! -f "$F" ]; then

ln -s /home/adminrig/Genome/SureSelect/SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.bed ./

fi



# normal 
sortBed -i $1 |  mergeBed -i stdin -nms | perl -F'\t' -anle'%h=();map{$h{$_}++} split ";",$F[3]; print join "\t", @F[0..2], (join ";", sort keys %h)' > $1.merge.bed

# slop 100 bp 
sortBed -i $1 | slopBed -i stdin -b 100 -g /home/adminrig/Genome/dbSNP/Mask/hg19.genome |  mergeBed -i stdin -nms | perl -F'\t' -anle'%h=();map{$h{$_}++} split ";",$F[3]; print join "\t", @F[0..2], (join ";", sort keys %h)' > $1.merge.100bp.bed


coverageBedV2.sh SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.bed  $1.merge.bed
coverageBedV2.sh SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.bed  $1.merge.100bp.bed


perl -F'\t' -anle'

$h{$F[3]}{Total} += $F[6];
$h{$F[3]}{Sequencing} += $F[5];

}{
map { print join "\t", $_, $h{$_}{Sequencing}, $h{$_}{Total}, $h{$_}{Sequencing}/$h{$_}{Total}*100 } sort keys %h
' SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.bed.$1.merge.bed.coverage > SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.bed.$1.merge.bed.coverage.gene 


perl -F'\t' -anle'

$h{$F[3]}{Total} += $F[6];
$h{$F[3]}{Sequencing} += $F[5];

}{
map { print join "\t", $_, $h{$_}{Sequencing}, $h{$_}{Total}, $h{$_}{Sequencing}/$h{$_}{Total}*100 } sort keys %h
' SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.bed.$1.merge.100bp.bed.coverage > SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.bed.$1.merge.100bp.bed.coverage.gene 




## chr3    20202596        20202718        SGOL1   1       66      122     0.5409836
## chr3    20212195        20212307        SGOL1   1       112     112     1.0000000
## chr3    20212534        20212724        SGOL1   1       190     190     1.0000000
## chr3    20215740        20216547        SGOL1   2       691     807     0.8562577
## chr3    20218092        20218151        SGOL1   1       59      59      1.0000000
## chr3    20219762        20219839        SGOL1   1       77      77      1.0000000
## chr3    20225099        20225296        SGOL1   1       197     197     1.0000000

