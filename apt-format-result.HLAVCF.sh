HLA=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1.1/HLA/HLA.chr6.AX
DB=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1.1/Axiom_KORV1_1.na35.annot.db

apt-format-result --calls-file AxiomGT1.calls.txt --annotation-file $DB --export-vcf-file output.vcf --snp-list-file $HLA --snp-identifier-column Affy_SNP_ID


