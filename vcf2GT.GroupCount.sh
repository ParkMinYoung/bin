perl -F'\t' -MList::MoreUtils=firstidx -anle'
if(@ARGV){
	$h{$F[0]}=$F[1];
	$group{$F[1]}++;
}else{
        next if /^##/;
		if(/^#CHR/){

				($A,$B) = sort keys %group;
				print STDERR "$A\t: $group{$A}";
				print STDERR "$B\t: $group{$B}";

				@head=@F;
				print join "\t", @F[0..4], "$A.0/0", "$A.1/0", "$A.1/1", "$A../.", "$B.0/0", "$B.1/0", "$B.1/1", "$B../.";
		}else{

        @l=split ":",$F[8];
        $in_DP=firstidx { $_ eq "DP" } @l;
        $in_GQ=firstidx { $_ eq "GQ" } @l;
        $in_GT=firstidx { $_ eq "GT" } @l;
        @data=@F[9..$#F];
#@depth=map{ ${[split ":", $_]}[$in_DP] } @data;
#@GQs=map{ ${[split ":", $_]}[$in_GQ] } @data;

		%count = ();

		for ( 9 .. $#F ){
				$gt = ${[split ":", $F[$_]]}[$in_GT];
				$group = $h{$head[$_]};
				$count{$group}{$gt}++;
#print "$group\t$gt\t$head[$_]";
		}
#exit;
		$GT=join "\t", @F[0..4], 
								$count{$A}{"0/0"},
								$count{$A}{"1/0"},
								$count{$A}{"1/1"},
								$count{$A}{"./."},
								$count{$B}{"0/0"},
								$count{$B}{"1/0"},
								$count{$B}{"1/1"},
								$count{$B}{"./."},
print $GT;
		}
}
' $1 $2

# 
# 1       9323910 rs6688832       G       A       286287.27       PASS    AB=0.512;AC=273;AF=0.4840;AN=564;BaseQRankSum=55.118;DB;DP=20744;Dels=0.00;FS=22.752;HRun=0;HaplotypeScore=3.0037;Inbree
# 1       108185301       rs12403266      C       G       139643.09       PASS    AB=0.527;AC=153;AF=0.2713;AN=564;BaseQRankSum=-0.250;DB;DP=18957;Dels=0.00;FS=13.277;HRun=1;HaplotypeScore=3.293
# 1       151820324       rs6587625       T       C       238512  PASS    AB=0.528;AC=340;AF=0.6028;AN=564;BaseQRankSum=45.100;DB;DP=14112;Dels=0.00;FS=4.047;HRun=2;HaplotypeScore=1.9508;Inbreed
# 1       226019633       rs1051740       T       C       194824.07       PASS    AB=0.506;AC=240;AF=0.4255;AN=564;BaseQRankSum=24.533;DB;DP=19545;Dels=0.00;FS=1.731;HRun=0;HaplotypeScore=3.0292
# 3       186570892       rs2241766       T       G       107652  PASS    AB=0.521;AC=167;AF=0.2961;AN=564;BaseQRankSum=40.473;DB;DP=13091;Dels=0.00;FS=0.000;HRun=2;HaplotypeScore=1.7422;Inbreed
# 5       13719089        rs30168 G       A       144262.39       PASS    AB=0.526;AC=203;AF=0.3599;AN=564;BaseQRankSum=-19.718;DB;DP=16739;Dels=0.00;FS=59.952;HRun=1;HaplotypeScore=1.9101;Inbre
# 5       148206440       rs1042713       G       A       186716.72       PASS    AB=0.500;AC=328;AF=0.5816;AN=564;BaseQRankSum=-20.942;DB;DP=12198;Dels=0.00;FS=9.170;HRun=0;HaplotypeScore=1.672
# 6       31777946        rs2075800       C       T       233227.21       PASS    AB=0.523;AC=240;AF=0.4255;AN=564;BaseQRankSum=-47.304;DB;DP=19156;Dels=0.00;FS=6.316;HRun=1;HaplotypeScore=2.380
# 7       87138645        rs1045642       A       G       236316.53       PASS    AB=0.529;AC=342;AF=0.6064;AN=564;BaseQRankSum=-49.732;DB;DP=21233;Dels=0.00;FS=20.345;HRun=0;HaplotypeScore=2.36
# 7       94937446        rs662   T       C       214868.48       PASS    AB=0.488;AC=361;AF=0.6401;AN=564;BaseQRankSum=-26.394;DB;DP=15948;Dels=0.00;FS=0.000;HRun=0;HaplotypeScore=2.1821;Inbree
# 10      96541616        rs4244285       G       A       172937.71       PASS    AB=0.522;AC=172;AF=0.3050;AN=564;BaseQRankSum=50.463;DB;DP=19670;Dels=0.00;FS=48.592;HRun=0;HaplotypeScore=2.648
# 11      34482908        rs769217        C       T       254584.03       PASS    AB=0.524;AC=231;AF=0.4096;AN=564;BaseQRankSum=51.953;DB;DP=22303;Dels=0.00;FS=9.338;HRun=0;HaplotypeScore=3.1314
# 14      20872881        rs1760898       G       T       117815.04       PASS    AB=0.501;AC=210;AF=0.3723;AN=564;BaseQRankSum=6.195;DB;DP=10033;Dels=0.00;FS=0.701;HRun=2;HaplotypeScore=1.4629;
