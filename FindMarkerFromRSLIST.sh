KORV1L=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab

(head -1 $KORV1L; grep -f rslist -w $KORV1L) > Info

## Add GSK extra rs list
cut -f 1,3 Info > Marker

