#!/bin/sh

perl -MMin -MFile::Basename -ane'
chomp@F;
($f,$d)=fileparse($ARGV);
$h{$d}{$F[0]}=$F[1];
}{ mmfss("mapping.summary", %h)' `find | grep mapping.summary$`


perl -MMin -MFile::Basename -ane'
chomp@F;
($f,$d)=fileparse($ARGV);
$h{$d}{$F[0]}=$F[1];
}{ mmfss("seq.summary", %h)' `find | grep seq.summary$`

