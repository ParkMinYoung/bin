 paste <(zcat $1 | sed -n '1~4'p) <(zcat $2 | sed -n '1~4'p) | tr "\t" " " | cut -d" "  -f1,3 | while  read A B; do   [ $A != $B ] && echo "$LINENO $A $B"  ; done

