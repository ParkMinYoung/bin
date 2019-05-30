perl -MMin -sne'
if($.%4==0){
	chomp;
	$l=length $_;
	$h{$l}{$ARGV}++;
	$h{Reads}{$ARGV}++;
	$h{Sequences}{$ARGV}+=$l
} 
}{ 
	mmfsn("read.length.dist",%h)
' -- -f=$1 $@
