
(cd Variant && unzip call.zip)

perl -F'\t' -anle'
BEGIN{
$bam="Bam";
$var="Variant";
$fastq="Fastq";
$cwd=$ENV{PWD};

$analysis = "Analysis";
$BAM = "$analysis/BAM";
$VAR = "$analysis/VAR";
$FASTQ = "$analysis/FASTQ";

`mkdir -p $BAM` if ! -d $BAM;
`mkdir -p $VAR` if ! -d $VAR;
`mkdir -p $FASTQ` if ! -d $FASTQ;
}
#IonXpress_002_rawlib.realigned.bam
#IonXpress_009_rawlib_processed.bam
$abs_bam = "$cwd/$bam/$F[0]_rawlib_processed.bam";
$id_bam = "$F[1].bam";

print "ln $abs_bam $BAM/$id_bam";

$abs_bam = "$cwd/$bam/$F[0]_rawlib_processed.bam.bai";
$id_bam = "$F[1].bam.bai";
print "ln $abs_bam $BAM/$id_bam";

### add lin : cp rawlib.bam and bai 
$abs_bam = "$cwd/$bam/$F[0]_rawlib.bam";
$id_bam = "$F[1].rawlib.bam";

print "ln $abs_bam $BAM/$id_bam";

$abs_bam = "$cwd/$bam/$F[0]_rawlib.bam.bai";
$id_bam = "$F[1].rawlib.bam.bai";
print "ln $abs_bam $BAM/$id_bam";
###

`mkdir -p "$VAR/$F[1]"` if ! -d "$VAR/$F[1]";
print "cp -aru $var/$F[0]/TSVC_variants.vcf $VAR/$F[1].vcf";
print "cp -aru $var/$F[0]/* $VAR/$F[1]";

$abs_fastq = `ls $cwd/$fastq/$F[0]*.fastq`;
chomp $abs_fastq;
print "ln $abs_fastq $FASTQ/$F[1]_AAAAAA_L001_R1_001.fastq"

' mapping  | sh


####

 #[adminrig@node01 Auto_user_DL1-28-20130823-Amp.Customized.60genes.430k.set1_81_109]$ head mapping
 #IonXpress_001   snuh0003_N
 #IonXpress_002   snuh0010_N
 #IonXpress_003   snuh0003_T
 #IonXpress_004   snuh0010_T
 #IonXpress_005   snuh0012_N
 #IonXpress_006   snuh0018_N
 #IonXpress_007   snuh0019_N
 #IonXpress_008   snuh0021_N
 #IonXpress_009   snuh0024_N
 #IonXpress_010   snuh0029_N

