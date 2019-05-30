plink2 --bfile $1 --recode --out $1 --allow-no-sex --threads 10 
awk '{print $1"\t"$2"\t"$3"\t"$4}' $1.bim > $1.pedsnp                   
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' $1.ped > $1.pedind

smartpca.perl -i $1.bed -a $1.bim -b $1.pedind -p $1.pca -e $1.eval -o $1.pca -q NO -l $1-smartpca.log


# excute time : 2017-02-28 10:32:40 : plink 2 out
PlinkOut2Tab.sh $1.pca.evec


# excute time : 2017-02-28 10:38:21 : get input
perl -F'\t' -anle'if(/^#/){print; print join "\t", ("ID", (map { "Eigenvector".$_ } 1..10), "Group") }else{ $F[0]=~/^(.+):/; $F[0]=$1; print join "\t", @F } ' $1.pca.evec.tab > $1.pca.evec.tab.input


R CMD BATCH --no-save --no-restore "--args $1.pca.evec.tab.input" /home/adminrig/src/short_read_assembly/bin/R/PCA.default.R

