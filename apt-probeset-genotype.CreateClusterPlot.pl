#BEGIN{unshift(@INC,"C:/Perl/site/lib/GD");}

#!/usr/bin/perl -w
use strict;
use warnings;

use GD;
use File::Basename;

die "Insert cluster file $!\n" unless -e $ARGV[0];

my ($name, $dir, $ext) = fileparse( $ARGV[0], qr{\.[^.]\w+} );
my $image_dir = $name;

mkdir "$image_dir"  unless -d $image_dir;

#my $font = 'C:\WINDOWS/Fonts/courbi.ttf';
#my $font = '/usr/share/X11/fonts/TTF/luxirbi.ttf';
my $font = '/usr/share/fonts/bitstream-vera/Vera.ttf';

my %num2AA = ( -1 => "NN", 
			   -9 => "NN", 
				5 => "NN", 
				0 => "AA", 
				1 => "AB", 
				2 => "BB",
			  );


#### create canvas
my ($canvas_x, $canvas_y) = (2100, 1200);
my ($margine_so_left ,$margine_so_height ,$margine_height) = (50, 50, 100);

my $F_file = $ARGV[0];
open my $F, '<', $F_file
  or die "$0 : failed to open input file '$F_file' : $!\n";

while (<$F>) {
	chomp;
	next if /^probe/;
	
	my @F = split "\t", $_;
	my %XY;
	my $SNP=$F[0];
	
	map { my ($n, $x, $y) = split /\|/, $_; $XY{$SNP}{$x}{$y} = $n } @F[1..$#F];

	#### create a new image
	my $img = new GD::Image($canvas_x, $canvas_y);# allocate some colors
	
	
	#### setting color
	my $white  = $img->colorAllocate(255,255,255);
	my $black  = $img->colorAllocate(0,0,0);   
	my $red    = $img->colorAllocate(255,0,0);  
	my $blue   = $img->colorAllocate(0,0,255);
	my $purple = $img ->colorAllocate(160,32,240);
	my $orange = $img ->colorAllocate(255,165,0);
	my $pink   = $img ->colorAllocate(205,145,158);
	
	
	#### setting color
	my %genotype2color = (
							NN => $black,
							AA => $red, 
							AB => $purple, 
							BB => $blue, 
						 );
	
	#### setting canvas
	$img->transparent($white);
	$img->interlaced('true');# Put a black frame around the picture
	
	
	$img->stringFT($blue,$font,20,0,$margine_so_left+10,$margine_so_height+80,"Assay ID : $SNP");
	#$img->stringFT($blue,$font,20,0,$margine_so_left,$margine_so_height+20,"RS number : $rs_number_id");
	
	#### draw X axis and Y axis
	$img->line($margine_so_left, ($canvas_y-$margine_height), ($canvas_x-$margine_so_left), ($canvas_y-$margine_height), $blue ); 
	$img->line($margine_so_left, $margine_height, $margine_so_left, ($canvas_y-$margine_height), $blue);
	
	
	#### draw X = 0.1 씩 나타내기
	my $x_interval = 20;
	my $interval_from_x = ($canvas_x - 2*$margine_so_left)/$x_interval;
	my @X_string = qw/-1 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1/;
	
	$img->stringFT($blue,$font,20,0,$margine_so_left-5,($canvas_y-$margine_height)+40,$X_string[0]);
	#$img ->string( gdGiantFont, $margine_so_left-5,($canvas_y-$margine_height)+30, $X_string[0], $blue );
	
	foreach my $i ( 1..$x_interval )
	{
		my $x_po = $margine_so_left+ $interval_from_x * $i;
		
		$img ->line( $x_po, ($canvas_y-$margine_height+10), $x_po, ($canvas_y-$margine_height-10), $blue );
		$img ->dashedLine( $x_po, ($canvas_y-$margine_height+10), $x_po, $margine_height, $blue );
		$img->stringFT($blue,$font,20,0,$x_po-5,($canvas_y-$margine_height)+40,$X_string[$i]);
		#$img ->string( gdGiantFont, $x_po-5,($canvas_y-$margine_height)+30, $X_string[$i], $blue );
	}
	
	#### draw Y = 1 씩 나타내기
	my $y_interval = 20;
	my $interval_from_y = ($canvas_y - 2*$margine_height)/$y_interval;
	
	foreach my $i ( 1..$y_interval )
	{
		my $y_po = $canvas_y - $margine_height - $interval_from_y * ($i);
		$img ->dashedLine( $margine_so_left, $y_po, $canvas_x-$margine_so_left, $y_po, $blue );
		$img->stringFT($blue,$font,20,0,$margine_so_left-30, $y_po,$i);
		#$img ->string( gdGiantFont, $margine_so_left-30, $y_po, $i, $blue );
	}
	
	
	### take dot ###
	
	foreach my $X ( sort {$a <=> $b} keys %{$XY{$SNP}} )
	{
		foreach my $Y ( sort {$a <=> $b} keys %{$XY{$SNP}{$X}} )
		{
			my $numcall = $XY{$SNP}{$X}{$Y};
			my @calls = split /,/, $numcall;
			my $call = $num2AA{$calls[0]};
			
			if( $call eq "NN" ){ next; }
			
			#my ($X,$Y) = take_dot($img,$call,$X,$Y,$margine_so_left,$margine_height,$canvas_x,$canvas_y,$interval_from_y,$red,10,$Name);
			
			my ($X,$Y) = take_dot($img,$call,$X,$Y,$interval_from_y,$genotype2color{$call},10);
		}
	}
	
	
	foreach my $X ( sort {$a <=> $b} keys %{$XY{$SNP}} )
	{
		foreach my $Y ( sort {$a <=> $b} keys %{$XY{$SNP}{$X}} )
		{
			my $numcall = $XY{$SNP}{$X}{$Y};
			my @calls = split /,/, $numcall;
			my $call = $num2AA{$calls[0]};
			
			if( $call eq "NN" )
			{
				#my ($X,$Y) = take_dot($img,$call,$X,$Y,$margine_so_left,$margine_height,$canvas_x,$canvas_y,$interval_from_y,$red,10,$Name);
				my ($X,$Y) = take_dot($img,$call,$X,$Y,$interval_from_y,$genotype2color{$call},10);
			}
		}
	}
	
	save_chart($img,"$image_dir/$SNP");
}





##########################################
############### sub routin ############### 
##########################################


sub take_dot
{
	my ($img,$call,$x,$y,$interval,$clr,$size) = @_;
	
	my $X = X_position_setting($x,$margine_so_left,$canvas_x - 2*$margine_so_left);
	my $Y = Y_position_setting($y,$margine_height,$canvas_y - 2*$margine_height,$interval);
	
	if( $call eq "AA" )
	{
		$img->filledArc($X,$Y,$size,$size,0,360,$clr);
		#$img->stringFT($purple,$font,10,0,$X,$Y,$sample);
		#$img ->string( gdGiantFont, 1880, 830, "HWE value : $result ", $red );
	}
	elsif( $call eq "AB" )
	{
		$img->filledArc($X,$Y,$size,$size,0,360,$clr);
		#$img->stringFT($orange,$font,10,0,$X,$Y,$sample);
	}
	elsif( $call eq "BB" )
	{
		$img->filledArc($X,$Y,$size,$size,0,360,$clr);
		#$img->stringFT($pink,$font,10,0,$X,$Y,$sample);
	}
	else
	{
		$img->char(gdGiantFont,$X,$Y,"X",$clr);
	}
	return ($X,$Y);
}



sub save_chart
{
	my $chart = shift or die "Need a chart!";
	my $name = shift or die "Need a name!";
	local(*OUT);

	open(OUT, ">$name.png") or die "Cannot open $name.$ext for write: $!";
	binmode OUT;
	print OUT $chart->png;
	close OUT;
}


sub X_position_setting
{
	my ($x,$margine,$length) = @_;
	my $half = $length/2;
	
	my $value = $half * abs($x);
	
	if( $x >= 0 )
	{
		return ( $margine+$half+$value );
	}
	else
	{
		return ( $margine+$half-$value );
	}
}

sub Y_position_setting
{
	my ($y,$margine,$length,$interval) = @_;
	return ($length - ($y * $interval) + $margine);
}



sub make_3_hash_custom
{
	my ($db_f,$fir_key,$sec_key,$thr_key,$value) = @_;
	
	my %db;
	open my $F, '<' , $db_f
	    or die "Cannnot read $db_f $!\n";
	
	while( <$F> )
	{
		chomp;
		my @pt = split /\t/;
		my ($fir,$sec,$thr) = @pt[$fir_key-1,$sec_key-1,$thr_key-1];
		$db{$fir}{$sec}{$thr} = $pt[$value-1];
	}
	close $F;
	
	return %db;
}
