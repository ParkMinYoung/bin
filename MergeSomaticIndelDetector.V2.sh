perl -F'\t' -MFile::Basename -anle'
next if /^(#|CHROM)/;

($f,$dir)=fileparse($ARGV);
$dir =~ s/\/$//;

if($F[7] eq "SOMATIC"){
	
	$ref=$F[3];
	$alt=$F[4];
	$ref_len = length($F[3]);
	$alt_len = length($F[4]);

# deletion
	if ( $ref_len > $alt_len){
		$s = $F[1] + $alt_len;
		$e = $s + ($ref_len - $alt_len) - 1;
		$ref =~ s/^$alt//;
		($r,$a) = ($ref, "-");
#print $_;
#print join "\t", $s, $e, $ref, $alt, $r, $a;
		
# insertion
	}elsif( $ref_len < $alt_len ){
		$s = $F[1];
		$e = $s;
		$alt =~s/^$ref//;
		($r,$a) = ("-", $alt);

# indel substitution
	}elsif( $ref_len == $alt_len ){
		$s = $F[1];
		$e = $s + $ref_len -1;
		($r,$a) = ($ref, $alt);
	}

$chr=$F[0];
$geno = "$r/$a";
$strand = "+";

$key = join "\t", $chr, $s, $e, $geno, $strand;

@normal = split ":", $F[9];
@tumor  = split ":", $F[10];

@normal_base = split ",", $normal[9];
$normal_indel = $normal_base[0] + $normal_base[1];
$normal_ref   = $normal_base[2] + $normal_base[3];

@tumor_base  = split ",", $tumor[9];
$tumor_indel = $tumor_base[0] + $tumor_base[1];
$tumor_ref   = $tumor_base[2] + $tumor_base[3];

$count = join "\|", $normal_ref, $normal_indel, $tumor_ref, $tumor_indel;

$g{"0/0"} = "$r/$r";
$g{"0/1"} = "$r/$a";
$g{"1/1"} = "$a/$a";

$normal_genotype = $g{$normal[0]};
$tumor_genotype = $g{$tumor[0]};
$genotype = join "\|", $normal_genotype, $tumor_genotype;

push @{$h{$key}{sample}}, $dir;
push @{$h{$key}{count}}, $count ;
push @{$h{$key}{geno}}, $genotype;
}

}{
	map { print join "\t", $_, 
			@{$h{$_}{sample}}+0,
			(join ",", @{$h{$_}{sample}}),
			(join ",", @{$h{$_}{count}}),
			(join ",", @{$h{$_}{geno}})  
		} sort keys %h;


' $@ > MergeSomaticIndelDetector.input 

## #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  NORMAL  TUMOR
## 1       1900024 .       TG      T       .       .       .       GT:AD:DP:MM:MQS:NQSBQ:NQSMM:REnd:RStart:SC      0/1:6,6:16:1.8333334,3.3:34.666668,31.0:37.25,34.539326:0.0,0.07865169:17,9:59,9:6,0,1
## 1       1920434 .       TA      T       .       .       .       GT:AD:DP:MM:MQS:NQSBQ:NQSMM:REnd:RStart:SC      0/1:2,2:15:1.5,2.0769231:37.0,35.153847:20.35,22.181818:0.05,0.08181818:59,1:16,1:0,2,
## 1       3544235 .       TA      T       .       .       .       GT:AD:DP:MM:MQS:NQSBQ:NQSMM:REnd:RStart:SC      0/1:9,9:20:1.0,1.0:39.22222,35.909092:40.402298,36.342857:0.011494253,0.03809524:22,18
## 1       6170424 .       CG      C       .       .       .       GT:AD:DP:MM:MQS:NQSBQ:NQSMM:REnd:RStart:SC      0/1:6,6:13:2.5,2.4285715:38.333332,33.57143:39.814816,29.272728:0.037037037,0.06060606
## 1       6609792 .       G       GT      .       .       SOMATIC GT:AD:DP:MM:MQS:NQSBQ:NQSMM:REnd:RStart:SC      0/0:0,0:33:0.0,1.6363636:0.0,35.909092:0.0,43.057926:0.0,0.018292682:0,0:0,0:0,0,6,27 
## 1       7863735 .       CTTA    C       .       .       .       GT:AD:DP:MM:MQS:NQSBQ:NQSMM:REnd:RStart:SC      0/1:5,5:20:0.6,2.1333334:38.6,33.0:37.104168,36.12857:0.020833334,0.014285714:52,21:24
## 

 ## 
 ## 1       100152443       100152443       T/C     +       3       S2,S3,S4        24|9|4|17,54|0|17|9,40|0|1|34   Y|C,T|Y,T|C
 ## 1       100164000       100164000       A/G     +       2       S3,S4   24|0|0|23,37|0|0|22     A|G,A|G
 ## 1       100182884       100182884       C/T     +       2       S1,S4   9|16|0|26,0|24|28|0     Y|T,T|C
 ## 1       100185282       100185282       G/T     +       2       S1,S4   6|7|0|11,0|16|17|0      K|T,T|G
 ## 1       100194305       100194305       C/G     +       2       S1,S4   5|9|0|26,0|22|13|0      S|G,G|C
 ## 1       100203597       100203597       G/A     +       1       S4      8|5|24|0        R|G
 ## 1       100203648       100203648       C/T     +       1       S4      12|14|32|0      Y|C
 ## 1       100203693       100203693       G/A     +       1       S4      15|5|33|0       R|G
 ## 1       100206665       100206665       G/C     +       1       S4      6|4|10|0        S|G
 ## 1       100213115       100213115       T/C     +       1       S4      13|10|19|0      Y|T

