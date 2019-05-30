#!/bin/sh
 ls -l ~/src/ProgramInstall/bin/ | grep BED | awk '{print $11}' | xargs -i basename {} | sort
