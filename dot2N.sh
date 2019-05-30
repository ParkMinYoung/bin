#!/bin/sh
perl -i.bak -ple's/\./N/g if $.%4-2==0' $1
