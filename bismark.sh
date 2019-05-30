## mapping


DIR=$(dirname $1)
cd $DIR

F1=$(basename $1)
F2=$(basename $2)


~/src/bismark_v0.14.5/bismark /home/adminrig/workspace.min/MethylSeq/NAAS.Oryza_sativa.IRGSP-1.0.25/Reference -1 $F1 -2 $F2 --bowtie2 -N 1 -L 20 -p 2 --path_to_bowtie /home/adminrig/src/BOWTIE/bowtie2-2.1.0 >& $F1"_bismark_bt2_pe.sam.log"


# less `which bismark.pe.sh`


~/src/bismark_v0.14.5/bismark_methylation_extrator --paired-end --report --ignore 2 --ignore_r2 2 --samtools_path `dirname $SAMTOOLS` --comprehensive $F1"_bismark.sam" >& $F1"_bismark.sam".methylextract.log



