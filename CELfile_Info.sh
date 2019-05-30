
KNIH1=/home/adminrig/workspace.min/AFFX/Axiom_KORV1.1
ln -s $(find $KNIH1/Analysis -maxdepth 1 -mindepth 1 -type d -name "Analysis.CEL_Info*" | sort | tail -n 1)/CELfile_Information.Summary.txt

