
DIR=$(dirname $1)

# --mind 0.1 (sample QC, equal than CR 90%)
# --maf 0.1 
# --geno 0.1 (marker QC, eaual than CR 90%)
# --hwe 0.001 (HWE QC)

plink2 --bfile $1 --not-chr 6,8 --mind 0.1 --maf 0.1 --geno 0.02 --hwe 0.001 --make-bed --out $DIR/QC --allow-no-sex --threads 10 
plink2 --bfile $DIR/QC --indep-pairwise 200 100 0.2 --out $DIR/extract --allow-no-sex  --threads 10
plink2 --bfile $DIR/QC --extract $DIR/extract.prune.in --make-bed --out $DIR/PCA.RemoveChr68 --allow-no-sex  --threads 10

PCA.pipeline.sh $DIR/PCA.RemoveChr68

# https://www.med.unc.edu/pgc/files/resources/visualization-tools/pca_ricopili
