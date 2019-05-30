for i in + -
    do 
    for j in CG CHH CHG
        do 
        case "$i" in
        +) TYPE="plus";;
        -) TYPE="minus";;
        esac
        
		## methylation call > 0
        perl -F'\t' -anle' print if $F[3] > 0' $1 | grep -w $i | grep -w $j | perl -F'\t' -anle'splice @F,1, 0, $F[1]-1; print join "\t", @F[0..3, 6]' > $j-$TYPE.bed
    done
done

