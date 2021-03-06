perl -F'\t' -MList::MoreUtils=firstidx -anle'
        next if /^#/;
        @l=split ":",$F[8];
        
		$in_GQ=firstidx { $_ eq "GQ" } @l;
        $in_GT=firstidx { $_ eq "GT" } @l;
        $in_AD=firstidx { $_ eq "AD" } @l;

		if ( $in_AD == -1 ){
				$in_AD=firstidx { $_ eq "DP" } @l;
		}

        @data=@F[9..$#F];
        @ADs=map{ ${[split ":", $_]}[$in_AD] } @data;
#        @depth=map{ ${[split ":", $_]}[$in_DP] } @data;
#        @GQs=map{ ${[split ":", $_]}[$in_GQ] } @data;
#        @GTs=map{ ${[split ":", $_]}[$in_GT] } @data;
		
#		print "$F[8]";
#		print "$in_AD : @ADs :  @data";
		@AA_count=();
		for $i ( @ADs ){
			if($i =~ /(\d+)(,(\d+))?/){
				$A=$1;
				$B=$3 || 0;

				push @AA_count,$A,$B;
			}else{
				push @AA_count,0,0;
			}
		}
			
        print join "\t", @F[0..4], @AA_count,
' $1


#4       1100037 rs35166968      TACAC   T       12570.90        PASS    AB=0.799;AC=10;AF=0.500;AN=20;BaseQRankSum=-2.306;DB;DP=3626;FS=1.920;HRun=0;HaplotypeScore=1459.8662;InbreedingCoeff=-1.0000;MQ=52.50;MQ0=6;MQRankSum=-2.813;QD=3.47;ReadPosRankSum=-0.567     GT:AD:DP:GQ:PL  0/1:289,20:256:99:834,0,4569    0/1:239,21:235:99:976,0,5055    0/1:228,39:232:99:1604,0,3615   0/1:232,38:233:99:1566,0,2923   0/1:320,26:286:99:1036,0,6263   0/1:260,16:237:99:854,0,3724    0/1:293,35:287:99:1824,0,4533   0/1:213,51:265:99:2278,0,3847   0/1:268,14:235:99:467,0,4634    0/1:269,30:281:99:1131,0,5440   
#4       1101612 rs4974642       C       G       122905.51       PASS    AC=20;AF=1.000;AN=20;BaseQRankSum=0.889;DB;DP=3942;Dels=0.00;FS=0.000;HRun=0;HaplotypeScore=9.0844;InbreedingCoeff=0.0000;MQ=59.76;MQ0=0;MQRankSum=-0.837;QD=31.18;ReadPosRankSum=-0.623        GT:AD:DP:GQ:PL  1/1:0,417:417:99:12780,972,0    1/1:0,397:398:99:12722,978,0    1/1:0,366:366:99:10040,807,0    1/1:0,329:331:99:10650,837,0    1/1:1,475:476:99:15137,1130,0   1/1:1,424:425:99:13677,1047,0   1/1:1,411:412:99:12874,988,0    1/1:0,311:312:99:10296,819,0    1/1:0,406:407:99:12721,984,0    1/1:0,396:397:99:11852,939,0   
