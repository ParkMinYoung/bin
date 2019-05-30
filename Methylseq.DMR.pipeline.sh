#!/bin/bash


. ~/.bash_function

if [ -f "$1" ];then

		COV=$1
		Genome=$2
		IsRedun=$3
		GROUP=$(readlink -f $COV)
		


		dir=${COV%.cov}
		[ ! -d $dir ] && mkdir $dir 

		cd $dir

		## $dir.biseq : output prefix [DMS.GSK343.biseq]
		prefix=$dir.biseq
		R CMD BATCH --no-save --no-restore "--args $prefix $GROUP" /home/adminrig/src/short_read_assembly/bin/R/BiseqAnalysis.new.R

		DMR_TXT=$prefix.DMRs.annot.txt
		DMR_BED=$prefix.DMRs.annot.bed


		# excute time : 2018-06-15 15:41:44 : convert zero based bed
		CovertZeroBased.sh $DMR_TXT


		# excute time : 2018-06-15 09:52:39 : make txt 2 bed
		BiseqDMR2bed.sh $DMR_TXT


		# excute time : 2018-06-14 17:36:48 : 
		paste $prefix.predictedMeth.pos.txt $prefix.predictedMeth.txt | cut -f1,2,3,7- | perl -F'\t' -anle'if($.==1){print}else{--$F[1]; print join "\t", @F}' > predictedMeth.txt 


		# excute time : 2018-06-14 17:44:48 : 
		perl -F'\t' -anle'if($.>1){print join "\t", @F[0..2], (join ";", @F[3..$#F])}' predictedMeth.txt | bedtools intersect -a stdin -b $DMR_BED -wa -wb > predictedMeth.txt.DMR


		# excute time : 2018-06-15 09:03:35 : make MethSites
		perl -F"\t" -asnle'BEGIN{ @sample= split ",", $sample } if($.==1){ print join "\t", qw/DMR_chr DMR_start DMR_end M_chr M_start M_end/, @sample } print join "\t", @F[4,5,6],  @F[0..2], (split ";", $F[3]) ' -- -sample=$(cut -f1 $GROUP | tr "\n" ",") predictedMeth.txt.DMR > predictedMeth.txt.DMR.MethSites


		# excute time : 2018-06-15 09:23:08 : extract only regions including 10 meth sites >= 10
		tail -n +2 predictedMeth.txt.DMR.MethSites  | cut -f1-3 | uniq_cnt_e_desc | awk '$4>=10{print}' | grep -v ^GL | sed '1 i\chr\tstart\tend\tMethCount' > predictedMeth.txt.DMR.MethSites.10sites


		# excute time : 2018-06-15 09:26:26 : make new input
		join.extract.h.sh predictedMeth.txt.DMR.MethSites.10sites "1,2,3" 4 $DMR_TXT.0-based "1,2,3" "4,5,6,7,8,9" > filter.DMR.annot.txt 


		# excute time : 2018-06-15 09:32:10 : annotation
		/home/adminrig/src/short_read_assembly/bin/BiseqSNPEFF2Anno.sh filter.DMR.annot.txt $Genome 

###### 2019.02.12 Add

		# excute time : 2018-06-15 09:32:10 : removal Gene or Transcript lines
		perl -F'\t' -anle'if($F[8] !~ /(Transcript|Gene)/){print}' filter.DMR.annot.snpeff.bed.tab.txt > filter.DMR.annot.snpeff.bed.tab.txt.1  && \mv -f filter.DMR.annot.snpeff.bed.tab.txt.1 filter.DMR.annot.snpeff.bed.tab.txt

		# make same DMR bed file from filter.DMR.annot.snpeff.bed.tab.txt
		mv filter.DMR.annot.bed filter.DMR.annot.bed.bak
		tail -n +2 filter.DMR.annot.snpeff.bed.tab.txt | cut -f1-8 | sort | uniq | perl -F'\t' -anle' print join "\t", @F[0..2], (join ";", @F[3,4,6,7,8]) ' > filter.DMR.annot.bed

###### 2019.02.12 Add


		# excute time : 2018-06-15 09:37:58 : get filter DMR Methsites
		perl -F'\t' -anle'if($.>1){print join "\t", @F[0..2], (join ";", @F[3..$#F])}' predictedMeth.txt | bedtools intersect -a stdin -b filter.DMR.annot.bed -wa -wb > predictedMeth.txt.DMR.filter 


		# excute time : 2018-06-15 09:03:35 : make MethSites
		perl -F"\t" -asnle'BEGIN{ @sample= split ",", $sample } if($.==1){ print join "\t", qw/DMR_chr DMR_start DMR_end M_chr M_start M_end/, @sample } print join "\t", @F[4,5,6],  @F[0..2], (split ";", $F[3]) ' -- -sample=$(cut -f1 $GROUP | tr "\n" ",") predictedMeth.txt.DMR.filter > predictedMeth.txt.DMR.filter.MethSites

		
		if [ $# == 3 ];then

			# execute time : 2019-03-18 17:00:00 : removal redundant sample column
			mv predictedMeth.txt.DMR.filter.MethSites predictedMeth.txt.DMR.filter.MethSites.bak
			cut -f1-6,7,9 predictedMeth.txt.DMR.MethSites.bak | sed -n -e '1s/_1//g'p -e '2,$'p > predictedMeth.txt.DMR.filter.MethSites

		fi


		# excute time : 2018-06-15 10:25:50 : 
		NCol=$(_get_ncols.sh predictedMeth.txt.DMR.filter.MethSites)
		for i in $(seq 7 $NCol); do SAM=$(head -1 predictedMeth.txt.DMR.filter.MethSites | cut -f $i) ; tail -n +2 predictedMeth.txt.DMR.filter.MethSites | cut -f4-6,$i > $SAM.bed; done


		# excute time : 2018-06-15 11:12:58 : zip
		zip DMR_ResultBedBySample.zip $(cut -f1 $GROUP | xargs -n 1 -i echo {}.bed | tr "\n" " ")


		# excute time : 2018-06-15 11:09:12 : link
		ln -s predictedMeth.txt.DMR.filter.MethSites Methylations


		# excute time : 2018-06-15 11:09:24 : link
		ln -s filter.DMR.annot.snpeff.bed.tab.txt DMRs


		# excute time : 2018-06-15 11:11:17 : make excel
		TABList2XLSX.v2.sh "1,2,3,4,5,6,7,8,9,10,11,12" Methylations DMRs 


		# excute time : 2018-06-15 11:12:22 : rename
		mv TABList2.xlsx DMR_Result.xlsx 

else

cat <<EOF

# make group files : DMS.GSK343.cov
# output file prefix : DMS.GSK343

============================================================

${RED}1. Sample ID${NORM}
${RED}2. File Name${NORM}
${RED}3. Group(0/1)${NORM}

============================================================

${RED}example)${NORM}

DMSO1_re1       /home/adminrig/workspace.min/MethylSeq/20180424_IACF_LeeWooje/DMSO1_re1/DMSO1_re1_AACGTGAT_L006_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz       0
DMSO2_re2       /home/adminrig/workspace.min/MethylSeq/20180424_IACF_LeeWooje/DMSO2_re2/DMSO2_re2_GCCAAGAC_L006_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz       0
GSK343_re1      /home/adminrig/workspace.min/MethylSeq/20180424_IACF_LeeWooje/GSK343_re1/GSK343_re1_GATGAATC_L006_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz     1
GSK343_re2      /home/adminrig/workspace.min/MethylSeq/20180424_IACF_LeeWooje/GSK343_re2/GSK343_re2_CGAACTTA_L006_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.gz     1


${BLUE}BATCH example)${NORM}

# excute time : 2018-01-09 09:21:00 : batch script
for i in *.cov
  do 
  dir=\${i%.cov}
  [ ! -d \$dir ] && mkdir \$dir
  (cd \$dir && echo "R CMD BATCH --no-save --no-restore \"--args \$dir.biseq ../\$i\" /home/adminrig/src/short_read_assembly/bin/R/BiseqAnalysis.new.R"
done

# excute time : 2018-01-24 13:53:13 : annotation
for i in \$(find | grep DMRs.annot.txt$); do ~/src/short_read_assembly/bin/BiseqSNPEFF2Anno.sh $i; done &


# excute time : 2018-01-24 14:21:43 : merge step
AddRow.w.sh DMRs '\.\/(.+)\/' Analysis \$(find | grep uniq$)| grep Add | sh 

		
# excute time : 2018-06-14 16:11:27 : 
tail -n +2 DMS.GSK343.biseq.DMSO1_re1.raw.bed | bedtools sort -i stdin | bedtools intersect -a stdin -b DMS.GSK343.biseq.DMRs.annot.bed -sorted -wa -wb > DMS.GSK343.biseq.DMSO1_re1.raw.bed.DMR
for i in  *raw.bed; do tail -n +2 \$i | bedtools sort -i stdin | bedtools intersect -a stdin -b \$DMR_BED -sorted -wa -wb > \$i.DMR; done &
for i in  *rel.bed; do tail -n +2 \$i | bedtools sort -i stdin | bedtools intersect -a stdin -b \$DMR_BED -sorted -wa -wb > \$i.DMR; done & 
for i in  *smooth.bed;  do tail -n +2 \$i | bedtools sort -i stdin | bedtools intersect -a stdin -b \$DMR_BED -sorted -wa -wb > \$i.DMR; done &


EOF


		usage "XXX.cov [GRCh37.75:TAIR10.30,...]"

fi
