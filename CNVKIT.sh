
#####################
## First  Analysis ## 
#####################


## Setting

# excute time : 2017-09-18 19:44:12 : make folder
mkdir -p Output/{Y,N} Reference.cnn/{Y,N} BED Reference


# excute time : 2017-11-15 20:59:54 : script copy
cp /home/adminrig/workspace.min/KNIH.IncurableDisease/CNVKit/CNVKit.step1.sh /home/adminrig/workspace.min/KNIH.IncurableDisease/CNVKit/WES.cnvkit.v2.sh ./


# excute time : 2017-11-15 21:02:53 : link
#ln -s ../Pairs Pairs.v2 
(cd ../ && ln -s Pairs Pairs.v2)




#### BED ####

# excute time : 2017-11-15 21:04:45 : copy readme
cp /home/adminrig/workspace.min/KNIH.IncurableDisease/CNVKit/Output/readme Output/
(cd Output && ln -s ../../Pairs.v2 ./)


# excute time : 2017-11-15 21:05:36 : make bed link
ln -s /home/wes/Genome/SureSelect/V4/Sureselect_V4_UTR_Regions.bed /home/wes/Genome/SureSelect/V5/Sureselect_V5_UTR_Regions.bed BED/


# excute time : 2017-11-15 21:05:46 : copy readme from BED
cp /home/adminrig/workspace.min/KNIH.IncurableDisease/CNVKit/BED/readme BED


# excute time : 2017-11-15 21:06:01 : execute readme script in the BED DIR
(cd BED && sh readme)
(cd BED && for i in  V4.bed  V5.bed; do sed -i 's/^chr//' $i ; done)




#### Reference ####

# excute time : 2017-11-15 21:09:12 : reference link
#ln -s /home/wes/src/GATK/resource_bundle/latest/hg19/ucsc.hg19.fasta{,.fai} Reference/
ln -s /home/adminrig/src/GATK/GenomeAnalysisTK-1.6-11-g3b2fab9/resource.bundle/1.5/b37/human_g1k_v37.fasta Reference/ucsc.hg19.fasta


(cd Reference && wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/refFlat.txt.gz && gunzip refFlat.txt.gz)
(cd Reference && sed -i 's/chr//' refFlat.txt)


# /root/miniconda2/bin/python /root/miniconda2/bin/cnvkit.py access Reference/ucsc.hg19.fasta -s 5000 -o access-5kb-mappable.hg19.bed
# excute time : 2017-11-15 21:11:05 : access bed link
ln -s /home/adminrig/workspace.min/KNIH.IncurableDisease/CNVKit/access-5kb-mappable.hg19.bed ./
perl -i.bak -ple's/^chr//' access-5kb-mappable.hg19.bed




#### BAM ####

# excute time : 2017-11-15 21:22:23 : make bam link
(cd BAM && ReNamePattern2Pattern.sym.sh  .mergelanes.dedup.realign.recal "" *ba* | sh)




#### Analysis #### 

# excute time : 2017-11-15 21:25:01 : execute CNVKit 1
sh WES.cnvkit.v2.sh | sh 


# excute time : 2017-09-19 15:19:30 : get heatmap
/root/miniconda2/bin/cnvkit.py heatmap ` find | grep cns$ | sort`  -o all.cns.pdf 


# excute time : 2017-07-17 14:45:21 : option d
/root/miniconda2/bin/cnvkit.py heatmap ` find | grep cns$ | sort` -d -o all.cns.d.pdf


# excute time : 2017-07-17 16:38:05 : get Gender Info
/root/miniconda2/bin/cnvkit.py sex $( find -type f | egrep "cn(r|n|s)"$ | sort )  > Sex


# execute step1 analysis
find | grep cnr$ | sort  | xargs -i -n 1 -P5 ./CNVKit.step1.sh {}



