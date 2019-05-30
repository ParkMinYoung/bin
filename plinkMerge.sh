# plink merge 
DIR=$1

PlinkMerge=plinkMerge
mkdir $PlinkMerge

ls $DIR/*bed | sed 's/\.bed//' > $PlinkMerge/merge_list

P1=$(head -1 $PlinkMerge/merge_list)
sed -n '2,$'p $PlinkMerge/merge_list | perl -nle'$f=$_; print join "\t", (map { $f.$_ } qw/.bed .bim .fam/);' > $PlinkMerge/merge_list.txt
rm -rf $PlinkMerge/merge_list

/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $P1 --merge-list $PlinkMerge/merge_list.txt --make-bed --out $PlinkMerge/MergePlink --allow-no-sex --threads 5 
#plink --bfile $P1 --merge-list $PlinkMerge/merge_list.txt --make-bed --out $PlinkMerge/MergePlink --noweb


## convert plink to genotype
#plink2genotype.sh $PlinkMerge/MergePlink.bed

