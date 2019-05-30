find s_? | grep fastq$ | sort | xargs -n 4 echo "fastqc" | perl -nle'print "$_ --extract &"' > Batch.lane.fastqc.batch.sh

