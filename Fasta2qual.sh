perl -nle'if($.%2==1){print}else{print join " ", ((34) x length($_))}' $1 > $1.qual


