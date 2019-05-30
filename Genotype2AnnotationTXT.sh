# excute time : 2016-10-11 13:48:20 : make merged matrix
MatrixMerge.v2.sh Merge.v1 `find 0000*/batch/ | grep Genotype$` 


# excute time : 2016-10-11 17:21:59 : Get Cel 2 ID
cut -f1,2 ../AnalysisResult/Summary.txt > CEL2ID 


# excute time : 2016-10-11 17:24:49 : chage header
ExtractOrderColumn.sh CEL2ID Merge.v1.txt > Merge.v1.txt.ID  


# excute time : 2016-10-11 17:26:06 : add Annotation
AddExtraColumn.sh Merge.v1.txt.ID /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_JJBC/Axiom_JJBC1SNP.na35.annot.csv.tab 1 "3,5,6,7,8,10,14,15" 


# excute time : 2016-10-11 17:28:15 : make hard link
ln Merge.v1.txt.ID.AddExtraColumn JJBC.v1.genotype.txt 


# excute time : 2016-10-11 17:28:46 : cleanup
rm -rf Merge.v1.txt* CEL2ID 


