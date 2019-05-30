#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then


perl -F'\t' -anle'
BEGIN{
        $num{0} = "1 1";
        $num{1} = "1 2";
        $num{2} = "2 2";
        $num{-1} = "0 0";
}

if(@ARGV){
        next if /^Probe/;
        ($m,$chr,$bp,$s,$A,$B,$REF,$ALT) = @F[0,4,5,7,11,12,13,14];
        ($x1, $x2) = @F[8,24];

        if($chr eq "---"){
                ($chr, $bp) = (0, 0);
        }
        $chr = 25 if $x1 + $x2 > 0;

        if($ALT eq "-"){
                # deletion
                $bp=$bp-1
        }

        @{$h{$m}} = ($chr, $bp);
        if( $s eq "-" ){
                $A=~ tr/ACGT/TGCA/;
                $B=~ tr/ACGT/TGCA/;
        }

        $allele{$m}{A} = $A;
        $allele{$m}{B} = $B;

}else{

#		print $flag;
#		print "$F[0] : $h{$F[0]}";
                if(/^#/){
                        next;
                }elsif(/^probeset/){
                        @id = @F[1..$#F];
                        map { print STDERR join "\t", $_, $_, 0, 0, 1, 1 } @id;
                        $flag=1;
                }elsif($flag && $h{$F[0]}){
                        ($chr,$bp) = @{$h{$F[0]}};

					    @geno=();
					    map { s/(FL|Nocall|Fail)/00/g; s/^(\w)/\1 /; push @geno, $_ } @F[1..$#F];
                        print join "\t", $chr, $F[0], 0, $bp, @geno;
                }
}
' $2 $1 > $1.tped 2> $1.tfam

perl -F'\t' -anle'print join "\t", $F[0], 1, 2, @F[3,4] if $.>1' $2.allele > allele.txt


## tped to binary ped
plink --tfile $1 --make-bed --out $1.plink --noweb

else
	usage "GenotypeFile LibraryFile"
fi

