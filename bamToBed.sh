#!/bin/sh
bamToBed -i $1 -split | cut -f1-3 > $1.bed
