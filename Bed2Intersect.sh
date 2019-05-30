#!/bin/sh

ls $@ | perl -nle'push @file, $_}{ $fir = shift @file, $sec=shift @file; $line .= "intersectBed -a $fir -b $sec "; map { $line .= "| intersectBed -a stdin -b $_ " } @file; print "$line > intersect.bed"' | sh
# ls $@ | perl -nle'push @file, $_}{ $fir = shift @file, $sec=shift @file; $line .= "intersectBed -a $fir -b $sec "; map { $line .= "| intersectBed -a stdin -b $_ " } @file; print "$line > intersect.bed"'
