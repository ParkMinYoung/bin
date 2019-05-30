#!/bin/sh

source ~/.bashrc

if [ -f "$1" ];then

perl -F'\t' -MMin -MPDL -asne'
BEGIN{ 
	$total = "01.Total"; 
	@key = qw/qual AB AC AF AN BaseQRankSum DP Dels FS HRun HaplotypeScore InbreedingCoeff MQ MQ0 MQRankSum QD ReadPosRankSum SB VQSLOD/;
}

chomp@F;
if($.==1){
	@header=@F;
	shift @header;
	unshift @header,"chr","bp","rs","ref","alt","qual","filter";
	@header{@key}=(1)x@key;
	map { push @idx, $_ if $header{$header[$_]} } 0 .. $#header;
#print "@idx";
#exit;

}else{
	$var_type = length($F[3].$F[4]) == 2 ? "SNP" : "INDEL";
	$db_type  = $F[2] eq "." ? "Novel" : "dbSNP";
#print "$var_type : $db_type";
	
	$type = "$var_type $db_type";
	$var_count{$F[6]}{$type}++;
	$var_count{$total}{$type}++;
	$var_count{$F[6]}{$total}++;
	$var_count{$total}{$total}++;

	map { push @{$m{$header[$_]}{$F[6]}}, $F[$_] } @idx;
	
#map { print "$_ $header[$_] $F[$_]\n" } @idx;
#exit;
}
}{ mmfss("$file.VarCount",%var_count);

for $title ( sort keys %m ){
	for $filter ( sort keys %{$m{$title}} ){
		@list = @{$m{$title}{$filter}};
		$piddle = pdl @list;
		($mean,$prms,$median,$min,$max,$adev,$rms) = statsover $piddle;
		$mean = sprintf "%0.2f", $mean;
		$Mean{$filter}{$title}=$mean;
	}
}

mmfss("VCF.HeaderMeans",%Mean);

' -- -file=$1 $1


else
	usage "XXX.vcf.VCFInfo.txt(output from GetVCFInfo.sh)"
fi


####                $piddle = pdl @list;
####                ($mean,$prms,$median,$min,$max,$adev,$rms) = statsover $piddle;
####                $mean = sprintf "%0.2f", $mean;
####                $adev = sprintf "%0.2f", $adev;
####
####                print join "\t", $target,$total_depth,$avg_depth,$mean,$adev,@list;
####        }




# 4       AN      C
# 5       BaseQRankSum    15113.45
# 6       DB      PASS
# 7       DP      0.444
# 8       Dels    18
# 9       FS      0.600
# 10      HRun    30
# 11      HaplotypeScore  6.002
# 12      InbreedingCoeff 0
# 13      MQ      645
# 14      MQ0     0.00
# 15      MQRankSum       3.505
# 16      QD      0
# 17      ReadPosRankSum  1.2693
# 18      SB      -0.6667
# 19      VQSLOD  59.74
# 20      culprit 0
# 21      0.934   0.934
# 22      23.40   23.40
# 23      -0.769  -0.769
# 24      -6385.23        -6385.23
# 25      7.7494  7.7494
# 26      MQ      MQ

