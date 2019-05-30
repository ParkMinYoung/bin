cd $1
CEL=celfiles.txt
perl -MFile::Basename -nle'next if /^cel_files/; ($f)=fileparse($_);print join "\t", $f,$f' $CEL > SAM
awk '{print $1"\t"$1}' /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab > MARKER

cd batch
/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh ../SAM ../MARKER AxiomGT1.calls.txt
/home/adminrig/src/short_read_assembly/bin/calls2plink.sh AxiomGT1.calls.txt.extract /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab

