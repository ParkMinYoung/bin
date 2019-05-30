#!/bin/sh

source ~/.bash_function
source ~/.GATKrc

if [ -f "$1" ];then

	perl -F'\t' -MMin -asne'
	chomp@F;
	if(@ARGV){
			@gene = split ",", $F[3];
			
			$gene="";
			map { @list = split ":", $_;	
				  for $i ( @list ){
					($key, $value) = split /\|/, $i;
					
					$gene=$value if $key eq "entg";
					$h{$value}=$gene;
				  }
				
			} @gene; 
	}else{
			@gene = split ",", $F[3];
			$line=$_;
			for (@gene) { 
				  $flag=0;
				  @list = split ":", $_;
				  for $i ( @list ){
					($key, $value) = split /\|/, $i;
#print "$key\t$value\t$h{$value}\t$line";
					if( $h{$value} ){
							$flag=1;
							$gene = $h{$value};
							$m{$gene}{total_len} += $F[6];
							$m{$gene}{Exp_len} += $F[5];
							$m{$gene}{Coverage} = $m{$gene}{Exp_len}/$m{$gene}{total_len}*100;
							last
					}

				  }
				  last if $flag;
				
			}
	}
	}{ mmfss($f, %m)

	' -- -f=$1 $1 $1
#GPS00000.SortedMerge.bam.Dedupping.bam.TableRecalibration.bam.IndelRealigner.bam.genomeCoverage.X20.merge.InTargetRegion.bed.SureSelect_All_Exon_G3362_with_names.v2.hg19.bed.merged.NumChr.bed.coverage
else
	usage "xxx.coverage"
fi



## 1       39845860        39846100        entg|MACF1:ccds|CCDS435.1       1       240     240     1.0000000
## 1       161480564       161480804       entg|FCGR2A:ccds|CCDS30922.1    1       240     240     1.0000000
## 1       247463779       247464619       entg|ZNF496:ccds|CCDS1631.1     2       829     840     0.9869047
## 1       248512065       248513025       entg|OR14C36:ccds|CCDS31112.1   1       960     960     1.0000000
## 1       1179552 1179672 entg|FAM132A:ccds|CCDS30554.1   6       41      120     0.3416667
## 1       11141096        11141336        entg|EXOSC10:ccds|CCDS126.1     1       240     240     1.0000000
## 1       12320740        12320860        entg|VPS13D:ccds|CCDS30588.1    1       120     120     1.0000000
## 1       17301406        17301526        entg|MFAP2:ccds|CCDS174.1       0       0       120     0.0000000
## 1       22413140        22413380        entg|CDC42:ccds|CCDS221.1       1       240     240     1.0000000
## 1       26607521        26607641        entg|SH3BGRL3:ccds|CCDS278.1    1       120     120     1.0000000

## 
## ccds|
## entg|
## gb|AB
## gb|AF
## gb|AJ
## gb|AK
## gb|AL
## gb|AX
## gb|AY
## gb|BC
## gb|BX
## gb|CR
## gb|CU
## gb|DQ
## gb|U0
## mirna
## NA

