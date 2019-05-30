#!/bin/sh



F1=$(basename $1)
F2=$(basename $2)

perl -MMin -MList::Compare -MList::MoreUtils=uniq -se'

%x= read_matrix($x);
%y= read_matrix($y);

END{

## sample intersection

@Llist = keys %x;
@Rlist = keys %y;

$lc = List::Compare->new(\@Llist, \@Rlist);
@intersection = $lc->get_intersection;


## pos intersection
$sam = $intersection[0];
print "$sam\n";
@Llist = keys %{$x{$sam}};
@Rlist = keys %{$y{$sam}};

print "@Llist\n";
print "@Rlist\n";

$lc = List::Compare->new(\@Llist, \@Rlist);
@pos = $lc->get_intersection;

print "sample @intersection\n";
#print "pos @pos\n";


### if you want to specific list,
### Assign @intersection array !

# @intersection = qw/dx1 dx2 dx3 dx4 dx5 dx6 dx7 dx8 dx9 dx10 dx11 dx13 dx14 dx15 dx16 dx17 dx18 dx19 dx20 dx21 dx22 dx23 dx24 dx26 dx28 dx29 dx30 dx31 dx32 dx33 dx35 dx36 dx37 dx38 dx39 dx40 dx41 dx42 dx43 dx44 dx45 dx46 dx47 dx48 dx49 dx50 dx52 dx53 dx54 dx56 dx57 dx58 dx59 dx61 dx62 dx63 dx64 dx65 dx66 dx67 dx68 dx69 dx70 dx71 dx72 dx73 dx74 dx75/;

## comparison

for $pos ( @pos ){
	for $sample ( @intersection ){

		$A = $x{$sample}{$pos};
		$B = $y{$sample}{$pos};
		
		$A ||= "NN";
		$B ||= "NN";
		
		if( $A =~ tr/ACGT/1234/ && $B =~ tr/ACGT/1234/ ){
			
			@A = split "", $A;
			@B = split "", $B;

			$A = join "", sort {$a<=>$b} @A;
			$B = join "", sort {$a<=>$b} @B;

			$uniq_allele_count = uniq( @A, @B );

			%allele_cnt = ();
			map { $allele_cnt{$_}++ } (@A, @B);
			@allele = sort { $allele_cnt{$a} <=> $allele_cnt{$b} } keys %allele_cnt;

			$Call{$pos}{Comparison}++;
			$Sampe{$sample}{Comparison}++;

			if( "$A" eq "$B" ){
				$Call{$pos}{Com_Match}++;
				$Sampe{$sample}{Com_Match}++;
				$m{$pos}{$sample}="Com_match";
			}else{
				$Call{$pos}{Com_Mis}++;
				$Sampe{$sample}{Com_Mis}++;
				
				if( $allele_cnt{$allele[0]} == 2 ){
					$Call{$pos}{Com_Mis_Homo}++;
					$Sampe{$sample}{Com_Mis_Homo}++;
				}elsif( $allele_cnt{$allele[0]} == 1 ){
					$Call{$pos}{Com_Mis_Het}++;
					$Sampe{$sample}{Com_Mis_Het}++;
				}

				$m{$pos}{$sample}="Com_mis";
			}
			$Call{$pos}{XCall}++;
			$Call{$pos}{YCall}++;
			$Sampe{$sample}{XCall}++;
			$Sampe{$sample}{YCall}++;

#print "$sample\t$pos\t$A\t$B\n";
		}elsif("$A" eq "NN" && "$B" eq "NN"){
			$Call{$pos}{XN}++;
			$Call{$pos}{YN}++;
			$Sampe{$sample}{XN}++;
			$Sampe{$sample}{YN}++;
			$m{$pos}{$sample}="BothN";
		}elsif("$A" eq "NN"){
			$Call{$pos}{XN}++;
			$Call{$pos}{YCall}++;
			$Sampe{$sample}{XN}++;
			$Sampe{$sample}{YCall}++;
			$m{$pos}{$sample}="XN";
		}elsif("$B" eq "NN"){
			$Call{$pos}{YN}++;
			$Call{$pos}{XCall}++;
			$Sampe{$sample}{YN}++;
			$Sampe{$sample}{XCall}++;
			$m{$pos}{$sample}="YN";
		}
		$Call{$pos}{total}++;
		$Sampe{$sample}{Total}++;
	}
	$Call{$pos}{XCR} = sprintf "%0.2f", $Call{$pos}{XCall} / ($Call{$pos}{XCall} + $Call{$pos}{XN});
	$Call{$pos}{YCR} = sprintf "%0.2f", $Call{$pos}{YCall} / ($Call{$pos}{YCall} + $Call{$pos}{YN});

}

for $sample ( @intersection ){
	$Sampe{$sample}{XCR} = sprintf "%0.2f", $Sampe{$sample}{XCall} / $Sampe{$sample}{Total};
	$Sampe{$sample}{YCR} = sprintf "%0.2f", $Sampe{$sample}{YCall} / $Sampe{$sample}{Total};
}

for $pos(@pos){
	if( $Call{$pos}{XCR} >= $xcr && $Call{$pos}{YCR} >= $ycr ){
		for $sam ( @intersection ){
			$value = $m{$pos}{$sam};
			$CR{$sam}{$value}++;
			$CR{$sam}{Total}++;
		}
	}
}

map { $CR{$_}{Concordance} = sprintf "%0.2f", $CR{$_}{Com_match}/$CR{$_}{Total}*100 } sort keys %CR;
map { 
		if( $Call{$_}{Comparison} ){ 
			$Call{$_}{Concordance} = sprintf "%0.2f", $Call{$_}{Com_Match}/ $Call{$_}{Comparison}*100
		}else{ 
			$Call{$_}{Concordance} = "NA"
		}
	}  sort keys %Call;


mmfss("$output.Concordance.0.95.sample",%CR);
mmfss("$output.Concordance",%Call);
mmfss("$output.Concordance.sample",%Sampe);
}
' -- -x=$1 -y=$2 -output="$F1-$F2" -cutoff=$3 -xcr=0.5 -ycr=0.5
#' -- -x=$1 -y=$2 -output="$F1-$F2" -cutoff=$3 -xcr=0.95 -ycr=0.95
#' -- -x=$1 -y=$2 
#' -- -x=CytoScanHD.Genotype.txt.new -y=NGS.Genotype.new.Matrix 
#' -- -x=CytoScanHD.Genotype.txt.new.test -y=NGS.Genotype.new.Matrix.test 
