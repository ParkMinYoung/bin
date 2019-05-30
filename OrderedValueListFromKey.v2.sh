#!/bin/sh

. ~/.bash_function

if [ -f "$4" ] && [ $# -eq 4 ]; then


KEY=$1
VALUE=$2
SCORE=$3
FILE=$4

perl -F'\t' -asnle'

#next if $.==1;

$k = $F[$key-1];
$v = $F[$val-1];
$s = $F[$score-1];

$h{$k}{$v}=$s;
$h{$v}{$k}=$s;

}{
	for $sam1 (keys %h){
		@sam2 = sort { $h{$sam1}{$b} <=> $h{$sam1}{$a} } keys %{$h{$sam1}};
		@values = map { "$_;$h{$sam1}{$_}" } @sam2;

		print join "\t", $sam1, @values+0, @values;
	}
' -- -key=$KEY -val=$VALUE -score=$SCORE $FILE > $FILE.OrderedValueListFromKey

#perl -nle'(@l) = $_ =~ /(Ax\w+.CEL?)/g; print join  "\t",  @l+0, sort (@l)' $FILE.OrderedValueListFromKey |sort | uniq  > $FILE.OrderedValueListFromKey.uniq
perl -nle'(@l) = $_ =~ /(Ax.+?CEL?)/g; print join  "\t",  @l+0, sort (@l)' $FILE.OrderedValueListFromKey | sort  | uniq  > $FILE.OrderedValueListFromKey.uniq

#./OrderedValueListFromKey.sh 2 1 8 Summary.txt
#merge.IBS.genome.tab.sort >merge.IBS.genome.tab.sort.relation

else
	usage "2 1 8 Summary.txt"
fi



 ## $1      FID1    Genomewide6.0_KAREII_KoBB2-6197_M.CEL
 ## $2      IID1    Genomewide6.0_KAREII_KoBB2-6197_M.CEL
 ## $3      FID2    Genomewide6.0_KAREII_KoBB0804-290_M.CEL
 ## $4      IID2    Genomewide6.0_KAREII_KoBB0804-290_M.CEL
 ## $5      RT      UN
 ## $6      EZ      NA
 ## $7      Z0      0.3169
 ## $8      Z1      0.6831
 ## $9      Z2      0.0000
 ## $10     PI_HAT  0.3415
 ## $11     PHE     -1
 ## $12     DST     0.684200
 ## $13     PPC     1.0000
 ## $14     RATIO   8.5714

##$1      probeset_id                             Axiom_KORV1_005001_A01_ADHD-AMC-0001S.CEL
##$2      id                                      ADHD-AMC-0001S
##$3      set                                     DL005001
##$4      well                                    A01
##$5      axiom_dishqc_DQC                        0.84513
##$6      apt_geno_qc_gender                      female
##$7      apt_probeset_genotype_gender            female
##$8      call_rate                               35.42280
##$9      het_rate                                9.99155
##$10     cn-probe-chrXY-ratio_gender_meanX       723.07068
##$11     cn-probe-chrXY-ratio_gender_meanY       323.20267
##$12     cn-probe-chrXY-ratio_gender_ratio       0.44699
##
##
