. ~/.perl


. ~/.GATKrc

#(cd Variant && unzip call.zip )

Index2ID.sh
batch.SGE.sh IonProton.SNU.430k.sh `find Analysis/BAM/ -type f | grep bam$ | sort` > 01.depthcoverage
sh 01.depthcoverage
waiting Ion.snuh0

#GenomeAnalysisTK.UnifiedGenotyper.EachInterval.WrapperSGE.hg19 /home/adminrig/Genome/IonAmpliSeq/SNU.430/Custom.Interval2EachChr.Size.1000 `find Analysis/BAM/ | grep AddRG.bam$`  > 02.call
#sh 02.call

GenomeAnalysisTK.DepthOfCoverage.summary

GenomeAnalysisTK.DepthOfCoverage.interval.summary $SNU430k_1 $SNU430k_2

read.len.dist.sh `find Analysis/FASTQ/ | grep fastq$`

batch.SGE.sh fastqc `find Analysis/FASTQ/ | grep fastq$` > 03.fastq
sh 03.fastq
waiting fas

SeqSummaryV2.sh
flagstat.parsing.v2.sh `find | grep flagstats$`


BED=/home/adminrig/Genome/IonAmpliSeq/SNU.430/SNU.BangYoungJu.430k.bed.CHR.bed
BED=/home/adminrig/Genome/IonAmpliSeq/SNU.430/SNU.BangYoungJu.430k.bed

GenomeAnalysisTK.DepthOfCoverage.Gene.summary 1 $BED
GenomeAnalysisTK.DepthOfCoverage.Gene.summary 50 $BED
GenomeAnalysisTK.DepthOfCoverage.Gene.summary 100 $BED
GenomeAnalysisTK.DepthOfCoverage.Gene.summary 200 $BED


mkdir -p Analysis/tier
cd Analysis
ln $BED ./

cd VAR
SNU.IdCheck.sh


## ln `find /home/adminrig/workspace.jin/SNU.BYJ.proton.varscan.20131112/ | grep tier` tier
## find BAM/ | grep AddRG.bam$ | sort | xargs -n 2 | perl -nle'/(snuh\d+)/; print "IGV.img.somatic.FromBed.sh $_ SNU.BangYoungJu.430k.bed tier/$1.variant_tiers.snp"' > IGV.snp
## COSMIC=/home/adminrig/Genome/IonAmpliSeq/SNU.430/SNU.BangYoungJoo.COSMIC.snp
## find BAM/ | grep AddRG.bam$ | sort | xargs -n 2 | perl -snle'/(snuh\d+)/; print "cp $cosmic tier/$1.COSMIC.variant_tiers.snp\nIGV.img.somatic.FromBed.cosmic.sh $_ SNU.BangYoungJu.430k.bed tier/$1.COSMIC.variant_tiers.snp"' -- -cosmic=$COSMIC >> IGV.snp
## sh IGV.snp

### grep -f SNUH.50 IGV.cosmic.snp  > IGV.cosmic.snp.SNUH.50




## for i in *snp;do  perl -F'\t' -asnle'$f="$F[3].$F[0].$F[1]-$F[2].png"; print "$dir\t$_" if ! -f "$dir/$f"' -- -dir=$i.IGV $i > $i.bak ;done
## find -empty -type f | grep bak$ | xargs rm
## find BAM/ | grep AddRG.bam$ | sort | xargs -n 2 | perl -nle'/(snuh\d+)/; print "IGV.img.somatic.FromBed.sh $_ SNU.BangYoungJu.430k.bed tier/$1.variant_tiers.indel"' > IGV.indel
##
## cd tier
## for i in `find_d 1 | grep snp.IGV`;do (cd $i && mkdir P H F);done


## find snuh0* -maxdepth 1 -type f | grep png$ | perl -MFile::Basename -nle'/(snuh\d+)/; $f=fileparse($_); print "$1.$f"' > png
## mkdir png.dir
## 
##  find snuh0* -type f | grep png$ | perl -MFile::Basename -nle'/(snuh\d+)/; $f=fileparse($_); print "ln $_ png.dir/$1.$f"' > png.ln
##  sh png.ln
## 
## cd png.dir
## ls *png | perl -nle's/\.png//; print "insert into frequency (assayid, pvalue, remarks, qcr, path) values (\"$_\", \"0\", \"\", \"\", \"\")"' |  tr "\"" "\'" > png.sql
## 
## select * from frequency
## select count(*) from frequency
## delete from frequency


## select * into frequency from frequency_CSJ_1005_67_120904
## select count(*) from frequency
## delete from frequency

## # cluster QC
## 
## 
## pngMVQCDir.sh 
## SNU.BangYoungJoo.QCsummary.sh
## mkdir COSMIC
## mv `ls | grep COSMIC.variant` COSMIC/ && mv COSMIC/ ../
## 
## 
## # insert into frequency (assayid, pvalue, remarks, qcr, path) values ('snuh0013.4.chr17.37881928-37881929', '0.0000614697', 'minmin', '', '')
## 
## # after QC, png file include below line
## # snuh0050.2.chr9.139401389-139401390   6.97858E-05     minmin: minmin  F


#### mv back folder 
#### for i in `find_d 1 | grep IGV$ | grep -v COSMIC`;do (cd $i && mv {P,H,F}/*png ./);done
#### find `find_d 1 | grep IGV$ | grep -v COSMIC` -type f | grep png$ | grep 5.chr | perl -nle'/snuh\d+/;print "mv $_ $&.COSMIC.variant_tiers.snp.IGV"' | sh


##find -type f | grep png$ | perl -MFile::Basename -nle'($f,$d) =fileparse($_); $d=~s/^\.\///;$d=~s/\.IGV\///;$h{$d}++; }{ map { print "$_\t$h{$_}" } keys %h ' > png.count
##wc -l *snp | awk '{print $2"\t"$1}' | grep -v ^total > tiers.snp.count
##perl -F'\t' -anle'if(@ARGV){$h{$F[0]}=$F[1]}else{$diff=$F[1]-$h{$F[0]}; $F[0]=~/(snuh\d+)/; $id=$1; print join "\t", $id, @F, $h{$F[0]},$diff if $diff}' png.count tiers.snp.count > ReIGV.List
##for i in `cut -f1 ReIGV.List `; do echo "SNU.BangYoungJoo.png.sh $i";done > ReIGV.List.sh
##sh ReIGV.List.sh
##find *bak.IGV -type f| grep png$ | perl -MFile::Basename -nle'($f,$d) = fileparse($_); $d=~ s/\.bak//; print "mv $_ $d"' | sh
##
##rmdir *bak.IGV
##ls | grep bak | xargs rm


