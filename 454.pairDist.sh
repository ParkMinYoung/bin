grep pairDistanceAvg -C 3 $1 | perl -MMin -ne'if(/\w+.sff/){$f=$&}elsif(/(\w+) = (.+);/){$h{$f}{$1}=$2} }{ mmfss("454.pairDist",%h)'

