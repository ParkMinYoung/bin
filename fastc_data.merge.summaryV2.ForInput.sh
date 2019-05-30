#!/bin/sh

find $PWD -type f | egrep "(N.fastq.gz|ing.bam)"$ | sort | xargs ls -lh > Alignment.info 

perl -F'\s+' -MMin -ane'
chomp@F; 
#$F[8]=~/(\d{6}.+)\/(Project_KNIH.(set\d+)\/Sample_.+)\/(\S+)_(\w{6})_(L00\d)_(R\d)_\d+/;
$F[8]=~/(\d{6}.+)\/Data.+(Project_KNIH.(set\d+)\/Sample_.+)\/(.+)_(\w{6})_(L00\d)_(R\d)_\d+/;
($batch,$proj_dir,$set,$id,$index,$lane,$read)=($1,$2,$3,$4,$5,$6,$7);

if( $F[8] =~ /fastq.gz$/ ){
	print join "\t", $batch,$set,$lane,$id,$proj_dir,$index,$read,$&,$F[4],"\n";
}elsif($F[8]=~/bam$/){
	print join "\t", $batch,$set,$lane,$id,$proj_dir,$index,$read,$&,$F[4],"\n";
}

' Alignment.info > Alignment.info.summary


# cd RawSeqAnalaysis/fastqc_data/
# sh ./fastc_data.merge.summaryV2.sh ../../$FILE.summary set*.txt


# -rwxrwx--- 1 adminrig adminrig 2.5G Oct 24 00:17 /home/adminrig/SolexaData.2/111011_SN337R_0318_AC0278ACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set42/Sample_10-381LT/10-381LT_TGACCA_L008_R1_001.fastq.gz.N.fastq.gz




# -rwxrwx--- 1 adminrig adminrig 3.1G Sep 30 22:57 /home/adminrig/SolexaData/110902_SN848_0173_AD04GHACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set1/Sample_VP02226/VP02226_ACAGTG_L001_R1_001.fastq.gz.N.fastq.gz
# -rwxrwx--- 1 adminrig adminrig 6.1G Oct  4 23:46 /home/adminrig/SolexaData/110902_SN848_0173_AD04GHACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set1/Sample_VP02226/VP02226_ACAGTG_L001_R1_001.fastq.gz.N.fastq.gz.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam
# -rwxrwx--- 1 adminrig adminrig 3.1G Sep 30 22:52 /home/adminrig/SolexaData/110902_SN848_0173_AD04GHACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set1/Sample_VP02226/VP02226_ACAGTG_L001_R2_001.fastq.gz.N.fastq.gz
# -rwxrwx--- 1 adminrig adminrig 3.6G Sep 30 23:03 /home/adminrig/SolexaData/110902_SN848_0173_AD04GHACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set1/Sample_VP02696/VP02696_CTTGTA_L001_R1_001.fastq.gz.N.fastq.gz
# -rwxrwx--- 1 adminrig adminrig 8.4G Oct  5 01:21 /home/adminrig/SolexaData/110902_SN848_0173_AD04GHACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set1/Sample_VP02696/VP02696_CTTGTA_L001_R1_001.fastq.gz.N.fastq.gz.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam
# -rwxrwx--- 1 adminrig adminrig 3.6G Sep 30 23:06 /home/adminrig/SolexaData/110902_SN848_0173_AD04GHACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set1/Sample_VP02696/VP02696_CTTGTA_L001_R2_001.fastq.gz.N.fastq.gz
# -rwxrwx--- 1 adminrig adminrig 1.7G Sep 30 22:41 /home/adminrig/SolexaData/110902_SN848_0173_AD04GHACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set1/Sample_VP02952/VP02952_CAGATC_L001_R1_001.fastq.gz.N.fastq.gz
# -rwxrwx--- 1 adminrig adminrig 4.2G Oct  4 03:35 /home/adminrig/SolexaData/110902_SN848_0173_AD04GHACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set1/Sample_VP02952/VP02952_CAGATC_L001_R1_001.fastq.gz.N.fastq.gz.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam
# -rwxrwx--- 1 adminrig adminrig 1.7G Sep 30 22:41 /home/adminrig/SolexaData/110902_SN848_0173_AD04GHACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set1/Sample_VP02952/VP02952_CAGATC_L001_R2_001.fastq.gz.N.fastq.gz
# -rwxrwx--- 1 adminrig adminrig 1.9G Sep 30 22:44 /home/adminrig/SolexaData/110902_SN848_0173_AD04GHACXX/Data/Intensities/BaseCalls/Fastq/Project_KNIH.set1/Sample_VP03160/VP03160_CGATGT_L001_R1_001.fastq.gz.N.fastq.gz




