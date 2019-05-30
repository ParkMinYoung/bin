
dir=/usr/bin; for i in $(ls); do F="$dir/$i"; [[ -f "$F" ]] && echo "mv $F $F.v7.2;"; echo "ln -s $PWD/$i $dir"   ; done | sh

[[ $(( 4 % 3 )) -eq 1 ]] && echo 1

