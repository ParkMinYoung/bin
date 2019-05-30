#!/bin/bash

. ~/.bash_function

if [ -f "$1.bim" ] & [ -f "$2.bim" ];then


# excute time : 2017-03-09 15:57:39 : link
ln -s ../$1.* ./


# excute time : 2017-03-09 15:13:06 : bim 2 ChrPosGeno
Bim2ChrPosGeno.sh $2.bim 


# excute time : 2017-03-09 15:21:05 : compare
Bim2ChrPosGeno.Compare.sh $2.bim.Bim2ChrPosGeno $1.bim.Bim2ChrPosGeno 


# excute time : 2017-03-09 16:01:10 : get marker list will be flipped
grep "\-"$ $1.bim.Bim2ChrPosGeno.Compare | cut -f1 > $1.bim.Bim2ChrPosGeno.Compare.flip


# excute time : 2017-03-09 16:02:38 : flip the specific markers
plink2 --bfile $1 --flip $1.bim.Bim2ChrPosGeno.Compare.flip --make-bed --out $1.flip --allow-no-sex --threads 10 


# excute time : 2017-03-09 16:08:38 : get ID mapping info
egrep "(\-|\+)$" $1.bim.Bim2ChrPosGeno.Compare | cut -f1,4 > $1.bim.Bim2ChrPosGeno.Compare.AtoB


# excute time : 2017-03-09 16:09:09 : get ID A
cut -f 1 $1.bim.Bim2ChrPosGeno.Compare.AtoB > $1.bim.Bim2ChrPosGeno.Compare.AtoB.A


# excute time : 2017-03-09 16:09:21 : get ID B
cut -f 2 $1.bim.Bim2ChrPosGeno.Compare.AtoB > $1.bim.Bim2ChrPosGeno.Compare.AtoB.B


# excute time : 2017-03-09 16:14:47 : update marker names and extract specific markers : A
plink2 --bfile $1.flip --extract $1.bim.Bim2ChrPosGeno.Compare.AtoB.B --update-name $1.bim.Bim2ChrPosGeno.Compare.AtoB  --make-bed --out $1.A --allow-no-sex --threads 10


# excute time : 2017-03-09 16:16:45 : extract specific markers : B
 plink2 --bfile $2 --extract $1.bim.Bim2ChrPosGeno.Compare.AtoB.B  --make-bed --out $1.B --allow-no-sex --threads 10


# excute time : 2017-03-09 16:19:02 : merge A and B
plink2 --bfile $1.A --bmerge $1.B.{bed,bim,fam} --make-bed --out $1.AB --allow-no-sex --threads 10 


# excute time : 2017-03-09 16:20:03 : kinship
PlinkGenome.KinShip.Relation.sh $1.AB 


# excute time : 2017-03-09 16:24:51 : get pair
cut -d";" -f1 $ $1.AB.genome.tab.OrderedValueListFromKey |  awk '{print $1"\t"$3"\t"$1"\t"$3}' | grep -v ^FID > $1.pair


# excute time : 2017-03-09 16:33:15 : get blind test
 KOR.BlindTest.sh $1.pair $1.AB 


 else
 	usage "Target_plink DB_plink"
fi

