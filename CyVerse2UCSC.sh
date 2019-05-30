perl -F'\t' -anle'
$color="255,0,0";
$altColor="255,0,0";

if($F[1]=~/(.+)\.bam.bedgraph.bw$/){

$type="bigWig";
$name="$1";
$desc="$name depth";
$full_url_bw=$F[2];

print join " ", "track",
	            "type=$type",
				"name=\"$name\"",
				"description=\"$desc\"",
				"color=$color",
				"altColor=$altColor",
				"bigDataUrl=$full_url_bw",
				"yLineMark=200",
				"yLineOnOff=on",;

}elsif($F[1]=~/(.+)\.bam$/){

$type="bam";
$name="$1";
$desc="$name depth";
$full_url_bam=$F[2];
$db="mm10";
$etc="pairEndsByName=. pairSearchRange=20000 bamColorMode=strand bamGrayMode=aliQual bamColorTag=YC minAliQual=10 visibility=dense priority=100 db=$db maxWindowToDraw=200000";


print join " ", "track",
	            "type=$type",
				"name=\"$name\"",
				"description=\"$desc\"",
				"bigDataUrl=$full_url_bam",
				"$etc";
}
' $1 > $1.UCSC.url 

# Samsung1-DHA_TGACCA_L007_R1_001.fastq.gz.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bai
