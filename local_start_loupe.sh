#!/bin/bash

. ~/.bash_function
. ~/.minyoungrc

LOUPE=$(readlink -f $1)

if [ -f "$LOUPE" ];then

		LOUPE_DIR=$(dirname $LOUPE)
		echo "set LOUPE_DIR=$LOUPE_DIR"
		#export LOUPE_SERVER=/home/adminrig/workspace.min/10xGenomics/Alignment/CSP_NA12878_1/outs
		
		export LOUPE_SERVER=$LOUPE_DIR
		IP=$( ip route get 1.2.3.4 | head -1 | awk '{print $7}' )
		echo "connect to : http://$IP:3000/"
		
		# start loupe software on the local server
		$LOUPE_sh


else
		
		usage "loupe_path/loupe_file_name"

fi
