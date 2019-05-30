
find $1  | grep -e Read -e sanger -e bam -e Target | xargs rm -rf

# delete file included "Read, sanger bam" words

find $1 -type l | xargs rm -rf

# delete symbolic file

rmdir $1/single

# delete s_?/single dir


