mv $1.num $1.num.original
ExtractOrderColumn.sh header.reorder $1.num.original > $1.num



                perl -F'\t' -anle'
                BEGIN{
                                                $h{"0/0"}=-1;
                                                $h{"0/1"}=0;
                                                $h{"1/1"}=1;
                                                $h{"./."}=-2;
                                                $h{"."}=-2
                }
                @data = @F[6..$#F];
                if($.==1){
                                print join "\t", "Pos", @data
                }else{
                                @num_geno = map { defined $h{$_} ? $h{$_} : -2 } @data;

                                %geno = ();
                                map { $geno{$_}++ } @num_geno;
                                next if ( keys %geno )+0 == 1;
                                #print join "\t", "$F[0]_$F[1]_$F[5]", @num_geno;
                                print join "\t", "$F[0]_$F[1]_$F[5]_".$., @num_geno;
                } ' $1.num > $1.num.score

                grep -v "\-2" -w $1.num.score  > $1.num.score.call
                R CMD BATCH --no-save --no-restore "--args $1.num.score $1.num.score.call" ~/src/short_read_assembly/bin/R/Genotype2Heatmap.R




