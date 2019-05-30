perl -F'\t' -anle'
($chr,$bp,$rs)=split ":", $F[0];
next if !/chr/;
$chr=~s/chr//;
print join "\t", $chr,$bp-1,$bp,$rs;
' $1 | \
intersectBed -a stdin -b ~/Genome/dbSNP/dbSNP135/snp135.txt.bed -wao -f 1 -r  > $1.dbSNP135.detail

perl -F'\t' -anle'
if(@ARGV){
	if($F[3] eq "."){
		$k="chr$F[0]:$F[2]:$F[3]";
		if($F[7]=~/(rs\d+);/){
			$h{$k}="chr$F[0]:$F[2]:".$1;
		}else{
			$h{$k}="chr$F[0]:$F[2]:$F[3]";
		}
	}
}else{
	if($F[0]=~/\.$/){
		$F[0]=$h{$F[0]};
		print join "\t", @F;
	}else{
		print
	}

}' $1.dbSNP135.detail $1 > $1.dbSNP135


