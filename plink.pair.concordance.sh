ls GPS*cleanup.bim  | sort | xargs -n 2 | perl -nle's/\.bim//g;($A,$B)= split " ", $_; print "plink --bfile $A --bmerge $B.bed $B.bim $B.fam --make-bed --out $A.concordance --merge-mode 7 --noweb"'

