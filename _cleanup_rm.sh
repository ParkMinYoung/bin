#!/bin/bash

[[ -f "$1" ]] && parallel -j0 --bar rm -rf :::: $1

