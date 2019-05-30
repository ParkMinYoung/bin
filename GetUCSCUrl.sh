perl -MFile::Basename -le'
$type="bigWig";
$color="255,0,0";
$altColor="255,0,0";
$server="http://211.174.205.50";
$folder="XXX";

($f,$d)=fileparse($ARGV[0]);
$f=~/(.+)\.fastq/;
$name="$1";
$desc="$name depth";
$file_bw="$f.bedgraph.bw";
$full_url_bw="$server/$folder/$file_bw";

print join " ", "track",
	            "type=$type",
				"name=\"$name\"",
				"description=\"$desc\"",
				"color=$color",
				"altColor=$altColor",
				"bigDataUrl=$full_url_bw",
				"yLineMark=200",
				"yLineOnOff=on",;

$type="bam";
$file_bam=$f;
$full_url_bam="$server/$folder/$file_bam";
$db="hg19";
$etc="pairEndsByName=. pairSearchRange=20000 bamColorMode=strand bamGrayMode=aliQual bamColorTag=YC minAliQual=10 visibility=dense priority=100 db=$db maxWindowToDraw=200000";


print join " ", "track",
	            "type=$type",
				"name=\"$name\"",
				"description=\"$desc\"",
				"bigDataUrl=$full_url_bam",
				"$etc",;
' $1 > $1.UCSC.url

# Samsung1-DHA_TGACCA_L007_R1_001.fastq.gz.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bai
