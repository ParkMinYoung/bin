. ~/Genome/Download
wget $REFFLAT
gunzip refFlat.txt.gz


# get GOI refflat.txt, refflat.txt.bed and unknown gene symbol
GeneFromRefFlat.sh genelist refFlat.txt

# get merged region's bed
GetGeneBedFromUCSCrefFlat.sh genelist.refFlat

SSV3=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.NumChr.bed

sed 's/^chr//' refFlat.Gene.bed  > refFlat.Gene.bed.NumChr.bed


intersectBed -a refFlat.Gene.bed.NumChr.bed -b $SSV3 -wao > refFlat.Gene.bed.NumChr.bed.SSV3.bed


awk '{print $5"\t"$6"\t"$7"\t"$4}' refFlat.Gene.bed.NumChr.bed.SSV3.bed > DNALinkCancerPanel.368Genes.In.SSV3.bed


