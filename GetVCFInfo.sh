#!/bin/sh

source ~/.bashrc


if [ -f "$1" ];then

perl -MMin -asne'
next if /^#/;
$id=join "\t",@F[0..6];
@data=split ";", $F[7];
map { ($key,$val)=split "=", $_; $h{$id}{$key}=$val} @data
}{ mmfss("$f.VCFInfo",%h)
' -- -f=$1 $1

else
	usage "xxx.vcf"
fi



# #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  DNALink.PE.90001867     DNALink.PE.90003324     DNALink.PE.90003693     DNALink.PE.90004044     DNALink.PE.90004262     DNALink.PE.90004283     DNALink.PE.90
# 1       69270   .       A       G       984.52  TruthSensitivityTranche99.90to100.00    AC=54;AF=1.000;AN=54;BaseQRankSum=-2.530;DP=15391;Dels=0.00;FS=0.000;HRun=0;HaplotypeScore=1.2041;InbreedingCoeff=-0.1919;MQ=3.72;MQ0=62977;M
# 1       69511   rs75062661      A       G       98332.37        TruthSensitivityTranche99.90to100.00    AC=240;AF=1.0000;AN=240;BaseQRankSum=7.953;DB;DP=19799;Dels=0.00;FS=5.714;HRun=0;HaplotypeScore=5.2345;InbreedingCoeff=-0.004
# 1       69534   .       T       C       856.47  StandardFilters AB=0.495;AC=1;AF=0.0042;AN=240;BaseQRankSum=-2.702;DP=20848;Dels=0.00;FS=0.000;HRun=0;HaplotypeScore=6.0350;InbreedingCoeff=-0.0042;MQ=31.46;MQ0=1979;MQRankSum=0.928
# 1       69610   .       C       T       4253.15 StandardFilters AB=0.655;AC=5;AF=0.0207;AN=242;BaseQRankSum=2.893;DP=28165;Dels=0.00;FS=1.208;HRun=2;HaplotypeScore=4.9537;InbreedingCoeff=0.7444;MQ=26.09;MQ0=13428;MQRankSum=-1.265
# 1       69655   .       G       A       162.22  StandardFilters AB=0.701;AC=1;AF=0.0042;AN=240;BaseQRankSum=0.735;DP=39672;Dels=0.00;FS=0.000;HRun=1;HaplotypeScore=2.1962;InbreedingCoeff=0.4187;MQ=10.69;MQ0=33667;MQRankSum=-0.647
# 1       69897   .       T       C       279.44  TruthSensitivityTranche99.90to100.00    AC=18;AF=1.000;AN=18;BaseQRankSum=-1.733;DP=5249;Dels=0.00;FS=26.660;HRun=1;HaplotypeScore=0.0876;MQ=1.31;MQ0=75525;MQRankSum=-0.433;QD=0.05;
