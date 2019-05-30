
OUTPUT=${1%.pdf}.txt

# execute time : 2018-09-06 14:35:53 : pdf 2 txt
pdftotext -layout $1 #> $1.txt


#link https://www.radboudumc.nl/en/patientenzorg/onderzoeken/exome-sequencing-diagnostics/exomepanelspreviousversions/mendeliome 

# execute time : 2018-09-06 14:40:35 : 
sed -i 's/\f//'  $OUTPUT


perl -nle'
BEGIN{
	print join "\t", qw/Gene MedianCoverage DP10X DP20X PhenotypeDesc_OMIN/
}
if(/^(\w+)\s+(\d+|\d+.\d+)\s+(\d+)\s+(\d+)\s+(.+)/){ print join "\t", $1, $2, $3, $4, $5}elsif(/^(\w+)\s{10}\s+(.+)/){print join "\t", $1,"","","",$2}' $OUTPUT > $OUTPUT.tab


# execute time : 2018-09-06 15:34:42 : 
~/src/short_read_assembly/bin/GetGeneBedFromUCSCrefFlat.sh


# execute time : 2018-09-06 15:34:56 : 
~/src/short_read_assembly/bin/GetGeneBedFromUCSCrefFlat.sh refFlat.txt 


# execute time : 2018-09-06 15:35:48 : add header
sed -i '1i\chr\tstart\tend\tGene'  refFlat.Gene.bed 


# execute time : 2018-09-06 15:36:36 : add gene region
 join.h.sh $OUTPUT.tab refFlat.Gene.bed 1 4 "1..3" > $OUTPUT.tab.Loc


# execute time : 2018-09-06 15:37:03 : link
 ln -s $OUTPUT.tab ${1%.pdf}


