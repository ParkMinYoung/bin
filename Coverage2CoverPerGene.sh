

perl -F'\t' -MMin -asne'

for ( split ";", $F[3] ){
	$h{$_}{Total} += $F[6];
	$h{$_}{Exp} +=   $F[5];
	$h{$_}{Cov} = $h{$_}{Exp}/$h{$_}{Total}*100;
}
}{ mmfss("$f.CovPerGene", %h)
' -- -f=$1 $1



 ## 2       234675679       234675811       UGT1A6;UGT1A1;UGT1A10;UGT1A8;UGT1A7;UGT1A9;UGT1A5;UGT1A4;UGT1A3 1       132     132     1.0000000
 ## 2       234676494       234676582       UGT1A10;UGT1A8;UGT1A7;UGT1A5;UGT1A4;UGT1A6;UGT1A9;UGT1A3;UGT1A1 1       88      88      1.0000000
 ## 2       234676865       234677085       UGT1A5;UGT1A3;UGT1A4;UGT1A7;UGT1A1;UGT1A9;UGT1A8;UGT1A6;UGT1A10 1       220     220     1.0000000
 ## 2       234680907       234681205       UGT1A4;UGT1A6;UGT1A10;UGT1A8;UGT1A7;UGT1A5;UGT1A1;UGT1A3;UGT1A9 1       298     298     1.0000000
 ## 20      33516630        33516754        GSS     1       124     124     1.0000000
 ## 20      33517203        33517393        GSS     1       190     190     1.0000000
 ## 20      33519138        33519220        GSS     1       82      82      1.0000000
 ## 20      33519741        33519936        GSS     1       195     195     1.0000000
 ## 20      33523378        33523445        GSS     1       67      67      1.0000000
 ## 20      33524565        33524643        GSS     1       78      78      1.0000000
 ## 20      33524745        33524826        GSS     1       81      81      1.0000000
 ## 20      33529515        33529632        GSS     1       117     117     1.0000000
 ## 20      33530290        33530430        GSS     1       140     140     1.0000000
 ## 20      33530733        33530809        GSS     1       76      76      1.0000000
 ## 20      33533755        33533901        GSS     1       146     146     1.0000000
 ## 20      33539526        33539655        GSS     1       129     129     1.0000000
 ## 20      42984444        42984493        HNF4A   1       49      49      1.0000000
 ## 20      43030012        43030127        HNF4A   1       115     115     1.0000000
 ## 20      43031193        43031284        HNF4A   1       91      91      1.0000000
 ## 20      43034697        43034872        HNF4A   1       175     175     1.0000000
 ## 20      43036020        43036115        HNF4A   1       95      95      1.0000000
 ## 20      43042333        43042440        HNF4A   1       107     107     1.0000000