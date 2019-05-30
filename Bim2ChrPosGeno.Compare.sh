perl -F'\t' -anle'
if(@ARGV){
    $h{$F[1]}= $F[0];
}else{
	if(/^ID\t/){
	print join "\t", @F, qw/match_id match/;
	}elsif($h{$F[1]}){
        print join "\t", @F, $h{$F[1]}, "+";
    }elsif($h{$F[2]}){
        print join "\t", @F, $h{$F[2]}, "-";
    }else{
        print join "\t", @F, "No", "Fail";
    }
}' $1 $2 > $2.Compare

#AxiomGT1.calls.txt.extract.plink_fwd.gender.bim.Bim2ChrPosGeno step2.bim.Bim2ChrPosGeno > step2.bim.Bim2ChrPosGeno.out

