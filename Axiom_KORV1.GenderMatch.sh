
ln -s ../../AnalysisResult/Summary.txt ./

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

TAB2XLSX.sh Summary.Gender.txt


cut -f1,2 Summary.Gender.txt > Sample


cut -f14 Summary.Gender.txt | sort | uniq -c


#comm <(cut -f1 Summary.Gender.txt ) <(cut -f1 Summary.txt) | cut -f2 | sort | less

##[adminrig@node01 Axiom_KORV1.0_GSK]$ head ClinicalInfo 
##ID      Type    Clinical_Gender_string  Clinical_Gender
##B-0001  case    female  F
##B-0002  case    male    M
##B-0003  case    male    M
##B-0004  case    male    M
##B-0005  case    male    M
##B-0006  case    male    M
##B-0007  case    male    M
##B-0008  case    male    M
##B-0009  case    female  F

# R CMD BATCH --no-save --no-restore GenderMatch.R
# ln -s ~/workspace.min/AFFX/untested_library_files/Axiom_KORV1.0_GSK/Summary.Gender.txt Summary.Gender.txt
 R CMD BATCH --no-save --no-restore ~/src/short_read_assembly/bin/R/GenderMatch.R
 R CMD BATCH --no-save --no-restore ~/src/short_read_assembly/bin/R/GenderMatchWell.R

. ../../config
\cp -f Summary.Gender.txt.xlsx *.png $COLLECT_HOME
