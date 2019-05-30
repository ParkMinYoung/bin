for i in `qstat -f | awk '{print $1}' | grep -P "^\\d+" ` ; do echo -en "$i\t"; qstat -j $i | grep ^sge_o_workdir ; done

