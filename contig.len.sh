# fasta_formatter -i contigs.fa -w 0 -o contigs.fa.new
# perl -MMin -nle'next if $.%2==1;$l=length $_; if($l>=1000){$h{">1000"}++}elsif($l>=500){$h{">500"}++}elsif($l<500 && $l>=100){$h{"<500"}++}elsif($l<100){$h{"<100"}++}; $h{Total}++ }{ h1c(%h)' $1 > $1.len

perl -MMin -nle'BEGIN{@h{qw/>1000 >500 <100 <500/}=(0,0,0,0)} 
if(/^>(.+)/){$id=$1}else{$len{$id}+=length($_)} 
}{ map { $l=$len{$_}; if($l>=1000){$h{">1000"}++}elsif($l>=500){$h{">500"}++}elsif($l<500 && $l>=100){$h{"<500"}++}elsif($l<100){$h{"<100"}++}; $h{Total}++ } keys %len; h1c(%h)' $1 > $1.len

