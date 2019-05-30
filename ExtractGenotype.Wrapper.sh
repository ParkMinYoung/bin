cut -f1 ../SAM  > SAM





/home/adminrig/src/short_read_assembly/bin/ExtractGeno.sh SAM MARKER AxiomGT1.calls.txt 


Num2Geno.Affy.sh /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab AxiomGT1.calls.txt.extract  > Genotype

ExtractSignal.v3.sh SAM MARKER AxiomGT1.calls.txt AxiomGT1.summary.txt


head -1 Genotype | tr "\t" "\n"  | head -1  | awk '{print $1"\t"$1}' > SAM.reheader
head -1 Genotype | tr "\t" "\n" | sed -n '2,$'p | CELName.sh | awk '{print $4"\t"$3}' >> SAM.reheader


ExtractOrderColumn.sh SAM.reheader Genotype > Genotype.reheader
substitution.sh Genotype.reheader 1 MARKER 1 2 > Genotype

