batch.SGE.sh fastqc `find | grep gz$ ` > 01.fastqc
sh 01.fastqc
waiting fas
/home/adminrig/src/short_read_assembly/bin/fastc_data.merge.summaryV3.sh `find | grep fastqc_data.txt$`

