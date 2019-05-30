# plink merge 
DIR=$1

PlinkMerge=plinkMerge
mkdir $PlinkMerge

ls -S $DIR/*ped | sed 's/\.ped//' > $PlinkMerge/merge_list

P1=$(head -1 $PlinkMerge/merge_list)
sed -n '2,$'p $PlinkMerge/merge_list | perl -nle'$f=$_; print join "\t", (map { $f.$_ } qw/.ped .map/);' > $PlinkMerge/merge_list.txt
rm -rf $PlinkMerge/merge_list

plink --file $P1 --merge-list $PlinkMerge/merge_list.txt --make-bed --out $PlinkMerge/MergePlink --noweb


## convert plink to genotype
plink2genotype.sh $PlinkMerge/MergePlink.bed

