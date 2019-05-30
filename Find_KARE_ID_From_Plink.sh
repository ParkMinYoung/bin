# excute time : 2017-07-07 10:52:01 : rename
ReNamePattern2Pattern.sh 1 NonChon 1.???  | sh 


KARE_BIM=/home/adminrig/workspace.min/YSUniv.LeeJiYoung/KAREII-III/birdseed-v2.calls.txt.plink_fwd.gender.bim

# hg18 build to hg19
awk '{ print $2"\t"$4 }' $KARE_BIM > hg19.map
awk '{ print $2"\t"$1 }' $KARE_BIM > hg19.chr


plink --bfile NonChon --update-map hg19.chr --update-chr --make-bed --out hg19.chr --noweb
perl -F'\t' -anle'if(@ARGV){$h{$F[0]} = $F[1] eq "---" ? 0 : $F[1] }else{ $F[3]=$h{$F[1]}; print join "\t", @F }' hg19.map hg19.chr.bim > hg19.chr.bim.hg19
mv hg19.chr.bim hg19.chr.bim.bak && mv hg19.chr.bim.hg19 hg19.chr.bim



# matched genotype snp list
# get SNP lise between KARE and YSUniv
perl -F'\t' -anle'if(@ARGV){$h{$F[1]}=join "\t",@F[0,2..5]}else{ $value=join "\t",@F[0,2..5]; print $F[1] if $h{$F[1]} eq $value }' $KARE_BIM hg19.chr.bim > SelectedSNP


# get set A
plink --bfile hg19.chr --extract SelectedSNP --make-bed --out hg19.chr.SelectedSNP --noweb

# get set B
plink --bfile ${KARE_BIM%%.bim} --extract SelectedSNP --make-bed --out KARE.SelectedSNP --noweb

# merge
plink2 --bfile KARE.SelectedSNP --bmerge hg19.chr.SelectedSNP.{bed,bim,fam} --make-bed --out merge --allow-no-sex --threads 10


# Marker QC
plink2 --bfile merge --maf 0.1 --geno 0.1 --hwe 0.001 --make-bed --out merge.IBS  --allow-no-sex --threads 10


# IBS analysis
PlinkGenome.KinShip.Relation.sh merge.IBS


# excute time : 2017-07-07 18:45:33 : Get top 1
grep ^NIH merge.IBS.genome.tab.OrderedValueListFromKey | tr ";" "\t" > ID_Mapping 


# excute time : 2017-07-07 18:46:53 : add header
AddHeader.noheader.sh ID_Mapping ID_Mapping.txt Query MatchedNumber Match MatchScore


# excute time : 2017-07-07 18:49:21 : mkdir dir
mkdir KARE_ID


# excute time : 2017-07-07 14:39:57 : make link
perl -F'\t' -anle'if($.>1){print "ln -s /home/adminrig/workspace.min/KAREII-III/CEL/$F[2] KARE_ID/$F[0].CEL"}' ID_Mapping.txt  | sh 


