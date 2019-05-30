#use strict;
#use warnings;

#use Data::Dumper;


## 
# refFlat .. exon region . + . . start . + 1 . .... ... ....
# ex) s : 43331725
#     e : 
#     ..., e . ... ..., s .. ... 43331725 + 1 ...


# refFlat .. exon region . - . . end . + 1 . .... ... ....
# ex) s : 43456309
#     e : 43456090
#     ..., s . ... ..., e .. ... 43456090 + 1 ...


## strand . .... .. exon start + 1 . ... ... 
## cds start +1 . ... ...

## input file seq .. - . gene . - . .... .. ...
## position ... 1- 200 .... .. 200 -1 .. ...
## ... .. ... , $Header{Seq} .. ... ... ...
## forward .... .... ... complementary . .. ..
## reverse . . ...



#######################################################
############## S T A R T       L I N E ################
#######################################################

#@ARGV = "NM_080671.txt";


#1 NM_000598.fasta
##2 NM_000598.txt
##3 NM_000598.bed.snp
##

#@ARGV = qw/NM_000598.fasta NM_000598.txt NM_000598.bed.snp/;

die &Usage() unless @ARGV  == 3;

open my $F, "$ARGV[0]" or die "$!";
my $sequence = do { local $/; <$F> };
close $F;

#print $sequence;
#exit;


if ( $sequence )
{
	my $data        = &sequence_check( $sequence );
	my %Header      = &sequence_header($data);
#print Dumper(\%Header);
	
	my %GeneInfo    = &GetGeneInfo($ARGV[1], %Header);
#map { print join "\t", $_, $GeneInfo{$_},"\n" } sort keys %GeneInfo;
#print Dumper(\%GeneInfo);
	#<STDIN>;
	
	$Header{Gene}   = \%GeneInfo;
	
	my %marker      = &GetRS($ARGV[2]);
#print Dumper(\%marker);
#exit;

	$Header{Marker} = \%marker;
	%Header      = &GetSNPAnnotation(%Header);
	
	
	&DisplayFormatPlus(  50, %Header ) if $Header{Strand} eq "+";
	&DisplayFormatMinus( 50, %Header ) if $Header{Strand} eq "-";
	
	
	&MakeFile(%Header);
	#use Storable;
	#store(\%Header, 'data');
}


#######################################################
############## S E Q       L I N E ####################
#######################################################

sub MakeFile
{
	my %Header = @_;
	
	my $dir             = "SnpInformation";
	my $name            = $Header{"Gene"}->{Name};

	mkdir($dir) unless -e $dir;
	
	open my $W, ">$dir/$name.txt" or die $!;
	print $W "rs\tForwardGenotype\tPos\tclass\tDBregion\tStrand\tAnnotation\tPos\tGeneGenotype\tAAPos\tBasePos\tcodon\tAmino1\tAmino2\n";

	#my @list = sort grep {/^\d+/} keys %{$Header{Marker}};
	for my $loc ( sort grep {/^\d+/} keys %{$Header{Marker}} )
	{
		for my $marker ( @{$Header{Marker}{$loc}} )
		{
			#print "here : @{$marker}\n";
			$Header{Annotation}{$marker->[2]} = GetRegion($marker->[2],$marker->[1],$marker->[3],%Header);
			
			my @snp;
			#print "@{$Header{Annotation}{$marker->[2]}}\n";
			push @snp, @{$marker}, @{$Header{Annotation}{$marker->[2]}};

			if ( @snp ){
				print $W (join "\t", @snp),"\n";
			}
		}
	}
	close $W;
}

sub GetSNPAnnotation
{
	my %Header = @_;

	for my $loc ( sort {$a<=>$b} %{$Header{Marker}} )
	{
		for my $marker ( @{$Header{Marker}{$loc}} )
		{
			#print "there : @{$marker}\n";
			$Header{Annotation}{$marker->[2]} = GetRegion($marker->[2],$marker->[1],$marker->[3],%Header);
			#print "@{$result}\n";
		}
	}
	return %Header;
}

sub GetRegion
{
	my %aa2codon = AminoAcidCodon();
	my $loc    = shift;
	my $geno   = shift;
	my $class  = shift;
	my %Header = @_;
	
	#print ">>$loc,$geno,$class\n";
	my ($cds_s, $cds_e) = @{$Header{Gene}->{CdsRegion}};
	my @cds_exon_block  = @{$Header{Gene}->{CdsBlock}};
	
	## .. gene . cds exon . ... ., intron . .. . 
	## ... error ... .. ..
	my @cds_ivs_block = 
	defined $Header{Gene}->{IvsBlock} ?
	@{ $Header{Gene}->{IvsBlock} } :
	();
	#@cds_ivs_block =() if $Header{Gene}->{IvsBlock} == undef;
	
	#map {print "@{$_}\n" } @cds_ivs_block;
	#<STDIN>;
	
	my $cds_base_length = $Header{Gene}->{CdsBlockLen};
	
	### IS strand '-' ? --> must be reverse genotype, block 
	if( $Header{Strand} eq "-" )
	{
		$geno = complementary($geno) ;
		@cds_exon_block = reverse @cds_exon_block;
		@cds_ivs_block  = reverse @cds_ivs_block;
	}
	
	my $value;
	
	if   ( $loc < $cds_s ) # || $loc > $cds_e)
	{
		#print "UTR< $cds_s\n";
		#print "strand $Header{Strand}\n";
		if   ( $Header{Strand} eq "+" )
		{
			$value = "-".($cds_s - $loc).$geno;
			#print "+ utr5 : $loc,$geno,$class, [$value,$loc,$geno]\n";
			return [$value,$loc,$geno];
		}
		elsif( $Header{Strand} eq "-" )
		{
			$value = ($cds_base_length + $cds_s - $loc).$geno; 
			#print "- utr5 : $loc,$geno,$class, [$value,$loc,$geno]\n";
			return [$value,$loc,$geno];
		}
	}
	elsif( $loc > $cds_e )
	{
		#print "UTR>\n";
		if   ( $Header{Strand} eq "+" )
		{
			$value = ($cds_base_length + $loc - $cds_e).$geno;
			#print "+ utr3 : $loc,$geno,$class, [$value,$loc,$geno] $cds_base_length+$cds_e-$loc\n";
			return [$value,$loc,$geno];
		}
		elsif( $Header{Strand} eq "-" )
		{
			$value = "-".($loc -$cds_e).$geno; 
			#print "- utr3 : $loc,$geno,$class, [$value,$loc,$geno]\n";
			return [$value,$loc,$geno];
		}
	}
	else
	{
		#print "EXon\n";
		for ( @cds_exon_block )
		{
			#print "$_->[0] <= $loc && $_->[1] >= $loc\n";
			#print Dumper \%{$Header{Gene}->{Amino}};

			if( $_->[0] <= $loc && $_->[1] >= $loc )
			{
				#print "$_->[0] <= $loc && $_->[1] >= $loc\n";
				#print Dumper \%{$Header{Gene}->{Amino}};
				
				my ($AAPosition, $BasePosition,$codon) = @{$Header{Gene}->{Amino}{$loc}};
				my @AA;
				if( $class eq "single" )
				{
					for ( split /\//, $geno )
					{
						substr $codon,$BasePosition-1,1,$_ ;
						push @AA, $aa2codon{$codon};
					}
					
					$value = join $AAPosition, @AA;
				}
				else
				{
					$value = $AAPosition;
				}
				#print "exon : $loc,$geno,$class, [$value,$loc,$geno]\n";
				return [$value,$loc,$geno,$AAPosition, $BasePosition,$codon,@AA];
			}
		}
		
		my $IvsCnt;
		for ( @cds_ivs_block )
		{
			$IvsCnt++;
			#print "$_->[0] <= $loc && $_->[1] >= $loc\n";
			if( $_->[0] <= $loc && $_->[1] >= $loc )
			{
				my $left  = $loc - $_->[0] + 1;
				my $right = $_->[1] - $loc + 1;
				
				if   ( $Header{Strand} eq "+" )
				{
					$value = "IVS$IvsCnt"."+$left$geno";
					$value = "IVS$IvsCnt"."-$right$geno" if $left > $right;
				}
				elsif( $Header{Strand} eq "-" )
				{
					$value = "IVS$IvsCnt"."-$left$geno";
					$value = "IVS$IvsCnt"."+$right$geno" if $left > $right;
				}
				
				#print "intron : $loc,$geno,$class, [$value,$loc,$geno]\n";
				return [$value,$loc,$geno];
			}
		}
		
		#die "wyh\n";
		
	}
}

sub GetGeneInfo
{
	my $file        = shift;
	my %Header      = @_;
	my $ref         = $Header{"Ref ID"};
	
#my $query       = qq/Select gene,c_s,c_e,e_s,e_e from refFlat where ref='$ref'/;
	
	my @row;
	open my $F, $file or die "can not open $file\n";
	while(<$F>){
		if($.>1){
			my @F = split "\t", $_;
			@row = @F[1,6,7,9,10];
		}
	}
	close $F;
	
	### List Finded Marker
	my %gene;

		$gene{Name}      = $row[0]; 									## GeneName;
		$gene{CdsRegion} = [++$row[1],$row[2]];							## Gene cds region
		
		my @e_s = split ",", $row[3];								## Gene exon block start
		my @e_e = split ",", $row[4];								## Gene exon block end
		map { ++$_ } @e_s ;											## start position + 1
		
		$gene{ExonBlock} = [ map { [$e_s[$_], $e_e[$_]] } 0 .. $#e_s ];
		
		### region Cal ###
		my %region = ($row[1]=>1,$row[2]=>1);
		map { $region{$_}++ if $_ >= $row[1] and $_ <= $row[2] } sort {$a<=>$b} @e_s, @e_e;
		my @region = sort {$a<=>$b} keys %region;
		
		
		for ( 0 .. $#region-1 )
		{
			if ( $_ % 2 == 0 )
			{
				### reverse strand ... cds seq . ... .....
				### 
				
				push @{$gene{CdsBlock}}, [$region[$_], $region[$_+1]];
				my $distance        = $region[$_+1]-$region[$_]+1;
				$gene{CdsBlockLen} += $distance;
				my $cds_seq  = substr $Header{Seq}, $region[$_] - $Header{RegionStart}, $distance;
				$gene{CdsBlockSeq} .= $cds_seq;
				
				my $start = $region[$_];
				map { $gene{Base}{$start++} = $_ } split "", $cds_seq;
				
			}
			else
			{
				push @{$gene{IvsBlock}}, [$region[$_]+1, $region[$_+1]-1];
			}
		}
		
		my @loc = sort {$a<=>$b} keys %{$gene{Base}};
		@loc = reverse @loc if $Header{Strand} eq "-";
		
		my $AminoCnt;
		while(my @codon = splice @loc, 0, 3)
		{
			my $codon = "$gene{Base}{$codon[0]}$gene{Base}{$codon[1]}$gene{Base}{$codon[2]}";
			$AminoCnt++;
			map { $gene{Amino}{$codon[$_-1]} = [ $AminoCnt, $_, $codon ] } 1..3;
		}

	return %gene;
}

 ##sub GetGeneInfo_mssql
 ##{
 ##	my %Header      = @_;
 ##	my $ref         = $Header{"Ref ID"};
 ##	
 ##	my $dbh         = mssql_connect();
 ##	
 ##	### mssql . .. ... .. ... ###	
 ##	$dbh->{LongReadLen} = 20000000;
 ##	$dbh->{LongTruncOk} = 1;
 ##	my $query       = qq/Select gene,c_s,c_e,e_s,e_e from refFlat where ref='$ref'/;
 ##	
 ##	#print "$query\n";
 ##	
 ##	my $sth = DB_query($dbh,$query);
 ##	
 ##	### List Finded Marker
 ##	my %gene;
 ##	while(my @row = $sth -> fetchrow_array)
 ##	{
 ##		$gene{Name}      = $row[0]; 									## GeneName;
 ##		$gene{CdsRegion} = [++$row[1],$row[2]];							## Gene cds region
 ##		
 ##		my @e_s = split ",", $row[3];								## Gene exon block start
 ##		my @e_e = split ",", $row[4];								## Gene exon block end
 ##		map { ++$_ } @e_s ;											## start position + 1
 ##		
 ##		$gene{ExonBlock} = [ map { [$e_s[$_], $e_e[$_]] } 0 .. $#e_s ];
 ##		
 ##		### region Cal ###
 ##		my %region = ($row[1]=>1,$row[2]=>1);
 ##		map { $region{$_}++ if $_ >= $row[1] and $_ <= $row[2] } sort {$a<=>$b} @e_s, @e_e;
 ##		my @region = sort {$a<=>$b} keys %region;
 ##		
 ##		
 ##		for ( 0 .. $#region-1 )
 ##		{
 ##			if ( $_ % 2 == 0 )
 ##			{
 ##				### reverse strand ... cds seq . ... .....
 ##				### 
 ##				
 ##				push @{$gene{CdsBlock}}, [$region[$_], $region[$_+1]];
 ##				my $distance        = $region[$_+1]-$region[$_]+1;
 ##				$gene{CdsBlockLen} += $distance;
 ##				my $cds_seq  = substr $Header{Seq}, $region[$_] - $Header{RegionStart}, $distance;
 ##				$gene{CdsBlockSeq} .= $cds_seq;
 ##				
 ##				my $start = $region[$_];
 ##				map { $gene{Base}{$start++} = $_ } split "", $cds_seq;
 ##				
 ##			}
 ##			else
 ##			{
 ##				push @{$gene{IvsBlock}}, [$region[$_]+1, $region[$_+1]-1];
 ##			}
 ##		}
 ##		
 ##		my @loc = sort {$a<=>$b} keys %{$gene{Base}};
 ##		@loc = reverse @loc if $Header{Strand} eq "-";
 ##		
 ##		my $AminoCnt;
 ##		while(my @codon = splice @loc, 0, 3)
 ##		{
 ##			my $codon = "$gene{Base}{$codon[0]}$gene{Base}{$codon[1]}$gene{Base}{$codon[2]}";
 ##			$AminoCnt++;
 ##			map { $gene{Amino}{$codon[$_-1]} = [ $AminoCnt, $_, $codon ] } 1..3;
 ##		}
 ##	}
 ##	return %gene;
 ##}
 ##

sub GetRS
{
	my $file = $_[0];
	my %marker;	
	open my $F, $file or die "can not open $file\n";
	while(<$F>){
		my @F = split "\t", $_;
		my @row = @F[4,9,3,11,10,6];

		$row[5] =~ s/\s+//g;
		$row[1] = complementary($row[1]) if $row[5] eq "-" ;
		$row[4] = '-' unless $row[4];
		push @{$marker{$row[2]}}, [@row];
	}
	close $F;

	return %marker;
}

 ##sub GetRS_mssql
 ##{
 ##	my $dbh         = mssql_connect();
 ##	my $query       = 
 ##	qq/select rs, genotype, snp_e, class, region, strand from all_rs
 ##	where chr='$_[0]' and snp_s >= '$_[1]' and snp_e <= '$_[2]'/;
 ##	
 ##	print "query sql : $query\n";
 ##	
 ##	my $sth = DB_query($dbh,$query);
 ##	
 ##	### List Finded Marker
 ##	my %marker;
 ##	while(my @row = $sth -> fetchrow_array)
 ##	{
 ##		$row[5] =~ s/\s+//g;
 ##		$row[1] = complementary($row[1]) if $row[5] eq "-" ;
 ##		$row[4] = '-' unless $row[4];
 ##		push @{$marker{$row[2]}}, [@row];
 ##	}
 ##
 ##	#print Dumper \%marker;
 ##	return %marker;
 ##}
 ##

sub sequence_header
{
	my ($Header, $seq) = split /\n/, $_[0], 2;
	$seq =~ s/\s+|\n//g;
	
	my %Header;
	$Header{SeqLength} = length($seq);
	
	
	$Header =~ /(hg\d+)	   ## hg version
					(?{ $Header{"Version"}             = $^N })
	            _refGene
	            _(.+)\ ## ref ID
					(?{ $Header{"Ref ID"}              = $^N })
				range=(\w+):
				    (?{ $Header{"RegionChr"}           = $^N })
				(\d+)-
				    (?{ $Header{"RegionStart"}         = $^N })
				(\d+)\ 
					(?{ $Header{"RegionEnd"}           = $^N })
				5\'pad=\d+\ 
				3\'pad=\d+\ 
				strand=(-|\+)\ 
					(?{ $Header{"Strand"}              = $^N })
				repeatMasking=(\w+)
					(?{ $Header{"RepeatMasking"}       = $^N })
				/x;
	
	#map { print "$_ -> [$Header{$_}]\n" } sort keys %Header;
	
	map {print "$_ : [$Header{$_}]\n"}keys %Header;
	#<STDIN>;
	
	$Header{Seq} = $seq;
	$Header{Seq} = reverse $seq if $Header{Strand} eq "-";
	
	return %Header;
}


sub sequence_check
{
	if ($_[0] =~ />/)
	{
		return $';
	}
	else
	{
		die "Check The Sequence File\n";
	}
}


sub DisplayFormatMinus
{
	my ($size, %Header) = @_;
	my $seq             = reverse $Header{"Seq"};
	my $end             = $Header{"RegionEnd"};
	
	my $GeneName        =   $Header{"Gene"}->{Name}; 				## ref id
	my @cds             = @{$Header{"Gene"}->{CdsRegion}};
	my @exon            = reverse @{$Header{"Gene"}->{ExonBlock}};
	
	
	my $dir             = "display";
	mkdir($dir) unless -e $dir;
	
	
	my @title = ('Version', 'Ref ID', 'RegionChr', 'RegionStart', 'RegionEnd', 'Strand');
	
	my $ref = $GeneName;
	my $genename = $Header{'Ref ID'};
	$Header{'Ref ID'} = $ref;
	
	open my $W,">$dir/$ref.txt" or die "$!";
	print $W "GeneName	$genename\n";
	print $W "CDS	@cds\n";
	map { print $W "$_	$Header{$_}\n" } @title;
	while(my $str = substr($seq,0,$size,""))
	{
		my $temp = $end-$size;
		my @annotation;
		
		for my $loc ( $temp+1 .. $end )
		{
			for ( @{$Header{Marker}{$loc}} )
			{
				my ( $rs, $geno, $loc, $class, $region ) = @{$_};
				$geno =~ tr/ACGTacgtRYMKWSHDBV/TGCAtgcaYRKMWSDHVB/;
				$geno = join "/", sort (split /\//, $geno);
				
				if( $class eq "single" )
				{
					my $iupac = IUPAC( $geno ) ;
					substr($str, $size - ($loc-($temp)), 1, $iupac);
					push @annotation, "$rs,$geno,$Header{Annotation}->{$loc}->[0]";
				}
				else
				{
					push @annotation, "$rs,$geno,$loc,$class,$Header{Annotation}->{$loc}->[0]";
				}
			}
		}
		
		########### EXON and CDS ##############
		
		for my $block ( 0 .. $#exon )
		{
			if( $temp < $exon[$block]->[1] && $end >= $exon[$block]->[1] )
			{
				print $W "[EXON ",$block+1,"] : $exon[$block]->[0] - $exon[$block]->[1]\n";
			}
		}
		
		########### EXON and CDS ##############
		
		my $line = sprintf "%-12d %-${size}s %12d", $end, $str, $end - (length $str) + 1 ;
		print $W "$line\n";
		
		@annotation = reverse @annotation;
		
		while( my @temp = splice @annotation,0,1 )
		{
			my $anno = sprintf "%-14s %-${size}s %10s", " ", (join "\t", @temp), " ";
			print $W "$anno\n";
		}
	
		$end=$temp;
	}
	close $W;
}

sub DisplayFormatPlus
{
	my ($size, %Header) = @_;
	my $seq             = $Header{"Seq"};
	my $start           = $Header{"RegionStart"};
	
	my $GeneName        =   $Header{"Gene"}->{Name};
	my @cds             = @{$Header{"Gene"}->{CdsRegion}};
	my @exon            = @{$Header{"Gene"}->{ExonBlock}};
	
	
	my $dir             = "display";
	mkdir($dir) unless -e $dir;
	
	my @title = ('Version', 'Ref ID', 'RegionChr', 'RegionStart', 'RegionEnd', 'Strand');

	my $ref = $GeneName;
    my $genename = $Header{'Ref ID'};
	$Header{'Ref ID'} = $ref;

    open my $W,">$dir/$ref.txt" or die "$!";
    print $W "GeneName  $genename\n";
	print $W "CDS	@cds\n";
	map { print $W "$_	$Header{$_}\n" } @title;
	while(my $str = substr($seq,0,$size,""))
	{
		my $temp = $start+$size;
		my @annotation;
		
		for my $loc ( $start .. $temp-1 )
		{
			for ( @{$Header{Marker}{$loc}} )
			{
				my ( $rs, $geno, $loc, $class, $region ) = @{$_};
				
				if( $class eq "single" )
				{
					my $iupac = IUPAC( $geno );
					substr($str, $loc-$start, 1, $iupac);
					push @annotation, "$rs,$geno,$Header{Annotation}->{$loc}->[0]";
					
				}
				else
				{
					push @annotation, "$rs,$geno,$loc,$class,$Header{Annotation}->{$loc}->[0]";
				}
			}
		}
		
		########### EXON and CDS ##############
		
		for my $block ( 0 .. $#exon )
		{
			if( $start <= $exon[$block]->[0] && $temp > $exon[$block]->[0] )
			{
				#print "[EXON ",$block+1,"] : ",$exon[$block]->[0],"\n";
				print $W "[EXON ",$block+1,"] : $exon[$block]->[0] - $exon[$block]->[1]\n";
			}
		}
		
		########### EXON and CDS ##############
		
		my $line = sprintf "%-12d %-${size}s %12d", $start, $str, $start + (length $str) - 1 ;
		print $W "$line\n";
		
		while( my @temp = splice @annotation,0,1 )
		{
			my $anno = sprintf "%-14s %-${size}s %10s", " ", (join "\t", @temp), " ";
			print $W "$anno\n";
		}
	
		$start=$temp;
	}
	close $W;
}



#######################################################
############## E N D       L I N E ####################
#######################################################
	  

	
sub SAPLE_DATA
{
	my $sample = 
"
##################################################
##################### SAMPLE #####################
##################################################

>hg19_refGene_NM_004212 range=chr15:43329526-43355625 5'pad=0 3'pad=0 strand=+ repeatMasking=none
atacaaaaagatataagatacatgtataagatagaatgagcaagagacac
ttcacagtcatattgacatataggacaacagcttgaaaatatctgtaagc
aggttcactttcaacactggtgtcttattttcctgaattaatataagatc
ttacaacagtgctccacaattgcaaagtcatgtaatatttttccaagttc
tttcttctgtattaaattacttaattttcatgataatcttatgagatagg
attaggcagggtgggaaagatggaagaggcccagaaaggtaaagtgagtt
gctctcgatccagaatacaacacacatctactctgtgagggattctgtgt";
	return $sample;
}



sub Usage
{
	my $sample = SAPLE_DATA();
	my $usage  =  
	
"



Desc : $0 [ sequece file ]
	
## sequence file format
	
$sample
	
	
	
";

	return $usage;
}




 ##sub mssql_connect
 ##{
 ##	######### DBN DB MSSQL Connect ############
 ##	######## database .. 
 ##	my $DSN = 'driver={SQL Server};Server=YEON;database=rs_db;uid=sa;pwd=dna@link;';
 ##	#my $dbh  = DBI->connect("dbi:ODBC:$DSN") or die "$DBI::errstr\n";
 ##	#return $dbh;
 ##	
 ##	
 ##}

sub DB_query
{
	my ($dbh,$qry) = @_;
	my $sth = $dbh->prepare($qry);
	$sth->execute();
	return $sth;
}

sub IUPAC
{
	my $sort_input =  join "", (sort split /\//,$_[0]);
	my %iupac = (AG => "R", CT => "Y", AC=>"M", GT =>"K", AT =>"W", CG =>"S", CGT =>"B", AGT=>"D",ACT=>"H",ACG=>"V",ACGT=>"N");
	return $iupac{$sort_input} if $iupac{$sort_input};
	return "X";
}

sub complementary
{
	my $seq = shift;
	$seq =~ tr/ACGTacgtRYMKWSHDBV/TGCAtgcaYRKMWSDHVB/;
	$seq = join "/", sort split /\//, $seq;
	if( $seq =~ /[\[|\]]/ ){ $seq =~ tr/\[\]/\]\[/; }
	return ($seq);
}


sub AminoAcidCodon
{
	my %codon;
	map { $codon{$_} = "A" } qw/GCT GCC GCA GCG/;
	map { $codon{$_} = "L" } qw/TTA TTG CTT CTC CTA CTG/;
	map { $codon{$_} = "R" } qw/CGT CGC CGA CGG AGA AGG/;
	map { $codon{$_} = "K" } qw/AAA AAG/;
	map { $codon{$_} = "N" } qw/AAT AAC/;
	map { $codon{$_} = "M" } qw/ATG/;
	map { $codon{$_} = "D" } qw/GAT GAC/;
	map { $codon{$_} = "F" } qw/TTT TTC/;
	map { $codon{$_} = "C" } qw/TGT TGC/;
	map { $codon{$_} = "P" } qw/CCT CCC CCA CCG/;
	map { $codon{$_} = "Q" } qw/CAA CAG/;
	map { $codon{$_} = "S" } qw/TCT TCC TCA TCG AGT AGC/;
	map { $codon{$_} = "E" } qw/GAA GAG/;
	map { $codon{$_} = "T" } qw/ACT ACC ACA ACG/;
	map { $codon{$_} = "G" } qw/GGT GGC GGA GGG/;
	map { $codon{$_} = "W" } qw/TGG/;
	map { $codon{$_} = "H" } qw/CAT CAC/;
	map { $codon{$_} = "Y" } qw/TAT TAC/;
	map { $codon{$_} = "I" } qw/ATT ATC ATA/;
	map { $codon{$_} = "V" } qw/GTT GTC GTA GTG/;
	map { $codon{$_} = "*" } qw/TAG TGA TAA/;
	return %codon;
}
