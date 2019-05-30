
#!/bin/sh

source ~/.bash_function
# file=try.vcf

dbSNP_bed=/home/adminrig/Genome/dbSNP/snp132.txt.bed
dbSNP_bed_single=/home/adminrig/Genome/dbSNP/snp132.single.bed



if [ -f "$1" ];then
                ## pipeline


				# for samtools call
				# make.indel.snp.inputV3.sh $1

				# GATK call
				perl -i.bak -ple'$_="chr$_" if !/^#/' $1
                
				make.indel.snp.inputV4.GATK.sh $1
				perl -F'\t' -i.bak -aple'if($F[3]=~/(\w)\/\./){$i=$1;$F[3]=~s/\./$i/;$_= join "\t",@F}' $1.snp 
                
				GetVarAnnotation.pl --in-file $1.snp > /dev/null
                GetVarAnnotation.INDEL.pl --in-file $1.indel > /dev/null


                ## input
                perl -F"\t" -anle'print join "\t",@F[0..2],(join ",",@F[3..14])' $1.snp.out > $1.snp.out.tmp
                perl -F"\t" -anle'print join "\t",@F[0..2],(join ",",@F[3..15])' $1.indel.out > $1.indel.out.tmp


                ## add RS
                # single
				# perl -F'\t' -anle'$id="$F[0]:$F[2]";@ARGV ? $h{$id}=$F[3] : print join "\t", @F[0..2],(split ",","$F[3],$h{$id}")' /home/adminrig/Genome/SNP/snp131.single.bed $1.snp.out.tmp > $1.snp.out.RS
                perl -F'\t' -anle'$id="$F[0]:$F[2]";@ARGV ? $h{$id}=$F[3] : print join "\t", @F[0..2],(split ",","$F[3],$h{$id}")' $dbSNP_bed_single $1.snp.out.tmp > $1.snp.out.RS

                # indel
				perl -F'\t' -anle'$id="$F[0]:$F[2]"; 
				if(@ARGV){
					push @{$h{$id}}, $F[3] if $F[3] !~ /single/;
					push @{$h{"$F[0]:$F[1]"}}, $F[3] if $F[3] !~ /single/
					
				} else { 
					@list=split ",", $F[3]; 
					@l=split /\|/,$list[12]; 
					$list[0]=~/\.[\+-]\d+(\w+)/;
					$ref=$1;
					$found="";
					$line=$_; 
					if(/insertion/){
						$F[2];
						$id2="$F[0]:$F[2]"; 
						for $i( @{$h{$id}}, @{$h{$id2}} ){ 
							next if /LARGE/; 
							($rs,$geno,$type)=split ",", $i; 
							map { $found=$i if $ref eq $_ } split /\//,$geno
						} 
						print "$line\t$found"
					}elsif(/deletion/){
						$id="$F[0]:$F[2]"; 
						$id2="$F[0]:$F[1]"; 
						for $i( @{$h{$id}}, @{$h{$id2}} ){ 
							next if /LARGE/; 
							($rs,$geno,$type)=split ",", $i; 
							map { $found=$i if $ref eq $_ } split /\//,$geno
						} 
						print "$line\t$found" 
					} 
				} ' $dbSNP_bed $1.indel.out.tmp > $1.indel.out.RS



                perl -F'\t' -anle'@l=split ",", (join ",",@F[3,4]);print join "\t",@F[0..2],@l' $1.indel.out.RS | perl -F'\t' -anle'@F[15..18]=@F[16..18,15];print join "\t",@F' > $1.indel.out.RS.tmp
                mv -f $1.indel.out.RS.tmp $1.indel.out.RS
				
				cat $1.snp.out.RS $1.indel.out.RS > $1.RS

				
#cat $1 | vcf2GTsDPsGQs.sh > Disease.Final.vcf.detail
				GATK.vcf2GTsGPsGQsADs.sh $1 > Disease.Final.vcf.detail
				perl -F'\t' -anle'$key="$F[0]:$F[2]";
				if(@ARGV==2){$key="$F[0]:$F[1]";$vcf2geno{$key}=$_}
				elsif(@ARGV==1){$link{$key}="$F[0]:$F[4]"}
				else{
				$link_key=$link{$key};
				$F[18]=$vcf2geno{$link_key};
				print join "\t",@F;
				}' Disease.Final.vcf.detail $1.link $1.RS  > $1.RS.final
				
				RS.final.filter.sh $1.RS.final > $1.RS.final.filter
				egrep -e "CDS (indel-shift|non-syn)" $1.RS.final.filter > $1.RS.final.filter.non-syn

				perl -F'\t' -MMin -ane'chomp@F;
				$type= $F[3]=~/[-+]/ ? "INDEL" : "SNP";
				$db= $F[15]=~/\d+/ ? "dbSNP" : "novel";
				$region = ${[ split " ", $F[6] ]}[0] || "NonGenic";
				if($region eq "CDS"){
					$region .= $F[11] eq $F[12] ? " syn" : " non-syn";
				}
				elsif($region eq "SP"){
					$region = "Splice"
				}
				$h{"$type $region"}{$db}++
				}{ mmfss("region.count",%h)' $1.RS.final
				
				region.count.sort.sh > region.count.sort.txt
				rm -rf region.count.txt

                GetOnOff.VarMatrix.sh $1.snp.out.RS $1.indel.out.RS
				mkdir etc && mv `ls *indel.out* *snp.out*` etc


else
                usage try.vcf
fi


