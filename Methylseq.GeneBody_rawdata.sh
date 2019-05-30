#!/bin/bash
GENOMIC_RANGE_DIR=/home/adminrig/workspace.min/GenomicRange
SAMPLE_ID=$1
BISMARK_WORK_DIR=$2
mkdir $SAMPLE_ID
cd $SAMPLE_ID
SAMPLE_CX_REPORT=`find $BISMARK_WORK_DIR/$SAMPLE_ID -name $SAMPLE_ID*.CX_report.txt`
SAMPLE_CPG=${SAMPLE_ID}.filtered.txt
awk '{if($6=="CG"){if((($4+$5)>9)&&($1~/[0-9]|X|Y/)&&($1!~/^GL/)){print "chr"$1"\t"$2"\t"$2"\t"$3"\t"$4"\t"$5;}}}' $SAMPLE_CX_REPORT  > $SAMPLE_CPG
 
intersectBed \
     -a $SAMPLE_CPG \
     -b \
     $GENOMIC_RANGE_DIR/refSeq/GENEBODY.bed   \
     $GENOMIC_RANGE_DIR/refSeq/EXON.bed       \
     $GENOMIC_RANGE_DIR/refSeq/INTRON.bed     \
     $GENOMIC_RANGE_DIR/refSeq/CDS.bed        \
     $GENOMIC_RANGE_DIR/refSeq/UTR3.bed       \
     $GENOMIC_RANGE_DIR/refSeq/UTR5.bed       \
     $GENOMIC_RANGE_DIR/refSeq/UP1K.bed       \
     $GENOMIC_RANGE_DIR/refSeq/DW1K.bed       \
     $GENOMIC_RANGE_DIR/BED/cpgIslandExt.bed  \
     $GENOMIC_RANGE_DIR/BED/Enhancer.bed      \
     $GENOMIC_RANGE_DIR/BED/HCP.bed           \
     $GENOMIC_RANGE_DIR/BED/ICP.bed           \
     $GENOMIC_RANGE_DIR/BED/LCP.bed           \
     $GENOMIC_RANGE_DIR/BED/TE.bed            \
     $GENOMIC_RANGE_DIR/BED/TFBS.bed          \
     -wa -wb -names GENEBODY EXON INTRON CDS UTR3 UTR5 UP1K DW1K CGI Enhancer HCP ICP LCP TE TFBS > ${SAMPLE_ID}.CpG.bed
cat ${SAMPLE_ID}.CpG.bed | perl ~/bin/methyl_output.pl > ${SAMPLE_ID}.CpG.txt
awk '{if(NR>1){if($7!="-"){print $_;}}}' ${SAMPLE_ID}.CpG.txt | sort -k7 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$7){print a"\t"(b/n);a=$7;b=($4/($4+$5));n=1;}else{b=b+($4/($4+$5));n=n+1;}}END{print a"\t"(b/n);}' | awk '{if(NR>1){print $_;}}' > ${SAMPLE_ID}.CpG.GENEBODY.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/GENEBODY.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.GENEBODY.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/EXON.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.EXON.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/INTRON.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.INTRON.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/CDS.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.CDS.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/UTR3.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.UTR3.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/UTR5.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.UTR5.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/UP1K.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.UP1K.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/DW1K.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.DW1K.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/CGI.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.CGI.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/HCP.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.HCP.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/ICP.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.ICP.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/LCP.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.LCP.100bin.avg.txt
#intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/TFBS.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.TFBS.100bin.avg.txt
intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/TE.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.TE.100bin.avg.txt
#intersectBed -a $SAMPLE_CPG -b $GENOMIC_RANGE_DIR/binning_BED/Enhancer.100bin.bed -wa -wb | sort -k11 | awk 'BEGIN{a=0;b=0;n=1;}{if(a!=$11){if(a!=0){print a"\t"(b/n);}a=$11;b=($5/($5+$6));n=1;}else{b=b+($5/($5+$6));n=n+1;}}END{print a"\t"(b/n);}' | sort -k1 -n > ${SAMPLE_ID}.CpG.Enhancer.100bin.avg.txt
cat ${SAMPLE_ID}.CpG.UP1K.100bin.avg.txt ${SAMPLE_ID}.CpG.GENEBODY.100bin.avg.txt ${SAMPLE_ID}.CpG.DW1K.100bin.avg.txt | awk 'BEGIN{a=1;}{print a"\t"$2;a++}' > ${SAMPLE_ID}.CpG.UP1K.GENEBODY.DW1K.100bin.avg.txt
cat ${SAMPLE_ID}.CpG.UP1K.100bin.avg.txt ${SAMPLE_ID}.CpG.UTR5.100bin.avg.txt ${SAMPLE_ID}.CpG.CDS.100bin.avg.txt ${SAMPLE_ID}.CpG.INTRON.100bin.avg.txt ${SAMPLE_ID}.CpG.UTR3.100bin.avg.txt ${SAMPLE_ID}.CpG.DW1K.100bin.avg.txt | awk 'BEGIN{a=1;}{print a"\t"$2;a++}' > ${SAMPLE_ID}.CpG.UP1K.UTR5.CDS.INTRON.UTR3.DW1K.100bin.avg.txt
awk '{print $1"\t"$2"\tHCP";}' ${SAMPLE_ID}.CpG.HCP.100bin.avg.txt  > ${SAMPLE_ID}.CpG.HCP.ICP.LCP.100bin.avg.txt
awk '{print $1"\t"$2"\tICP";}' ${SAMPLE_ID}.CpG.ICP.100bin.avg.txt >> ${SAMPLE_ID}.CpG.HCP.ICP.LCP.100bin.avg.txt
awk '{print $1"\t"$2"\tLCP";}' ${SAMPLE_ID}.CpG.LCP.100bin.avg.txt >> ${SAMPLE_ID}.CpG.HCP.ICP.LCP.100bin.avg.txt
awk '{print $1"\t"$2"\tCGI";}' ${SAMPLE_ID}.CpG.CGI.100bin.avg.txt  > ${SAMPLE_ID}.CpG.CGI.TE.100bin.avg.txt
awk '{print $1"\t"$2"\tTE";}'  ${SAMPLE_ID}.CpG.TE.100bin.avg.txt  >> ${SAMPLE_ID}.CpG.CGI.TE.100bin.avg.txt
