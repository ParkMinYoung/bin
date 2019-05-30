echo $1 | perl -nle'
BEGIN{
    @hex2num{0..9}=0..9;
    @hex2num{qw/A B C D E F/}=10..15;
    @hex2num{qw/a b c d e f /}=10..15;
}
print;
@l =reverse(split //, $_);
print "in : @l";
map { print "$l[$_] ($hex2num{$l[$_]}) * 16 **  $_";  $sum+=$hex2num{$l[$_]}*16**$_ } 0 .. $#l;

print "Hex Num $_ to Dex Num $sum";

print "easy function hex($_) : ", hex($_);
' 

