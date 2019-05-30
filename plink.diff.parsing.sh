#!/bin/sh
. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

perl -F'\s+' -MList::MoreUtils=uniq -MMin -asne'
if($ARGV =~/diff$/){
next if $. == 1;
chomp@F;
#print join uniq(split "\/", "$F[3]/$F[4]");
@geno = uniq ( split "\/", "$F[4]/$F[5]" );

@A = uniq ( split "\/", $F[4] );
@B = uniq ( split "\/", $F[5] );

$first =  @A >1 ? "Het" : "Hom";
$second = @B >1 ? "Het" : "Hom";

$type = "$first vs $second";

$h{$F[2]}{ $type } ++;
$h{$F[2]}{ Discordant } ++;
$id=$F[2];

}else{
	if(/^Of (\d+) overlapping SNPs, (\d+) were both genotyped/){
		$h{$id}{overlapping} = $1;
		$h{$id}{BothGenotype} = $2;
		$both = $2;
	}elsif(/^and (\d+) were concordant/){
		$h{$id}{Concordant} = $1;
	}elsif(/^Concordance rate is (.+)/){
		$h{$id}{ConcordantPer} = $1;
	}	

}
}{mmfss("$f.count", %h);
' -- -f=$1 $1 $2

# -- -f=GPS00306.CHIP.geno.cleanup.concordance.diff GPS00306.CHIP.geno.cleanup.concordance.diff GPS00306.CHIP.geno.cleanup.concordance.log
perl -F'\s+' -anle'print join "\t", @F[1..$#F]' $1 > $1.tab 
else
	usage "[plink out --merge-mode 7] XXX.diff XXX.log"
fi


