 perl -e' map { $dex=pack "C*", $_; $hex=pack "H2", $_; print join "\t", $_, $dex, $hex, "\n" } 50..100 '
