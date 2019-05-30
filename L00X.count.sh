#!/bin/sh

find L00? -type f | cut -c1-4 | sort | uniq -c

