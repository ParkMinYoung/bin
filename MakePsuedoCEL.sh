grep _012045 AnalysisResult/Summary.txt | cut -f1 | head -93 > cellist.tmp
perl -nle'$c=$_; s/_012045/_012047/; $num = "XXXXXXXX".sprintf("%02s", ++$cnt); s/NIH\d{10}/NIH$num/;  print "$c\t$_" ' cellist.tmp > cellist.tmp.pseudo
perl -F'\t' -anle'print "ln $F[0] $F[1]"' cellist.tmp.pseudo | sh 

# printf '<%06s>', 12;
# printf '<%010s>', 12;

