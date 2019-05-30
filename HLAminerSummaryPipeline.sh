find | grep .csv$ | xargs -P 5 -i sh -c 'HLAminer.CSVParser.sh {} > {}.table  '


# execute time : 2018-08-17 10:20:09 : merge tables
AddRow.w.sh HLAminer_step1 '.+\/(.+?).csv' ID $(find | grep table$) | grep AddRow | sh 

# execute time : 2018-08-17 10:30:12 : step 2 
tblmutate -e 'join "|", $ID,$Gene,$Allele' -l "ID|Gene|Allele"  HLAminer_step1 > HLAminer_step2 


# execute time : 2018-08-17 10:37:17 : max
MaxValueListFromKey.sh 8 3 6  HLAminer_step2


# execute time : 2018-08-17 10:51:11 : 
perl -F"\t" -MMin -ane'chomp@F; next if /Confidence/;  ($id, $gene, $allele)=split /\|/, $F[0]; $h{$id}{$gene} .= defined $h{$id}{$gene} ? "|$F[3]" : $F[3] }{ mmfss_dot("HLAminer.Summary", %h) ' HLAminer_step2.MaxValueListFromKey 


# execute time : 2018-08-20 09:34:00 : make HLA Summary files
TABList2XLSX.v2.sh 1..14 HLAminer.Summary.txt HLAminer_step1 


# execute time : 2018-08-20 09:35:12 : rename
mv TABList2.xlsx HLAminer.Summary.xlsx 



