 ls | perl -nle'/s_\d/;push @{$h{$&}},$_ if $& }{ map{ mkdir $_;  `mv @{$h{$_}} $_` } sort keys %h'
