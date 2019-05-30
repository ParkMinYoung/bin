
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/cytoBand.txt.gz
gunzip cytoBand.txt.gz

perl -F'\t' -anle'if(@ARGV){$h{"chr$F[0]"}=$F[1] }elsif(/cen/ && /p11/){  print join "\t", $F[0], 0, $F[2], "p"; print join "\t", $F[0], $F[2], $h{$F[0]}, "q" } ' /home/adminrig/src/GATK.2.0/resource.bundle/2.8/b37/human_g1k_v37.fasta.fai cytoBand.txt |  sed 's/chr//' > pgArm

