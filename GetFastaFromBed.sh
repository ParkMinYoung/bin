B37=/home/adminrig/src/GATK/GATK.data/b37
REF=$B37/Sequence/human_g1k_v37.fasta


bedtools getfasta -fi $REF -bed $1 -fo $1.tab -name 
#bedtools getfasta -fi $REF -bed $1 -fo $1.tab -tab -name 

