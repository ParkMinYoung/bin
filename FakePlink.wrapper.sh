


perl -F'\t' -anle'
BEGIN{
  @str2num{ qw/male female unknown/ } = (1,2,0);
}

print "FakePlink.sh $F[1] $F[7] $F[8] $str2num{$F[6]}" if $.>1
' ../CheckSampleList | xargs -n5 -P5 wrapper.sh  &


