perl -F'\t' -MList::MoreUtils=firstidx -anle'
        next if /^#/;
        @l=split ":",$F[8];
        $in_DP=firstidx { $_ eq "DP" } @l;
        $in_GQ=firstidx { $_ eq "GQ" } @l;
        $in_GT=firstidx { $_ eq "GT" } @l;
        @data=@F[9..$#F];
        @depth=map{ ${[split ":", $_]}[$in_DP] } @data;
        @GQs=map{ ${[split ":", $_]}[$in_GQ] } @data;
        @GTs=map{ ${[split ":", $_]}[$in_GT] } @data;
        print join "\t", @F[0,1,3,4],@GTs,@depth,@GQs,
' $1
