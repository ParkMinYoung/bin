/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $1 --maf 0.1 --geno 1 --hwe 0.001 --genome --min 0.8 --out $1 --allow-no-sex --threads 80
PlinkOut2Tab.sh $1.genome
OrderedValueListFromKey.v2.sh 3 1 10 $1.genome.tab
