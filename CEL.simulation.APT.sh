
GOOD=Good.SortedList
BAD=Bad.List
GOOD_DIR=/home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/Axiom_KORV1.0.2016.KNIH.v1/Summary/Good
BAD_DIR=/home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/Axiom_KORV1.0.2016.KNIH.v1/Summary/Bad

for i in 50 100 150 200 250 300 350 400 450 500; 
    do echo $i; 
    
    OUT=simulation.$i
    mkdir $OUT
    (echo "cel_files"; 
	head -$i $GOOD | xargs -i echo $GOOD_DIR/{} ; 
	head -$i $BAD | xargs -i echo $BAD_DIR/{} 
    ) > simulation.$i/celfiles

    (cd $OUT && sh apt-probeset-genotype.step2.r1.sh celfiles)
    
done
