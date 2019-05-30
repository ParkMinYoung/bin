#!/usr/bin/perl 
#===============================================================================
#
#         FILE: Ps.performance.QC.pl
#
#        USAGE: ./Ps.performance.QC.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 01/17/2017 10:49:25 AM
#     REVISION: ---
#===============================================================================

#use strict;
#use warnings;

use List::Util qw(max min);
use List::MoreUtils qw(any each_arrayref each_array all);
use Tie::RangeHash;
use Array::Utils qw(:all);

@col = qw/5 6 7 8 10 11/;
@col = map { --$_ } @col;
##	$1      probeset_id             AX-100005719
##	$2      Batch                   1, 2, 3, 
##	$3      Count                   429, 192, 192, 
##	$4      A_Freq                  0.9965, 0.0000, 0.0000, 
##	$5      Freq_diff               0.9965
##	$6      CR                      99.5338, 100, 100, 
##	$7      FLD                     5.5765, NA, NA, 
##	$8      HomFLD                  NA, NA, NA, 
##	$9      HetSO                   0.7793, NA, NA, 
##	$10     HomRO                   -0.5902, 0.7312, 0.908, 
##	$11     ConversionType          Other, MonoHighResolution, MonoHighResolution, 
##	$12     H.W.p-Value             1, 1, 1, 
##	$13     MinorAlleleFrequency    0.0035, 0, 0, 
##	$14     H.W.statistic           1, 1, 1, 

## diff = max - min

$Freq_diff=0.15;
$FLD_diff=3;
$HomFLD_diff=15;
$HomRO_diff=1;

## define range

tie %Freq_diff, 'Tie::RangeHash', {
    Type => Tie::RangeHash::TYPE_NUMBER
  };

  $Freq_diff{',0.0499999999'}      = 'Best';
  $Freq_diff{'0.05,0.09999999'}       = 'Good';
  $Freq_diff{'0.10,0.19999999'}     = 'Bad';
  $Freq_diff{'0.20,'}              = 'Worst';

tie %CR, 'Tie::RangeHash', {
    Type => Tie::RangeHash::TYPE_NUMBER
  };

  $CR{'0.99,'}              = 'Best';
  $CR{'0.97,0.98999999'}     = 'Good';
  $CR{'0.95,0.96999999'}     = 'Bad';
  $CR{',0.94999999'}              = 'Worst';

tie %FLD, 'Tie::RangeHash', {
    Type => Tie::RangeHash::TYPE_NUMBER
  };

  $FLD{'10,'}             = 'Best';
  $FLD{'7,9.999999'}      = 'Good';
  $FLD{'5,6.999999'}      = 'Bad';
  $FLD{',4.999999'}              = 'Worst';


tie %HomFLD, 'Tie::RangeHash', {
    Type => Tie::RangeHash::TYPE_NUMBER
  };

  $HomFLD{'15,'}            = 'Best';
  $HomFLD{'10, 14.999999'}  = 'Good';
  $HomFLD{'8,9.999999'}     = 'Bad';
  $HomFLD{',7.999999'}             = 'Worst';


tie %HomRO, 'Tie::RangeHash', {
    Type => Tie::RangeHash::TYPE_NUMBER
  };

  $HomRO{'3,'}              = 'Best';
  $HomRO{'2,2.999999'}      = 'Good';
  $HomRO{'1,1.999999'}      = 'Bad';
  $HomRO{',0.999999'}              = 'Worst';


 # convertiontype 2 number
  $h2n{CallRateBelowThreshold}=0;
  $h2n{Other}=0;
  $h2n{OTV}=0;
  $h2n{Hemizygous}=0;
  $h2n{MonoHighResolution}=1;
  $h2n{NoMinorHom}=1;
  $h2n{PolyHighResolution}=2;


while(<>){
	chomp;
	@F=split "\t" ,$_;

	if($.==1){
		@head = @F;
		print join "\t", @F, "QC","Remark1","QC2","Remark2\n";
	}else{

		@data = ();		

		for ( @col ){
			@values =split ", ", $F[$_];
			push @data, [@values];

			@qc= range( \@values,  $head[$_]  );
#			print join "\t", $head[$_], (join ":", @values),  (join ":", @qc),"\n";

			$h{$head[$_]} = diff( @values );
			$h{$head[$_]."2"} = diff2( @values );

			if( $head[$_] eq "FLD" ){
				@FLD=num(@values);
			}elsif( $head[$_] eq "ConversionType"){
				$Conversion = conversion2num(@values);
				@Conversion = @values;
			}elsif( $head[$_] eq "HomFLD" ){
				@HomFLD=@values;
			}

		}

		$QC="Pass";
		$remark="";
		
		@qc=();
		@remark=();
		$num=0;
		@batch = split ", ", $F[1];
		
		## MARKER FAIL
		if($F[4] >= $Freq_diff){
			$QC = "Fail";
			$remark = "Freq_diff : $F[4], Wrong Homozygous Call";
		}else{
		
			#@data order
			#Freq_diff
			#CR
			#FLD
			#HomFLD
			#HomRO
			#ConversionType
			

			$ea = each_arrayref($data[0], $data[1], $data[2], $data[3], $data[4], $data[5]);
			while ( my ($freq_diff, $cr, $fld, $homfld,$homro,$conversion) = $ea->() ){
		
				if($fld < 5 && $homfld > 10 && $homro < 1){
					push @qc, $batch[$num];
					push @remark, " $batch[$num++] : fld < 5 && homfld > 10 && homro < 1";
					$QC="Fail1";

				}elsif( $h{FLD} >= 3 && $h{HomFLD} >=3 && $h{HomRO} >= 1 ){
					push @qc, $batch[$num];
					push @remark, " $batch[$num++] : fld_d >=3  && homfld_d >= 3 && homro_d >= 1";
					$QC="Fail2";

				}elsif( $homro < 0 ){
					push @qc, $batch[$num];
					push @remark, " $batch[$num++] : homro < 0";
					$QC="Fail3";

	# P-> Fail : 7
				}elsif( $h{HomFLD} > 2 && $h{HomRO} > 1.5 ){
					push @qc, $batch[$num];
					push @remark, " $batch[$num++] : fld_d < 10 && homro_d < 1";
					$QC="Fail5";
				}elsif( $fld < 8 && $h{FLD2} > 2 && $h{HomFLD2} > 5 && $h{HomRO2} > 0.5 ){
					## if HomFLDs has only one value, return 20 [$h{HomFLD2}, others are NAs]
					push @qc, $batch[$num];
					push @remark, " $batch[$num++] : fld < 6 && fld_d > 3 && homfld_d > 5 && homro_d > 0.5";
					$QC="Fail4";
				}
				
			}
			
			if( $QC !~ /Fail/i ){

				if( all { $_ < 4 } @FLD ){

					$QC="FailN1";
					push @qc, "all FLD < 4";
					push @remark, "all low FLD";
				}elsif( $Conversion == 1 ){
					$QC="FailN2";
					push @qc, "abnormal Conversion";
					push @remark, "Conversion : unique NoMinorHom or MonoHighResolution + Fail conversion";
				}elsif( all { $_ eq "NA" } @HomFLD ){
					if( all { $_ < 5 } min( @FLD ) ){
						unless( all { $_ eq "NoMinorHom" } @Conversion ) {

							$QC="FailN3";
							push @qc, "all FLD < 5 && all HomFLD == NA";
							push @remark, "closed Heterozygous call in AA or BB";
						}		
					}		
				}

			}	
		}


		$line= join "\t", $_, $QC, $remark, (join ", ", @qc), (join ", ", @remark) ;
		print "$line\n";
#		exit;
	}
}



sub range {
	($val, $tie) = @_;
	
	@out= map {$value= "\$${tie}{'$_'}"; $_=~/NA/ ? "NA" : eval($value) } @{$val};
	return @out;
}

sub diff {
	@num = num(@_);
	if( @num>=2 ){ 
		return max(@num) - min(@num)
	}else{
		return "NA"
	}
}

sub diff2 {
	@num = num(@_);
	@num = sort {$a<=>$b} @num;

	if( @num>=2 ){ 
		return $num[1] - $num[0];
	}else{
#		return 0;
		return 20;
	}
}



sub num {
	return grep { /\d+/ } @_;
}


sub conversion2num {
	$sum=0;
	map { $sum+= $h2n{$_} } @_;
	return $sum;
}
