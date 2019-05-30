find -type f | grep png$ | perl -MFile::Basename -nle'($f,$d) =fileparse($_); $d=~s/^\.\///;$d=~s/\.IGV\///;$h{$d}++; }{ map { print "$_\t$h{$_}" } keys %h ' > png.count
wc -l *snp | awk '{print $2"\t"$1}' | grep -v ^total > tiers.snp.count
perl -F'\t' -anle'if(@ARGV){$h{$F[0]}=$F[1]}else{$diff=$F[1]-$h{$F[0]}; $F[0]=~/(snuh\d+)/; $id=$1; print join "\t", $id, @F, $h{$F[0]},$diff if $diff}' png.count tiers.snp.count > ReIGV.List
for i in `cut -f1 ReIGV.List `; do echo "SNU.BangYoungJoo.png.sh $i";done > ReIGV.List.sh
sh ReIGV.List.sh
find *bak.IGV -type f| grep png$ | perl -MFile::Basename -nle'($f,$d) = fileparse($_); $d=~ s/\.bak//; print "mv $_ $d"' | sh
rmdir *bak.IGV
ls | grep bak | xargs rm

