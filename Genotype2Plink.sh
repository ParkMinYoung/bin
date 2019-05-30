#!/bin/bash

. ~/.bash_function

if [ $# -eq 3 ];then

		## make map file
		awk '{print $2"\t"$1"\t"0"\t"$3}' $2  > $1.map

		## make fam file
		 awk '{print $1"\t"$1"\t"0"\t"0"\t"$2"\t"$3}' $3  > $1.fam

		Matrix2Flat.sh $1 | \
		perl -F'\t' -anle'$F[2]=~s/(FL|FAIL|NN|Nocall)/00/i; print join "\t", @F[0,0,1], (split "",$F[2])' > $1.lgen

		plink --lfile $1 --make-bed --out $1 --noweb

else

cat << EOF

============================================================

${RED}Marker_info format, marker information${NORM}
1. marker : rs_id 
2. chromosome
3. position


${RED}Sample_info format, sample information${NORM}
1. sample id
2. male(1)/female(2)
3. control(1)/case(2)

============================================================
EOF

		usage "GenotypeMatrix Marker_info Sample_info"

fi

# $2 format, marker information
# marker : rs_id 
# chromosome
# position


# $3 format, sample information
# sample id
# male(1)/female(2)
# control(1)/case(2)

