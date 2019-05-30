cd $KNIH1

AffyChipSummary.txt.sh

# create Summary.txt.xlsx
$TAB2XLSX Summary.txt

## Match
perl -F'\t' -anle'
BEGIN{
$sex{F}="female";
$sex{M}="male"
}
$gender=$F[6];
if(@ARGV){
    $h{$F[0]}=$sex{$F[3]}
}else{
    if(/probeset_id/){
        print "$_\tgender\tgender_match" ;
    }elsif( $h{$F[1]} ){
        $match ="3";
                if( $gender eq "unknown" ){
                $match = 4;
                }elsif( $gender eq $h{$F[1]} ){
                    $match = 1;
                }elsif( $gender ne $h{$F[1]} ){
            $match = 2;
                }
        print "$_\t$h{$F[1]}\t$match" ;
    }
}' ClinicalInfo Summary.txt  > Summary.Gender.txt


\mv -f Summary* AnalysisResult/


