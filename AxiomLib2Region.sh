

# excute time : 2018-03-26 10:34:37 : add Gene & Region
perl -F"\t" -anle'if($.==1){print join "\t", @F[0..14], "Gene", "Region"}else{ @genes = split " \/\/\/ ", $F[15]; @anno = split " \/\/ ", $genes[0]; print join "\t", @F[0..14], $anno[4], $anno[1] }' $1  > $1.gene


# excute time : 2018-03-26 10:43:03 : add Other marker info
perl -F'\t' -anle'$k=join ":", @F[4..6,11,12]; if(@ARGV){ $h{$k}++ }else{ if( !$c++ ){print join "\t", @F, "DoExist"}else{ $Tag = $h{$k} ? "Y" : "N"; print join "\t", $_, $Tag } }' Axiom_KORV1_1.na35.annot.csv.tab  $1.gene > $1.gene.DoExist 


# excute time : 2018-03-26 10:49:58 : link
ln -s $1.gene.DoExist out 


# excute time : 2018-03-26 11:41:21 : run
cp /home/adminrig/src/short_read_assembly/bin/R/Report/AxiomLibraryComparison.Rmd ./ && run.RMD.sh AxiomLibraryComparison.Rmd 



