#!/bin/sh

perl -F'\t' -anle'print if /^##/;
if(@F>=10){
if($F[4] eq "." ){
$F[4]=$F[3];
$F[8]="GT:PL:DP:GQ";
@data=@F[9..$#F];
@data=map { "0/0:$_:99" } @data;
print join "\t",@F[0..8],@data;
}else{print}
}' $1 
