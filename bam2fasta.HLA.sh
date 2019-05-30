
. ~/.GATKrc
. ~/.bash_function

GATK_param

if [ -f "$1" ];then

	samtools mpileup -uf $HLA $1 | bcftools view -cg - | vcfutils.pl vcf2fq > $1.fq 2> $1.fq.log
	fq2fa.sh $1.fq > $1.fasta
else 
	usage "XXX.bam"
fi

