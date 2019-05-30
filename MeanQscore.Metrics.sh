#!/bin/bash
. ~/.bash_function
# . ~/.perl
#. ~/.perl.min
if [ -f "$1" ] & [ -f "$2" ];then

#paste <(zcat exp6_Idx_12_CTTGTA_L001_R1_001.fastq.gz | head -10000) <(zcat exp6_Idx_12_CTTGTA_L001_R2_001.fastq.gz| head -10000) | sed -n '4~4p' | \
#paste <(zcat $1 | head -10000) <(zcat $2 | head -10000) | sed -n '4~4p' | \
paste <(zcat $1) <(zcat $2) | sed -n '4~4p' | \
perl -F'\t' -MMin -asne'
chomp@F;
$num++;

$read = "$F[0]$F[1]";

@score = map { $_ - 33 } unpack "C*", $read ; 

$r= sum( @score ); 
$mean_Q= int( $r/length($read) ); 

## read count
$h{$mean_Q}{Count}++;
$h{Total}{Count}++;

## score store by Mean QScore 
map { $s{$mean_Q}{$_}++ } @score;

## line by Mean QScore
push @{ $line{$mean_Q} }, $num;


}{

@mean_Qs = grep {/\d+/ } sort {$a <=> $b} keys %h;
#print join ",","Meam QScore list :", @mean_Qs;

for $mean_Q ( @mean_Qs ){
	map { $qscore{$_}++ } sort {$a <=> $b} keys %{ $s{$mean_Q} };
}

@qscore = sort {$a<=>$b} keys %qscore;

for $mean_Q ( @mean_Qs ){
	$h{$mean_Q}{Percent} = sprintf "%0.2f", $h{$mean_Q}{Count} / $h{Total}{Count} * 100 ;

	($total, $Q20, $Q30, $qscore_sum) = ();

#print join "\t", ">>$mean_Q .. $mean_Qs[-1]", (join ",", @qscore), "\n";
#print join "\t", ">>$mean_Q .. $mean_Qs[-1]",(join ",", 20..$qscore[-1]), "\n";
	for $Qscore ( $mean_Q .. $mean_Qs[-1] ){

		$ref = $s{$Qscore};
		map { $qscore_sum += $ref->{$_} * $_ } @qscore;
		$total += sum( @{$ref}{@qscore} );
		$Q20 += sum( @{$ref}{20..$qscore[-1]} );
		$Q30 += sum( @{$ref}{30..$qscore[-1]} );
	}

#print join "\t",$mean_Q, (join ",",@qscore),"\n";
#print join "\t", $mean_Q, $total, $Q20, $Q30, "\n";
	$h{$mean_Q}{Q20} = $Q20 == 0 ? 0 : sprintf "%0.2f", $Q20/$total*100;
	$h{$mean_Q}{Q30} = $Q30 == 0 ? 0 : sprintf "%0.2f", $Q30/$total*100;
	$h{$mean_Q}{QNumOfTotalBases} = $total;
	$h{$mean_Q}{QNumOfQ20Bases} = $Q20;
	$h{$mean_Q}{QNumOfQ30Bases} = $Q30;
	$h{$mean_Q}{MeanQualityScore} = sprintf "%0.2f", $qscore_sum / $total ;
}

map { print join "\t", $_, (join ",", @{ $line{$_} }), "\n" } sort {$a<=>$b} keys %line;

mmfsn("$out.MeanQscore.Metrics", %h)' -- -out=$1 > $1.LinePerQScore.txt

else
	usage "xxx.R1.fastq.gz xxx.R2.fastq.gz"
fi

