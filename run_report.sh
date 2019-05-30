# excute time : 2018-02-07 09:54:02 : link
ln -s /home/adminrig/src/short_read_assembly/bin/dependancy/human.genome.1Mb.bed ./


# excute time : 2018-02-07 09:47:26 : total bed
cut -f1,4 MergePlink.bim | awk '{print $1"\t"$2-1"\t"$2}' > MergePlink.bim.bed  


# excute time : 2018-02-07 09:48:03 : info > 0.8
cut -f1,4  MergePlink.info_scoreOver0.8.bim | awk '{print $1"\t"$2-1"\t"$2}' > MergePlink.info_scoreOver0.8.bim.bed 


# excute time : 2018-02-07 09:51:45 : total count
bedtools intersect -a human.genome.1Mb.bed -b MergePlink.bim.bed -c > MergePlink.bim.bed.count 
bedtools intersect -a human.genome.1Mb.bed -b MergePlink.info_scoreOver0.8.bim.bed -c > MergePlink.info_scoreOver0.8.bim.bed.count 


# excute time : 2018-02-07 11:30:48 : add header line
sed -i '1 i\chr\tstart\tend\tcount' *.bed.count 


# excute time : 2018-02-07 11:29:15 : merge count
AddRow.sh -o VariantCountPer1M -f "MergePlink.bim.bed.count MergePlink.info_scoreOver0.8.bim.bed.count" -l "Total Pass" -t Analysis


# excute time : 2018-02-07 12:44:30 : filter
egrep -v "^(X|Y|M)" VariantCountPer1M > VariantCountPer1M.bak


# excute time : 2018-02-07 12:44:42 : mv
\mv -f VariantCountPer1M.bak VariantCountPer1M


# excute time : 2018-02-07 12:55:52 : tar
tar cvzf raw.imputation.tgz MergePlink.{bed,bim,fam}
tar cvzf info_score.0.8.imputation.tgz MergePlink.info_scoreOver0.8.{bed,bim,fam}  

# excute time : 2018-03-12 22:57:41 : cp
cp /home/adminrig/src/short_read_assembly/bin/R/Report/AdvancedAnalysis.imputation.Rmd ./


# excute time : 2018-03-13 15:11:09 : run : Report
run.RMD.sh AdvancedAnalysis.imputation.Rmd 


