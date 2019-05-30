
KORV2L=$1


## symbolic link
ln -s /home/adminrig/Genome/1000Genomes/20130502/1000GP_Phase3.VCF/1000GP_Phase3.VCF2Plink/QCPlink/plinkMerge/EastAsian/EastAsian.frq.tab.1 EastAsian.frq.tab.1.SortGeno
ln -s /home/adminrig/Genome/1000Genomes/20130502/1000GP_Phase3.VCF/1000GP_Phase3.VCF2Plink/QCPlink/plinkMerge/EastAsian/EastAsian.frq.tab.5 EastAsian.frq.tab.5.SortGeno



# excute time : 2016-12-08 19:12:43 : get dup from bim
perl -F'\t' -anle'$k=join ":", @F[0,3], sort(@F[4,5]); print $k' MergePlink.info_scoreOver0.8.bim | sort | uniq -dc > MergePlink.info_scoreOver0.8.bim.dup


# excute time : 2016-12-08 19:29:27 : backup bim
mv MergePlink.info_scoreOver0.8.bim MergePlink.info_scoreOver0.8.bim.original
mv MergePlink.bim MergePlink.bim.original



# excute time : 2016-12-08 19:29:47 : make new bim
#perl -F'\t' -anle'if(@ARGV){ $h{$F[0]} = join ":", @F[4,6,11,12] }else{ if($F[1]=~/^A/){$F[1] = $h{$F[1]} }elsif($F[1]=~s/^rs\d+/$F[0]/){} print join "\t", @F }' $KORV2L MergePlink.info_scoreOver0.8.bim.original > MergePlink.info_scoreOver0.8.bim  
#perl -F'\t' -anle'if(@ARGV){ $h{$F[0]} = join ":", @F[4,6,11,12] }else{ if($F[1]=~/^A/){$F[1] = $h{$F[1]} }elsif($F[1]=~s/^rs\d+/$F[0]/){} print join "\t", @F }' $KORV2L MergePlink.bim.original > MergePlink.bim  
perl -F'\t' -anle'if(@ARGV){ $h{$F[0]} = join ":", @F[4,6,11,12] }else{ if($F[1]=~/^A/){$new=$h{$F[1]}; $F[1] = $new if !$redun{$new} }elsif($F[1]=~s/^rs\d+/$F[0]/){} $redun{$F[1]}++; print join "\t", @F }' $KORV2L MergePlink.info_scoreOver0.8.bim.original > MergePlink.info_scoreOver0.8.bim

perl -F'\t' -anle'if(@ARGV){ $h{$F[0]} = join ":", @F[4,6,11,12] }else{ if($F[1]=~/^A/){$new=$h{$F[1]}; $F[1] = $new if !$redun{$new} }elsif($F[1]=~s/^rs\d+/$F[0]/){} $redun{$F[1]}++; print join "\t", @F }' $KORV2L MergePlink.bim.original > MergePlink.bim


MakeSortedGenoBim.sh MergePlink 
MakeSortedGenoBim.sh MergePlink.info_scoreOver0.8


# excute time : 2016-12-12 20:42:52 : make folder

mkdir scoreOverall scoreOver0.8


# make step 1 

cd scoreOverall

ln -s ../EastAsian.frq.tab.*SortGeno ../MergePlink.SortedGeno.??? ./

ListStatus.sh  EastAsian.frq.tab.1.SortGeno 2 MergePlink.SortedGeno.bim 2 
ListStatus.sh  EastAsian.frq.tab.5.SortGeno 2 MergePlink.SortedGeno.bim 2 

MissingMarkerMerge_GetCallRate.sh EastAsian.frq.tab.1.SortGeno.missing EastAsian.frq.tab.1.SortGeno.found MergePlink.SortedGeno 1
MissingMarkerMerge_GetCallRate.sh EastAsian.frq.tab.5.SortGeno.missing EastAsian.frq.tab.5.SortGeno.found MergePlink.SortedGeno 5

### get Summary ###

# MAF 5
Total5=$(wc -l EastAsian.frq.tab.5.SortGeno | awk '{print $1}')
Overlap5=$(wc -l MergePlink.SortedGeno.EAS_5.bim | awk '{print $1}')

MAF5=$(echo "scale=5; $Overlap5/$Total5*100" | bc)

MAF5_only_overlap_CR=$(grep Total MergePlink.SortedGeno.EAS_5.log | grep -o "0.\d{3,}" -P)
MAF5_include_missing_CR=$(grep Total MergePlink.SortedGeno.EAS_5.final.log | grep -o "0.\d{3,}" -P)

# MAF 1-5
Total1=$(wc -l EastAsian.frq.tab.1.SortGeno | awk '{print $1}')
Overlap1=$(wc -l MergePlink.SortedGeno.EAS_1.bim | awk '{print $1}')

MAF1=$(echo "scale=5; $Overlap1/$Total1*100" | bc)

MAF1_only_overlap_CR=$(grep Total MergePlink.SortedGeno.EAS_1.log | grep -o "0.\d{3,}" -P)
MAF1_include_missing_CR=$(grep Total MergePlink.SortedGeno.EAS_1.final.log | grep -o "0.\d{3,}" -P)

# echo
echo -e "\tMAF1-5\tMAF5
Total\t$Total1\t$Total5
Cover\t$Overlap1\t$Overlap5
GenomeCov\t$MAF1\t$MAF5
CoverCR\t$MAF1_only_overlap_CR\t$MAF5_only_overlap_CR
AllCR\t$MAF1_include_missing_CR\t$MAF5_include_missing_CR" > CoverageSummary

cd ..




# make step 2

cd scoreOver0.8

ln -s ../EastAsian.frq.tab.*SortGeno ../MergePlink.info_scoreOver0.8.SortedGeno.??? ./

ListStatus.sh  EastAsian.frq.tab.1.SortGeno 2 MergePlink.info_scoreOver0.8.SortedGeno.bim 2 
ListStatus.sh  EastAsian.frq.tab.5.SortGeno 2 MergePlink.info_scoreOver0.8.SortedGeno.bim 2 

MissingMarkerMerge_GetCallRate.sh EastAsian.frq.tab.1.SortGeno.missing EastAsian.frq.tab.1.SortGeno.found MergePlink.info_scoreOver0.8.SortedGeno 1
MissingMarkerMerge_GetCallRate.sh EastAsian.frq.tab.5.SortGeno.missing EastAsian.frq.tab.5.SortGeno.found MergePlink.info_scoreOver0.8.SortedGeno 5

### get Summary ###


# MAF 5
Total5=$(wc -l EastAsian.frq.tab.5.SortGeno | awk '{print $1}')
Overlap5=$(wc -l MergePlink.info_scoreOver0.8.SortedGeno.EAS_5.bim | awk '{print $1}')

MAF5=$(echo "scale=5; $Overlap5/$Total5*100" | bc)

MAF5_only_overlap_CR=$(grep Total MergePlink.info_scoreOver0.8.SortedGeno.EAS_5.log | grep -o "0.\d{3,}" -P)
MAF5_include_missing_CR=$(grep Total MergePlink.info_scoreOver0.8.SortedGeno.EAS_5.final.log | grep -o "0.\d{3,}" -P)

# MAF 1-5
Total1=$(wc -l EastAsian.frq.tab.1.SortGeno | awk '{print $1}')
Overlap1=$(wc -l MergePlink.info_scoreOver0.8.SortedGeno.EAS_1.bim | awk '{print $1}')

MAF1=$(echo "scale=5; $Overlap1/$Total1*100" | bc)

MAF1_only_overlap_CR=$(grep Total MergePlink.info_scoreOver0.8.SortedGeno.EAS_1.log | grep -o "0.\d{3,}" -P)
MAF1_include_missing_CR=$(grep Total MergePlink.info_scoreOver0.8.SortedGeno.EAS_1.final.log | grep -o "0.\d{3,}" -P)

# echo
echo -e "\tMAF1-5\tMAF5
Total\t$Total1\t$Total5
Cover\t$Overlap1\t$Overlap5
GenomeCov\t$MAF1\t$MAF5
CoverCR\t$MAF1_only_overlap_CR\t$MAF5_only_overlap_CR
AllCR\t$MAF1_include_missing_CR\t$MAF5_include_missing_CR" > CoverageSummary


cd ..

