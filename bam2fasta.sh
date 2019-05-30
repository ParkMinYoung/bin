 samtools mpileup -uf /home/adminrig/Genome/hg19.chrM/rCRS_mtDNA.Request.fasta $1 | bcftools view -cg - | vcfutils.pl vcf2fq > $1.fq 2> $1.fq.log
 awk '{if (/\+/) {exit;} gsub(/^[@]/,">");print}' $1.fq > $1.fasta


samtools mpileup -uf ../../Arabidopsis_thaliana.TAIR10.30.dna.genome.fa AT2G06210.bam | bcftools call -c -O v - | vcfutils.pl vcf2fq > AT2G06210.bam.fq 2> AT2G06210.bam.fq.log
 awk '{if (/\+/) {exit;} gsub(/^[@]/,">");print}' AT2G06210.bam.fq > AT2G06210.bam.fasta
# i  https://www.biostars.org/p/65885/ 
