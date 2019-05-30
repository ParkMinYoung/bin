#!/bin/sh

. ~/.bash_function

if [ $# -ge 2 ] & [ -f "$2" ];
then

DIR=$1
shift


ls $@ | perl -MFile::Basename -nsle'
 ($f,$d) = fileparse( $_ );
 $dest_dir = "$created_dir/$d";

 print "mkdir -p $dest_dir" if !-d $dest_dir;
 print "ln \$(readlink -f $_) $dest_dir";
' -- -created_dir=$DIR | sh

else
	echo "NewProject A/A/A A/B/A A/C/A ..."
	usage "Created_Directory linked_file1 2 3 ..."
fi

