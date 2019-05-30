while IFS=$'\t' read -r column1 column2 column3 ; do

		mkdir ${column1} 
		ln -s `find $PWD/41_* -type f | grep 1.fastq$` ${column1}

		cd ${column1}
		Fastq2SampleDir.sh
		qsub -N bismark_N -pe orte 20 -q utl.q ~/src/short_read_assembly/bin/sub.93 ../bismark.pipeline.v2.sh 41_Normal/41_Normal_TTAGGC_L005_R1_001.fastq 41_Normal/41_Normal_TTAGGC_L005_R2_001.fastq ${column2} ${column3}

		qsub -N bismark_T -pe orte 20 -q utl.q ~/src/short_read_assembly/bin/sub.93 ../bismark.pipeline.v2.sh 41_ov_cancer/41_ov_cancer_TGACCA_L005_R1_001.fastq 41_ov_cancer/41_ov_cancer_TGACCA_L005_R2_001.fastq ${column2} ${column3} 

		cd ..

done < "folder"

