

for i in `find s_? | grep -e fastq$ -e trimed$ -e single$ | sort | grep -v Read`; do echo "qsub -N dot2N ~/src/short_read_assembly/bin/sub dot2N.sh $i && sleep 10";done > dot2N.batch.sh
sh dot2N.batch.sh
perl -le'while($l=`qstat -u adminrig`){ $l=~/dot2N/ ? sleep 10 : 1 & exit}'


for i in `find s_? | grep -e fastq$ -e trimed$ -e single$ | sort | grep -v Read`; do echo "qsub -N stats ~/src/short_read_assembly/bin/sub fastx_quality_stats -i $i -o $i.stats.txt && sleep 10";done > stats.batch.sh
sh stats.batch.sh
perl -le'while($l=`qstat -u adminrig`){ $l=~/stats/ ? sleep 10 : 1 & exit}'


for i in `find s_? | grep stats.txt$`; do echo "qsub -N graph ~/src/short_read_assembly/bin/sub fastq_quality_boxplot_graph.sh -i $i -o $i.quality.png" ;done > graph.batch.sh
sh graph.batch.sh
perl -le'while($l=`qstat -u adminrig`){ $l=~/graph/ ? sleep 10 : 1 & exit}'



for i in `find s_? | grep stats.txt$`; do echo "qsub -N nc.graph ~/src/short_read_assembly/bin/sub fastx_nucleotide_distribution_graph.sh -i $i -o $i.nuc.png " ;done > nc.graph.batch.sh
sh nc.graph.batch.sh
perl -le'while($l=`qstat -u adminrig`){ $l=~/nc\.graph/ ? sleep 10 : 1 & exit}'

