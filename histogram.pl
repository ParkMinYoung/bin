use POSIX qw(ceil floor);

# No bugs, please
use strict;
use warnings;

# Perl doesn't have round, so let's implement it
sub round
{
    my($number) = shift;
    return int($number + .5 * ($number <=> 0));
}

sub histogram
{
  my ($bin_width, @list) = @_;

  # This calculates the frequencies for all available bins in the data set
  my %histogram;
  $histogram{ ceil(($_ + 1) / $bin_width) -1 }++ for @list;

  my $max;
  my $min;

  # Calculate min and max
  while ( my ($key, $value) = each(%histogram) )
  {
    $max = $key if !defined($min) || $key > $max;
    $min = $key if !defined($min) || $key < $min;
  }


  for (my $i = $min; $i <= $max; $i++)
  {
    my $bin       = sprintf("% 10d", ($i) * $bin_width);
    my $frequency = $histogram{$i} || 0;
	my $count = sprintf("% 10d", ($frequency) );


    $frequency = "#" x $frequency;

    print $bin." ".$count." ".$frequency."\n";
  }

  print "===============================\n\n";
  print "    Width: ".$bin_width."\n";
  print "    Range: ".$min."-".$max."\n\n";
}
