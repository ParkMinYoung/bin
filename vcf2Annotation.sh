
#!/bin/sh

source ~/.bash_function
# file=try.vcf

if [ -f "$1" ];then
                ## pipeline



                make.indel.snp.inputV3.sh $1
				COORD=/home/adminrig/Genome/RefFlat/v37/refGene.txt
                GetVarAnnotation.pl --in-file $1.snp --coord $COORD --format refGene > /dev/null
                GetVarAnnotation.INDEL.pl --in-file $1.indel --coord $COORD --format refGene > /dev/null


                ## input
                perl -F"\t" -anle'print join "\t",@F[0..2],(join ",",@F[3..14])' $1.snp.out > $1.snp.out.tmp
                perl -F"\t" -anle'print join "\t",@F[0..2],(join ",",@F[3..15])' $1.indel.out > $1.indel.out.tmp


                ## add RS
                # single
                perl -F'\t' -anle'$id="$F[0]:$F[2]";@ARGV ? $h{$id}=$F[3] : print join "\t", @F[0..2],(split ",","$F[3],$h{$id}")' /home/adminrig/Genome/SNP/snp131.single.bed $1.snp.out.tmp > $1.snp.out.RS

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
				} ' ~/Genome/SNP/snp131.bed $1.indel.out.tmp > $1.indel.out.RS



                perl -F'\t' -anle'@l=split ",", (join ",",@F[3,4]);print join "\t",@F[0..2],@l' $1.indel.out.RS | perl -F'\t' -anle'@F[15..18]=@F[16..18,15];print join "\t",@F' > $1.indel.out.RS.tmp
                mv -f $1.indel.out.RS.tmp $1.indel.out.RS
				
				cat $1.snp.out.RS $1.indel.out.RS > $1.RS


                GetOnOff.VarMatrix.sh $1.snp.out.RS $1.indel.out.RS

else
                usage try.vcf
fi

