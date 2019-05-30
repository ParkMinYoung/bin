
#!/bin/sh

source ~/.bash_function
# file=s_1.bam.sorted.bam.variation.pileup.D20.vcf

if [ -f "$1" ];then
                ## pipeline
		#(head -1000 s_2/s_2.bam.sorted.bam.variation.pileup.D20.vcf | grep "^#"; grep ^chr s_2/s_2.bam.sorted.bam.variation.pileup.D20.vcf | grep -v "," ) | vcf-convert -r ~/Genome/hg19.bwa/hg19.fasta > s_2/s_2.bam.sorted.bam.variation.pileup.D20.vcf.v4

		(head -2000 $1 | grep "^#"; grep ^chr $1 | grep -v "," ) | vcf-convert -r ~/Genome/hg19.bwa/hg19.fasta | fill-an-ac > $1.v4

                make.indel.snp.inputV2.sh $1.v4
                GetVarAnnotation.pl --in-file $1.v4.snp > /dev/null
                GetVarAnnotation.INDEL.pl --in-file $1.v4.indel > /dev/null


                ## input
                perl -F"\t" -anle'print join "\t",@F[0..2],(join ",",@F[3..14])' $1.v4.snp.out > $1.v4.snp.out.tmp
                perl -F"\t" -anle'print join "\t",@F[0..2],(join ",",@F[3..15])' $1.v4.indel.out > $1.v4.indel.out.tmp


                ## add RS
                # single
                perl -F'\t' -anle'$id="$F[0]:$F[2]";@ARGV ? $h{$id}=$F[3] : print join "\t", @F[0..2],(split ",","$F[3],$h{$id}")' /home/adminrig/Genome/SNP/snp131.single.bed $1.v4.snp.out.tmp > $1.v4.snp.out.RS

                # indel
                perl -F'\t' -anle'$id="$F[0]:$F[2]"; if(@ARGV){push @{$h{$id}}, $F[3] if $F[3] !~ /single/} else { @list=split ",", $F[3]; @l=split /\|/,$list[12]; $list[0]=~/\.[\+-]\d+(\w+)/;$ref=$1;$found="";$line=$_; if(/insertion/){
$F[2]++;$id2="$F[0]:$F[2]"; for $i( @{$h{$id}}, @{$h{$id2}} ){ next if /LARGE/; ($rs,$geno,$type)=split ",", $i; map { $found=$i if $ref eq $_ } split /\//,$geno; } print "$line\t$found"}elsif(/deletion/){$id="$F[0]:$l[2]"; $id2="$F[0]:$
l[1]"; for $i( @{$h{$id}}, @{$h{$id2}} ){ next if /LARGE/; ($rs,$geno,$type)=split ",", $i; map { $found=$i if $ref eq $_ } split /\//,$geno; } print "$line\t$found" } } ' ~/Genome/SNP/snp131.bed $1.v4.indel.out.tmp > $1.v4.indel.out.RS
                perl -F'\t' -anle'@l=split ",", (join ",",@F[3,4]);print join "\t",@F[0..2],@l' $1.v4.indel.out.RS | perl -F'\t' -anle'@F[15..18]=@F[16..18,15];print join "\t",@F' > $1.v4.indel.out.RS.tmp
                mv -f $1.v4.indel.out.RS.tmp $1.v4.indel.out.RS


                GetOnOff.VarMatrix.sh $1.v4.snp.out.RS $1.v4.indel.out.RS

else
		echo "find -type f | grep variation.pileup$ | xargs -i echo ./samtools.varFilter.sh {} | sh"
		echo "find -type f | grep D20.vcf$ | xargs -i echo vcf.pipeline.sh {} | sh"
        usage try.vcf
fi
