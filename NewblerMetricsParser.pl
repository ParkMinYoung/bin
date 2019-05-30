#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE:  NewblerMetricsParser.pl
#
#        USAGE:  ./NewblerMetricsParser.pl  
#
#  DESCRIPTION:  NewblerMetrics filer parse
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Min Young Park (mn), minmin@dnalink.com
#      COMPANY:  DNALink.inc
#      VERSION:  1.0
#      CREATED:  11/03/09 15:06:35
#     REVISION:  ---
#===============================================================================

use strict;


use base qw();
BEGIN{;}


my %hash;

for my $file ( @ARGV )
{
	my	$F_file = $file;		# input file name
	my @title;

	open  my $F, '<', $F_file
	or die  "$0 : failed to open input file '$F_file' : $!\n";
	while ( <$F> ) 
	{
		chomp;
		my @F = split /\t/;

		if(/^\s*(\w+)$/)
		{
			push @title, $1;
		}
		elsif(/^}/)
		{
			@title=();
		}
		elsif(/}/)
		{
			pop @title;
		}
		elsif(/(\w+)\s+=\s+/)
		{
			$hash{ join ".", @title,$1 }{$file} = $';
		}
	}
	close  $F
	or warn "$0 : failed to close input file '$F_file' : $!\n";
	#################################################################################
}

make_matrix_file_new("NewblerMetricsParser.out",%hash);
sub make_matrix_file_new
{
	my ($file, %matrix) = @_;
	print "make matrix file --> $file.txt\n";
	
	#my @title = sort {$a cmp $b} keys @{ $M{ shift keys %matrix  } };
	
	my %titles;
	for my $i ( keys %matrix )
	{
		@titles{ keys %{ $matrix{$i} } } = undef;
	}

	my @title = sort {$a cmp $b} keys %titles;
	
	open my $W, '>' , "$file.txt"
	    or die "Cannot write file $file $!";
	
	print $W join("\t", "probeset_id",@title),"\n";

	foreach my $i ( sort {$a cmp $b} keys %matrix )
	{
		my @tmp;
		foreach my $j ( @title )
		{
			#print "$i	$j	$matrix{$i}{$j}\n";
			
			push @tmp, 
			defined $matrix{$i}{$j} ?
			$matrix{$i}{$j} :
			"NN";
		}
		print $W join("\t", $i, @tmp),"\n";
	}
	close $W;
}

`egrep "(^runData|^runMetrics|Genome|^consensusResults)" NewblerMetricsParser.out.txt  > NewblerMetricsParser.out.txt.summary`;

sub new
{
	my $class = shift;
	my $self = { @_ };
	bless $self, $class;
}


sub get_usage 
{
	exec('perldoc',$0);
}

__END__

=head1 NAME

=head1 SYNOPSIS

Usage : NewblerMetricsParser.pl NewblerMetrics.txt ... etc  



=head1 DESCRIPTION

./NewblerMetricsParser.pl  



=head1 OPTIONS
-
-
-
-
-


=head2 1.

=head2 2.

=head2 3.

=head2 4.

=head2 5.

=head1 EXSAMPLE

=head1 HISTORY

=cut



