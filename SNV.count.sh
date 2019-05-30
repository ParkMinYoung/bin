perl -F'\t' -MMin -ane'chomp@F;
if(/^#/){
        next
}else{
        $rl=length($F[3]);
        $al=length($F[4]);
        $h{$ARGV}{TOTAL}++;
        $h{ALL}{TOTAL}++;

        if($rl+$al==2){
          $h{$ARGV}{SNP}++;
          $h{ALL}{SNP}++ ;
        }elsif($rl>1){
          $h{$ARGV}{DEL}++;
          $h{ALL}{DEL}++ ;
        }else{
          $h{$ARGV}{INS}++;
          $h{ALL}{INS}++ ;
        }
}
}{ mmfss("SNV.count", %h)' $@

