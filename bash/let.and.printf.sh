#! /bin/bash

let arg1=12
let arg2=11

let add=$arg1+$arg2
let sub=$arg1-$arg2
let mul=$arg1*$arg2
let div=$arg1/$arg2
echo $add $sub $mul $div
# 23 1 132 1

printf "Addition=%d\nSubtraction=%d\nMultiplication=%d\nDivision=%f\n" $add $sub $mul $div
# Addition=23
# Subtraction=1
# Multiplication=132
# Division=1.000000
