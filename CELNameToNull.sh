CELName.sh  | perl -F'\t' -anle'$f=join "_", "Axiom_KORV1_1", @F[0,1]; /\w{3}$/; $f="$f.$&"; print "mv $F[3] $f"' | sh

