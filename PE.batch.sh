qsub -N lane1 ~/src/short_read_assembly/bin/sub Trim2Bwa.Pig.sh ./Sample_lane1/lane1_NoIndex_L001_R1_001.fastq.gz ./Sample_lane1/lane1_NoIndex_L001_R2_001.fastq.gz
sleep 20
qsub -N lane2 ~/src/short_read_assembly/bin/sub Trim2Bwa.Pig.sh ./Sample_lane2/lane2_NoIndex_L002_R1_001.fastq.gz ./Sample_lane2/lane2_NoIndex_L002_R2_001.fastq.gz
sleep 20
qsub -N lane3 ~/src/short_read_assembly/bin/sub Trim2Bwa.Pig.sh ./Sample_lane3/lane3_NoIndex_L003_R1_001.fastq.gz ./Sample_lane3/lane3_NoIndex_L003_R2_001.fastq.gz
sleep 20
qsub -N lane4 ~/src/short_read_assembly/bin/sub Trim2Bwa.Pig.sh ./Sample_lane4/lane4_NoIndex_L004_R1_001.fastq.gz ./Sample_lane4/lane4_NoIndex_L004_R2_001.fastq.gz
sleep 20
qsub -N lane5 ~/src/short_read_assembly/bin/sub Trim2Bwa.Pig.sh ./Sample_lane5/lane5_NoIndex_L005_R1_001.fastq.gz ./Sample_lane5/lane5_NoIndex_L005_R2_001.fastq.gz
sleep 20
qsub -N lane6 ~/src/short_read_assembly/bin/sub Trim2Bwa.Pig.sh ./Sample_lane6/lane6_NoIndex_L006_R1_001.fastq.gz ./Sample_lane6/lane6_NoIndex_L006_R2_001.fastq.gz
sleep 20
qsub -N lane7 ~/src/short_read_assembly/bin/sub Trim2Bwa.Pig.sh ./Sample_lane7/lane7_NoIndex_L007_R1_001.fastq.gz ./Sample_lane7/lane7_NoIndex_L007_R2_001.fastq.gz
sleep 20
qsub -N lane8 ~/src/short_read_assembly/bin/sub Trim2Bwa.Pig.sh ./Sample_lane8/lane8_NoIndex_L008_R1_001.fastq.gz ./Sample_lane8/lane8_NoIndex_L008_R2_001.fastq.gz
sleep 20
