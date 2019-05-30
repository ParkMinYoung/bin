        cat $1 | \
        perl -F'\t' -MList::MoreUtils=firstidx,all,pairwise,indexes,natatime  -MMin -asnle'
	print && next if /^#/;
        @l=split ":",$F[8];
        $in_DP=firstidx { $_ eq "DP" } @l;
        $in_GQ=firstidx { $_ eq "GQ" } @l;
        $in_GT=firstidx { $_ eq "GT" } @l;
        @data=@F[9..$#F];
        @depth=map{ ${[split ":", $_]}[$in_DP] } @data;
        @GQs=map{ ${[split ":", $_]}[$in_GQ] } @data;
        @GTs=map{ ${[split ":", $_]}[$in_GT] } @data;
        @test=pairwise { 1 if $a>=$depth && $b>=$gq } @depth, @GQs;
#       print "[@test]";
        $it = natatime 2, @test;
        @Ntest=();
    while (my @vals = $it->()){
           if($vals[0]+$vals[1] == 2){
           push @Ntest, 1;
           }else{ push @Ntest, 0 }
    }
    @index=indexes { $_ == 1 } @Ntest;

    if ( @index == @data/2 ){
		$it=natatime 2, @GTs;
		$f=0;
		while(@vals=$it->()){
			if($vals[0] ne $vals[1]){
				$f++;
			}
		}
	print if $f
    } ' -- -depth=10 -gq=50  > $1.Mismatch.vcf

