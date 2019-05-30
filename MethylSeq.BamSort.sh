
mkdir -p DMR/BAM

samplelist=$(find ./ -maxdepth 1 -mindepth 1 -type d | sort | grep "\/" | egrep -vi "(tmp|dmr|DepthCoverage|FastqcZip|GeneBody|MethylSeq.AnalysisReport.pdf_files|figure.png|HTML)" | sed 's/\.\///')

find $samplelist | grep .deduplicated.bam$ | xargs -i readlink -f {} | xargs -i ln -s {} DMR/BAM


cd DMR/BAM

ls *.deduplicated.bam | perl -nle'print join "\t", "BamSort", $_'  > args_table


# excute time : 2018-01-24 09:04:54 : run bam sort + index
# batch.SGE.93.sh /home/adminrig/src/short_read_assembly/bin/Bam_sort_index.sh *bam | sh &
batch.SGE2.args_table.sh /home/adminrig/src/short_read_assembly/bin/Bam_sort_index.sh args_table | sh  
waiting Bam-BamS 


