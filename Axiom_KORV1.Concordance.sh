#!/bin/sh


. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

DIR=$1
DIR=../Analysis.*

TAQMAN_GENO=$2
TAQMAN_GENO=OtherGenotype.txt

## TaqMan Marker
ln -s /home/adminrig/workspace.min/AFFX/untested_library_files/TaqMan/MARKER/MARKER ./Marker
## Sample Cel file
head -1 OtherGenotype.txt | tr "\t" "\n" | sed -n '2,$'p | grep -f - ../../AnalysisResult/Summary.txt | cut -f1,2 > Sample
#cut -f1 OtherGenotype.txt | sed -n '2,$'p | grep -f - ../../AnalysisResult/Summary.txt | cut -f1,2 > Sample


/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh Sample Marker `find $DIR -type f | grep calls.txt$` 
#batch.SGE.sh /home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh `find ../{000217,000218,012*} -type f | grep calls.txt$` | perl -snle's/sh /sh $a $b /;print' -- -a=Sample -b=Marker | sed 's/sleep 15/sleep 3/' | sh 

#waiting Ext.Axiom



#MatrixMerge.v2.sh ChipGenotype `find $DIR -type f | grep extract$`
MatrixMerge.v2.sh ChipGenotype `find $DIR -type f | grep extract$ | grep -v SNPolisherPass.txt.extract `
Num2Geno.sh /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab ChipGenotype.txt > ChipGenotype.txt.Num2Geno


## Make OtherGenotype.txt
GenoSort.sh OtherGenotype.txt


Concordance.pairwise.sh ChipGenotype.txt.Num2Geno OtherGenotype.txt.GenoSort


GenoMatch.sh ChipGenotype.txt.Num2Geno OtherGenotype.txt.GenoSort


R CMD BATCH --no-save --no-restore ~/src/short_read_assembly/bin/R/Concordance.R

ExtractSignal.v4.sh Sample Marker `find $DIR -type f | grep -e calls.txt$ -e AxiomGT1.summary.txt$`


perl `which create_cluster_new.pl` ClusterSignal.txt
zip ClusterSignal.zip ClusterSignal/*png

. ../../config
\cp -f Concordance.png ClusterSignal.zip $COLLECT_HOME


else
	echo "../Analysis.2606.20150122 OtherGenotype.txt"
	usage "DIR OtherGenotype.txt"
fi
