CEL=celfiles.txt
perl -nle'next if /^cel/; s/\.\.\/\.\.\///;  /(A.+\.CEL)/; print "$1\t$1"' $CEL > SAM
awk '{print $1"\t"$1}' /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_SNUHDMEX.na34.annot.csv.tab > MARKER

/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh SAM MARKER AxiomGT1.calls.txt
./calls2plink.SNUHDMEX.sh AxiomGT1.calls.txt.extract /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_SNUHDMEX.na34.annot.csv.tab

plink --bfile AxiomGT1.calls.txt.extract.plink_fwd.gender --extract batch/SNPolisherPassSNV --genome --maf 0.4 --geno 0.1 --mind 0.1 --hwe 0.001 --min 0.05 --out AxiomGT1.calls.txt.extract.plink.IBS --noweb
R CMD BATCH --no-save --no-restore '--args AxiomGT1.calls.txt.extract.plink.IBS.genome ' ~/src/short_read_assembly/bin/R/IBS.scatterplot3d.final.R


