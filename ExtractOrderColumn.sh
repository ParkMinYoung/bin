
#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

                perl -F'\t' -anle'
                BEGIN{
                        $c=0;
                }
                if(@ARGV){
                        $h{$F[0]}=$c++;
						$Old2New{ $F[0] } = $F[1] || $F[0];
                }else{
                        if(++$l==1){
							map { $id2idx{$F[$_]} = $_ } 0..$#F;
							@col_id = sort { $h{$a} <=> $h{$b} } keys %h;
							#print "col_id : @col_id";
							@idx = @id2idx{@col_id};
							#print join "\t", @idx;
							#print "idx : @idx";
							@header = @F[@idx];
							#print "header : @header";

							print join "\t", @Old2New{ @header };

							next;
                        }

						print join "\t", @F[@idx];
                }' $1 $2
                #header CCP.filter.h.vcf.num | less
else
                usage "Extracteded_Column_File Target_File"
fi
