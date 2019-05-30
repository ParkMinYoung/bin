find $PWD/ -type f | grep fastq$ | perl -nle'/IonXpress_(\d{3})_R_.+_user_(.+).fastq/;$N="$2.$1_GCCAAT_L007_R1_001.fastq.gz.N.fastq";print "cp $_ $N; gzip $N"' | sh


DIR=FASTQ.`date +%Y%m%d`
mkdir $DIR

mv *.fastq.gz $DIR
cd $DIR 
Fastq2SampleDir.sh



