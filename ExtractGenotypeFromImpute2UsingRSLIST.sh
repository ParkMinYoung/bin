RSLIST=rslist
IMPUTE2_OUTPUT=/home/adminrig/Genome/1000Genomes/20130502/ChoSunUniv.2015/imputation/
PLINK=/home/adminrig/src/PLINK/plink-1.09-x86_64/plink



## extract info using $RSLIST
ExtractImputationInfoFromRslist.sh $RSLIST $IMPUTE2_OUTPUT

## extract gen using $RSLIST
for i in ../*gz;
	do echo "ExtractImputationGen.gzFromRslist.sh $RSLIST $i"
done | xargs -n 3 -P 20 -i wrapper.sh {}


## merge by chromosome
ls impute2genotype.tmp/chr*tmp | sort |  perl -nle'/(chr\w+?)_/; push @{$h{$1}}, $_ }{ map { print "cat @{$h{$_}} | gzip -c >  impute2genotype.tmp/$_.gen.gz" } keys %h ' | sh
rm -rf impute2genotype.tmp/chr*tmp

ln -s $IMPUTE2_OUTPUT/../shapeit.1kg.phase3/chr10_phased.sample impute2genotype.tmp/sample


DIR=impute2genotype.tmp/plink

if [ ! -d "$DIR" ];then
    mkdir $DIR
fi



for i in impute2genotype.tmp/*.info.txt;     
    do     
    chr=$(echo $i | xargs -i basename {} .info.txt);     
    num=$(echo $chr| sed 's/chr//' );      
    gen=$(echo $i | sed 's/info.txt/gen.gz/');      
    echo "$PLINK --gen $gen --sample impute2genotype.tmp/sample --oxford-single-chr $num --make-bed --out $DIR/$chr -hard-call-threshold 0.1"; 
done  | xargs -n 12 -P 20 -i wrapper.sh {}



# plink merge 
PlinkMerge=impute2genotype.tmp/plinkMerge
mkdir $PlinkMerge

ls $DIR/*bed | sed 's/\.bed//' > $PlinkMerge/merge_list

P1=$(head -1 $PlinkMerge/merge_list)
sed -n '2,$'p $PlinkMerge/merge_list | perl -nle'$f=$_; print join "\t", (map { $f.$_ } qw/.bed .bim .fam/);' > $PlinkMerge/merge_list.txt
rm -rf $PlinkMerge/merge_list

plink --bfile $P1 --merge-list $PlinkMerge/merge_list.txt --make-bed --out $PlinkMerge/MergePlink --noweb


## convert plink to genotype
plink2genotype.sh impute2genotype.tmp/plinkMerge/MergePlink.bed

