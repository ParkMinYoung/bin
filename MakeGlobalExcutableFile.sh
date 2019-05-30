#!/bin/sh
find $PWD -maxdepth 1 -perm -a=x -type f | xargs -i ln -s {} ~/src/ProgramInstall/bin/
