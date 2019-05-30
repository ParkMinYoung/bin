# for i in `find Group/s_? | grep sorted.bam$`;do echo "bam2bcf.sh $i >& $i.bam2bcf.log &";done | sh
for i in $@ ;do echo "bam2bcf.sh $i >& $i.bam2bcf.log &";done | sh
