
#excute time : 2017-05-18 14:39:07 : make bed
#perl -F'\t' -anle'$col=join ";", @F[3..$#F]; print join "\t", @F[0..2],$col' /home/adminrig/workspace.min/SKKU_YoonHwansoo.GP_Gracilariopsis_chorda/Gracilariopsis_chorda/Gracilariopsis_chorda_TGACCA_L002_R1_001_bismark_bt2_pe.deduplicated.bismark.cov > Gracilariopsis_chorda_TGACCA_L002_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.bed 



#java -jar /home/adminrig/src/SNPEFF/snpEff_4_3/snpEff.jar eff -i bed -config /home/adminrig/src/SNPEFF/snpEff_4_3/snpEff.config Gracilariopsis_chorda.v2 Gracilariopsis_chorda_TGACCA_L002_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.bed > Gracilariopsis_chorda_TGACCA_L002_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.snpeff

# excute time : 2017-05-18 14:51:17 : snpeff to tab
#SNPEFF.MethylSeq2Tab.v4.1.sh  Gracilariopsis_chorda_TGACCA_L002_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.snpeff


# excute time : 2017-05-18 15:23:19 : make txt
#cut -f1-12  Gracilariopsis_chorda_TGACCA_L002_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.snpeff.tab > Gracilariopsis_chorda_TGACCA_L002_R1_001_bismark_bt2_pe.deduplicated.bismark.cov.snpeff.tab.txt


perl -F'\t' -anle'
($MethPer, $MethCnt, $UnMethCnt, @anno)= split ";", @F[3];
$k=join "\t",@F[0..2], $MethPer, $MethCnt, $UnMethCnt;


if(/# Chromo/){
    print join "\t", @F[0..2], qw/MethylationPercent MethylationCnt UnMethylationCnt/, "Region", "DetailRegion / Interval Betwen Genes / Codon change / distance to transcript", "transcript ID", "ExonTypeBefore", "Gene", "ExonTypeAfter", "Score";
}elsif( @anno ){
	for $i ( @anno ){
		$i =~ s/\|/\t/g;
		if( $i =~ s/Gene/Gene\t\t\t/ ){
			print join "\t", $k, $i, $F[$#F];
		}elsif( $i =~ s/Intergenic/Intergenic\t/ ){
			print join "\t", $k, $i, "", "\t\t$F[$#F]";
		}else{
			print "$k\t$i\t$F[$#F]"
		}
	}
}' $1 > $1.tab


perl -F'\t' -anle'print if $F[4] =~ /\w+/' $1.tab > $1.tab.bak
rm -rf $1.tab 
mv $1.tab.bak $1.tab


 #### get unique line perl methyl site
 ##
 ##perl -F'\t' -anle'
 ##if(@ARGV){
 ##    push @order, $F[0];
 ##}else{
 ##    if( ++$c == 1 ){
 ##        print
 ##    }else{
 ##        $k1 = join "\t", @F[0..5]; ## key 1
 ##        $k2 = join "\t", @F[6]; ## key 2
 ##        $h{$k1}{$k2}= $_;
 ##    }
 ##}
 ##
 ##}{
 ##
 ##for $i ( keys %h ){ 
 ##    for $j ( @order ){
 ##        if( defined $h{$i}{$j} ){
 ##            print $h{$i}{$j};
 ##            last;
 ##        }
 ##    }
 ##}' /home/adminrig/src/short_read_assembly/bin/Methylseq.Order $1.tab > $1.tab.tmp
 ##
 ##mv $1.tab.tmp $1.tab
 ##

cut -f7  $1.tab | sort | uniq -c | grep -v Effect | awk '{print $2"\t"$1}' >  $1.tab.EffectCount
#cut -f1-12 $1.tab > $1.tab.txt
cut -f1-9,11  $1.tab > $1.tab.txt




