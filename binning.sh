bedtools makewindows -g BT.chrom.size -w 1000000 > genome.1Mb.bed


head -25 /home/adminrig/src/GATK/GenomeAnalysisTK-1.6-11-g3b2fab9/resource.bundle/1.5/b37/human_g1k_v37.fasta.fai | perl -F'\t' -anle' if($.<26){ $F[0]=~/^(\w+) /; print join "\t", $1, $F[1] }' > human.genome
bedtools makewindows -g human.genome -w 1000000 > human.genome.1Mb.bed


