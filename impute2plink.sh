#!/bin/sh

. ~/.bash_function

if [ -d "$1" ];then

PLINK=/home/adminrig/src/PLINK/plink-1.09-x86_64/plink
IMPUTE2_DIR=$1

#ln -s ../shapeit/chr10_phased.sample sample
ln -s $(ls ../shapeit.1kg.phase3/*_phased.sample | head -1) sample

cd $IMPUTE2_DIR

DIR=Imputation2Plink
mkdir $DIR


for i in chr*.gz;
    do 
    chr=$(echo $i  | cut -d_ -f1)
    num=$(echo $chr| sed 's/chr//' )
    #echo -ne "$chr $num\n"
    echo "$PLINK --gen $i --sample sample --oxford-single-chr $num --make-bed --out $DIR/$i -hard-call-threshold 0.1"
done | xargs -n 12 -P 20 -i wrapper.sh {}


MergeDIR=Imputation2Plink.Merge
mkdir $MergeDIR

ls $DIR/*bed | sed 's/\.bed//' > $MergeDIR/merge_list

P1=$(head -1 $MergeDIR/merge_list)
sed -n '2,$'p $MergeDIR/merge_list | perl -nle'$f=$_; print join "\t", (map { $f.$_ } qw/.bed .bim .fam/);' > $MergeDIR/merge_list.txt
rm -rf $MergeDIR/merge_list

$PLINK --bfile $P1 --merge-list $MergeDIR/merge_list.txt --make-bed --out $MergeDIR/MergePlink --allow-no-sex --threads 15 

perl -F'\s' -anle'if(/^snp/){next}elsif($F[6]>=0.8){print $F[1]}' *info > $MergeDIR/info_scoreOver0.8.SNPID

$PLINK --bfile $MergeDIR/MergePlink --extract $MergeDIR/info_scoreOver0.8.SNPID --make-bed --out $MergeDIR/MergePlink.info_scoreOver0.8 --allow-no-sex --threads 5

else
	usage "Impute2_output_dir"
fi

