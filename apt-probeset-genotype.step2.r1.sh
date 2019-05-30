#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

LIB_DIR=/home/adminrig/workspace.min/AFFX/untested_library_files
TAB=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab
GENO_XML=$LIB_DIR/Axiom_KORV1_0_96orMore_Step2.r1.apt-probeset-genotype.AxiomGT1.xml
DQC_XML=$LIB_DIR/Axiom_KORV1_0.r1.apt-geno-qc.AxiomQC1.xml

if [ -f "config" ];then
	source $PWD/config
fi

#DIR=APT.step1.r1
DIR=Analysis
mkdir -p $DIR
CEL=$1

time apt-geno-qc --xml-file $DQC_XML --analysis-files-path $LIB_DIR --out-file $DIR/apt-geno-qc.txt --cel-files $CEL
time apt-probeset-genotype --xml-file $GENO_XML --analysis-files-path $LIB_DIR --out-dir $DIR --cel-files $CEL --write-models --summaries --force

AffyChipSummary.txt.sh

#perl -nle'next if /^cel/; s/\.\.\/\.\.\///; /.+_\w+\d+_\w{2,3}_(.+)\.CEL/; $id=$1; $id =~ s/_(2|3|4)$//; print "$_\t$id"' $CEL > SAM
perl -MFile::Basename -nle'next if /^cel/; ($f)=fileparse($_); $f=~/.+_\w+\d+_\w{2,3}_(.+)\.CEL/; $id=$1; $id =~ s/_(2|3|4)$//; print "$f\t$id"' $CEL > SAM
awk '{print $1"\t"$1}' $TAB > MARKER

cd $DIR
/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh ../SAM ../MARKER AxiomGT1.calls.txt
/home/adminrig/src/short_read_assembly/bin/calls2plink.sh AxiomGT1.calls.txt.extract $TAB

perl -F'\t' -anle'BEGIN{$sex{"male"}=1;$sex{"female"}=2;$sex{"unknown"}=0} if(/^cel_files/){$flag=1}elsif($flag){print join "\t", @F[0,0],$sex{$F[1]};}' ../batch/AxiomGT1.report.txt > AxiomGT1.report.txt.gender
plink --bfile AxiomGT1.calls.txt.extract.plink_fwd --update-sex AxiomGT1.report.txt.gender --make-bed --out AxiomGT1.calls.txt.extract.plink_fwd.gender --noweb



else
	echo "celfiles.sh && apt-probeset-genotype.step2.r1.sh celfiles" 
	usage "celfiles"
fi

