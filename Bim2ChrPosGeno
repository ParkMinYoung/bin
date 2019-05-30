perl -F'\t' -anle' 
print join "\t", qw/ID + -/ if $.==1;

$k1=join ":", $F[0], $F[3], sort(@F[4,5]);
$F[4]=~tr/ACGT/TGCA/;
$F[5]=~tr/ACGT/TGCA/;

$k2=join ":", $F[0], $F[3], sort(@F[4,5]);

print join "\t", $F[1], $k1, $k2;

' $1 > $1.Bim2ChrPosGeno


