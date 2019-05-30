package Min;
use Exporter;
use File::Glob;
use File::Basename;
use Tie::File;
use List::Util qw(first max maxstr min minstr reduce shuffle sum);
use Carp;
use POSIX qw(ceil floor);

@ISA = qw( Exporter );

@EXPORT = qw(
  average
  Stdev
  max_num
  min_num
  select_col_rm_redun
  array_redun_rm
  compare_A_and_B_file
  factorial
  Upcase
  file_concatenate
  file_divide_line_num
  redun_line_rm
  selected_col_make_key_for_group
  select_col_list_count
  diff_array_a
  common_array
  convert_file_format
  extract_key_cmp
  extract_key_num
  input_file_and_col
  input_file_and_col_default
  file_3_extract_info
  rm_end_blank
  A_cols_B_cols_output
  read_msg
  sum
  round_off
  rm_start_blank
  msg
  Seq
  File2Array
  File2hash
  Foreach_hash
  Foreach_array
  e
  make_dir
  getfilename
  Fasta_divide
  copy_file
  copy_file_FromTo
  rm_end_input
  File_want_col_sort
  Show_File
  get_time
  get_time_detail
  Array2Hash
  log_base
  Array_div_odd_even_index
  Array_div_odd_even_element
  cal_linker_length
  Array_start_double_howmany_tab
  seq2fasta_form
  Write_file
  calculate_promoter_between_gene
  confirm_2
  confirm_3
  show_array
  comma_count
  change_xy
  Key_value
  getFileExtension
  make_hash_from_file
  Chage
  read_matrix
  read_matrix_x
  make_col_function
  hash_tab_limited
  hash_tab_limited_cnt
  extract_want_col_from_f
  Merge
  Merge_custom
  fasta_f_read
  Extract_flanking_seq
  Input_STDIN_f
  Input_STDIN_t
  complementary
  trim_space
  IUPAC
  iupac2geno
  iupac2genotype
  fasta2hash
  mssql_connect
  divide_size
  show_column_sample_from_file
  csv_file_handle_key_value
  Foreach_hash2file
  make_2_hash
  make_2_hash_cnt
  make_3_hash
  make_array_with_delimit
  confirm_2_file
  confirm_3_file
  make_matrix_file
  make_matrix_file_new
  mmfss_ctitle
  mmfss_n
  mmfss
  mmfss_print
  mmfss_header
  mmfss_1
  mmfss_dot
  mmfss_blank
  mmfss_space2
  mmfns
  mmfsn
  mmfnn
  h2r
  sam_count_delimit_coma
  make_reverse_hash
  make_call_matrix
  File_line_check
  csv2txt
  show_array_array
  select_col_id_cnt
  select_two_col_id_cnt
  key_cnt
  select_col_count
  get_name
  matrix_call_num2AB
  sample_random_selection
  get_string_from_seq
  dp_f_info
  perl_script
  remote_test
  get_element
  convert_line
  Array2File
  compare_two_matrix
  read_matrix_qurated
  read_matrix_only_fail
  matrix_call_correction
  matrix2flat
  confirm_array_array
  txt2xls
  confirm_2_file_line
  show_file_list
  make_removed_col_file
  get_count_from_interval
  get_count_between
  Find_file_from_list
  mv_png
  get_filename_from_path
  make_own_dir
  HugeMatrixTransform
  Is_DefaultFile
  show_hash_array
  hash_tab_limited_linux
  h
  WriteMatrixToFile
  ReadMatrixToArray
  read_matrix_list_col_sum
  read_matrix_list_row_sum
  h1c
  h1n
  v1n
  v1np
  v1n2f
  hist
  histf
  histogram
  histogram_tab
  celname
  celname_substitute_id
  get_date
  ToHash
  snpeff3_6 
  timediff
  Month2Num
  ThisYear
  ThreeMonthStr_Day2YMD
  geno2chisqure
  geno2prob
  VCF2BED_0
  VCF2BED_1
  aa_hash
  snpsift_anno_string_to_4Class
  oncotator_anno_string_to_4Class
  show_hash
  show_hash2
  show_matrix
  convert_hash2_to_hash1_by_delim
  Alt_Freq
  percent
  round
  GenoMatchType
  GenoMatchType_detail
  random
  DMR_make_cov_file
  fastq2id
  args2list
  read_matrix_list_num
  read_matrix_list_string
  isSNVType
  );

# #         			 max						### �ִ�
# #          			 min 						### �ּ�
# #          			 average 					### ���
# #          			 max_num 					### �迭�� ���°�� �ִ�
# # 	 			 min_num					### �迭�� ���°�� �ּ�
# #          			 select_col_rm_redun 				### �ش� ���ϰ� �÷��� ��ȣ�� �޾Ƽ� �ش� �÷��� ����Ʈ�� �ߺ����� ������.
# #          			 array_redun_rm 				### �迭�� �ߺ� ����
# #          			 compare_A_and_B_file				### �ΰ��� ������ �޾Ƽ� ���� �÷��� �������� �ߺ�, unique ���ؼ� �ɼǼ������� ���� ����
# #          			 factorial					### �Էµ� ������ factorial �� ���Ѵ�.
# # 				 upcase						### ���� ���� ���ڸ� ������ �빮��ȭ
# #          			 file_concatenate				### �������� ������ �ϳ��� ����ȭ
# #          			 file_divide_line_num				### �ϳ��� ������ �Է� ������ ����
# #          			 redun_line_rm					### �Էµ� ������ ���� �ߺ��� ����
# #          			 selected_col_make_key_for_group 		### �Էµ� ���Ͽ��� �Էµ� �÷� ����Ʈ�� ���ؼ� �ߺ����� �����ϰ�, ������ �μ� �÷��� ����Ʈȭ
# #          			 select_col_list_count				### �Էµ� ���Ͽ��� ���õ� �÷��� �� ����Ʈ ����
# #          			 diff_array_a					### �ΰ��� �迭 ���۷����� �޾Ƽ� ù ��° �迭������ �����ϴ� ����Ʈ ��ȯ
# #          			 common_array					### �ΰ��� �迭 ���۷����� �޾Ƽ� ����� ����Ʈ ��ȯ
# # 				 convert_file_format				### �Էµ� ������ �÷� �迭�� ����ڿ� ���� �� ����
# #          			 extract_key					### �ؽ��� ref �޾Ƽ� �ش� Ű�� �迭�� ����

# #          			 file_3_extract_info				### mother : 6���� �ʼ� �μ�, 1,3,6 : ���ϸ�
# #          			 input_file_and_col				### 2,4,6 ���� Ŀ���� ��� �÷� ����
# #          			 input_file_and_col_default			### ���ϰ� Ŀ���� �μ��� ������ 3���� �ؽ� ����
# #          			 rm_end_blank					### �迭�� �ް� �ش� ���ڵ��� ������ �� ���� ����
# #          			 A_cols_B_cols_output				### A ���Ͽ��� �÷� ����Ʈ�� ����, B ���Ͽ��� �׿� �ش��ϴ� �÷��� �����ϰ�, ������ �μ��μ� ��� �÷� ����Ʈ�� �ִ´�.
# #          			 read_msg					### message
# #          			 sum						### sum
# #          			 round_off					### �ݿø� (����, �ڸ���)
# #          			 rm_start_blank					### �迭�� �ް� �ش� ���ڵ��� ù ���� ���� ����
# #          			 msg						### messag (file, read or write)
# #          			 Seq						### ���ϴ� ������ ������ �����
# #          			 File2Array					### To Save the Array contents of File
# #          			 File2hash					### �μ�(file, key column, value column) return hash
# #          			 Foreach					### ��� Ȯ���� ���� ��� hash
# #          			 Foreach_array					### ��� Ȯ���� ���� ��� array
# #           			 e						### ��� Ȯ��
# #          			 make_dir					### �μ�(�����̸�)
# #          			 Fasta_divide					### �μ�(file, ���ϴ� �� ����, �ش� ����) �� ���� ������
# #          			 copy_file					### �μ�(file, ���μ�)
# #          			 copy_file_FromTo				### �μ�(file, start line num, end line num, filename)
# #          			 rm_end_input					### �μ�(target scala, pattern)
# #          			 File_want_col_sort				### �μ�(file, col) => ���ĵ��� ���� ���� ���ϴ� col �� ����
# #          			 Show_File					### �μ�(path, filename) �ش� ���Ͽ� ���� ���� �����ֱ�
# #           			 get_time					### �ð�
# #           			 get_time_detail					### �ð� detail
# #           			 get_cpu_time					### ���� �ð�
# #           			 Array2Hash					### array �� hash �� ����� ����
# #           			 log_base					### ���� 10 �̰� ����� 100 �ΰ� log_base(100,10) == 2
# #          			 Array_div_odd_even_index			### �μ�(array) index ��ȣ�� Ȧ���� ����� ����� �ΰ��� array ���۷��� ����
# #          			 Array_div_odd_even_element			### �μ�(array) element�� Ȧ���� ����� ����� �ΰ��� array ���۷��� ����
# #          			 cal_linker_length				### �μ�(�ΰ��� �迭 ���ݷ���) �տ��� ����, �ڿ��� �� ������ ���� ���̸� �迭�� ����
# #          			 Array_start_double_howmany_tab			### �μ�(�����ϱ���ϴ� ��ġ���,�׷����� ���� ���ϴ¿�� ����, ���迭)
# #          			 seq2fasta_form					### �μ�(������ ������ �迭)
# #          			 Write_file					### �μ�(������������ ��Į��, �����̸�)
# #          			 calculate_promoter_between_gene		### �μ�(A gene promoter start,A end, B start, B end) �ΰ��� ��ġ�� ���� ����
# #          			 confirm_2					### �μ�( �˰��� �ϴ� �ؽ�) �̰��� ������ 2���� �ؽ�
# #          			 confirm_3					### �μ�( �˰��� �ϴ� �ؽ�) �̰��� ������ 3���� �ؽ�
# #          			 show_array					### �μ�( �˰��� �ϴ� ���߹迭) ������ 2���� �迭
# # 				 comma_count					### �μ�( �޸��� ���е� ����Ʈ ����)
# #          			 change_xy					### �μ�( ����,��������̸�) ������ �÷��� �ο츦 �ٲ��ش�.
# #          			 Key_value					### �μ�( ����, �ϳ��� �÷�, �ϳ��� ��) �ؽ� ����
# #          			 getFileExtension 				### �μ�( ���� ) �ش� ������ Ȯ���� ����
# #          			 make_hash_from_file				### �μ�( ���� ) ������ ������ �ؽ�ȭ �ؼ� ����
# #				 Chage						### �μ�( ���� )
# #				 getfilename					### �μ�( �����̸� ) �̸��� ����
# #          			 read_matrix					### �μ�( �����̸�) ��Ʈ������ �ؽ� ����
# # 				 make_col_function				### hash_tab_limited ���� ���
# # 				 hash_tab_limited				### �μ�( �����̸�, Ű �÷�, ���÷� )
# # 				 hash_tab_limited_cnt				### �μ�( �����̸�, Ű �÷�) return couting hash
# # 				 extract_want_col_from_f			### �μ�( �����̸�, �����ϰ� ���� �÷� ����Ʈ)
# # 				 Merge						### �μ�( title line(num), ������̸�, merge �� ���� ����Ʈ)
# # 				 Merge_custom					### �μ�( dir �̸�, title line(num), ����)		ù ������ ��常 �����´�
# # 				 DB_query					### �μ�( $dbh(����),$query(query ��))
# # 				 fasta_f_read					### �μ�( $file ) �ϳ��� ������ ������ ����
# # 				 Input_STDIN_f					### �μ�(message) file return
# # 				 Input_STDIN_t					### �μ�(message) text return
# # 				 complementary					### �μ�(����) �������� �مR ���� ����
# # 				 trim_space					### �μ�($)������ ���� ����
# # 				 IUPAC						### �μ�(a/g) snp �޾Ƽ� iupac code �� ��ȯ
# # 				 fasta2hash					### �μ�(����) �������� ������ ���� �Ľ�Ÿ ������ Ű:�̸� ��:seq �� �ؽ�����
# # 				 mssql_connect					### mssql �� ����
# # 				 DB_query					### �μ�($dbh,Ŀ��) ��� ����
# # 				 divide_size					### �μ�($, size) ������� �߸� ������ �迭����
# # 				 show_column_sample_from_file			### �μ�(����, ������) ������ �ӽ÷� �����ش�
# # 				 csv_file_handle_key_value			### �μ�(csv ����, Ű,��,�ɼ�) �ɼ� 1--> ���� ����� ������ �ؽ� ����
# # 				 Foreach_hash2file				### �μ� (�����̸�,hash(1)) hash -> ���Ϸ� �����
# # 				 make_2_hash					### %db = make_db_hash(����,ùŰ"2",�ι�°Ű"4,5",value"1") �ؽ�����
# # 				 make_2_hash_cnt				### %db = make_db_hash(����,ùŰ"2",�ι�°Ű"4,5") counting �ؽ�����
# # 				 make_3_hash					### %db = make_db_hash(����,ùŰ"2",�ι�°Ű"4,5",����°Ű"6,7",value"1") �ؽ�����  option = 'all' �� ���� ��ü�� ������ ����
# # 				 make_array_with_delimit			### �μ�($,delimit ����)  ex ("a-b-c","-") ���� �迭
# # 				 confirm_2_file					### �μ�(�����̸�,%) �ΰ�Ű ���� �ؽ��� ���Ϸ�
# #  				 confirm_3_file					### �μ�(�����̸�,%) ����Ű ���� �ؽ��� ���Ϸ�
# # 				 make_matrix_file				### �μ�(title hash, file name, matrix data hash) ���� ����
# # 				 make_matrix_file_new				### �μ�(�����̸�, matrix hash)
# # 				 sam_count_delimit_coma				### �μ�(%) �ؽ��� ��ü ������ ','�� ���еǴµ� �̵��� ����(������ ����)�� ����
# # 				 make_reverse_hash				### �μ�(%) Ű=Ư���̸�, ��=(num)������ ������� �Ͽ� key=num(����), ��=Ư�� �̸��� �ٲپ��ش�.
# #				 make_call_matrix				### �μ�(����,snpid column, sample column, call column) �ؽ� ����
# # 				 File_line_check				### �μ�(����) ������ ���� ���� �����ش�
# # 				 csv2txt					### �μ�(����) csv ���� --> txt ���Ϸ� ��ȯ
# # 				 show_array_array				### �μ�(array �� array)
# # 				 select_col_id_cnt				### �μ�(����,�÷�����Ʈ) ���õ� �÷����� ���� string �� ��� �������� ���ϰ� hash ����
# # 				 select_two_col_id_cnt				### �μ�(����,fir key list, sec key list) ���� and hash ����
# # 				 key_cnt					### �μ�(%) print key ����
# # 				 select_col_count				### �μ�(����, �÷� ��ġ) �ش� �÷��� ���̵��� unique ī��Ʈ
# # 				 get_name					### �μ�(����) �ش� ������ �̸� ����
# # 				 matrix_call_num2AB				### �μ�(matrix ����, ���ο��������̸�)
# # 				 sample_random_selection			### �μ�(���� ����, @����Ʈ) $ return
# # 				 get_string_from_seq				### �μ�($seq, $window_size, $sliding_size,$start,$end,$��Ŀ) �Ľ�Ÿ $ ����
# # 				 dp_f_info					### �μ�($file, skip line)
# # 				 perl_script					### perl scipt information
# # 				 remote_test					### �μ�(ip,timeout-num)
# # 				 get_element					### �μ�($,������,����� number) ���� �ش� �����ڰ� Ư�������̸� \ �� �ٿ��ش�
# # 				 convert_line					### �μ�(@�ٲ� ǥ������ �����(["",""],["",""]),@string)
# # 				 Array2File					### �μ�(@, �����̸�)
# # 				 matrix_call_correction				### �μ�(������ �κ��� ������ ����, ��ü ��Ʈ���� ����)
# # 				 compare_two_matrix				### �μ�(����,����) �ΰ��� ������ ��Ʈ���� �����̿��� �Ѵ�. �ٸ� ������ ���� ���� ���Ϸ� ����
# # 				 read_matrix_qurated				### �μ�(����, �ؽ����۷���) ��Ʈ���� ����, ���������� �ؽ��� ���۷���, �ؽ� ����
# # 				 read_matrix_only_fail				### �μ�(����) ���� �̻��� ��Ʈ���� ���Ͽ��� hetero call 1 �� �����ؼ� �ؽ� ����
# # 				 matrix2flat					### ��Ʈ���� ������ sample marker call ���·� �ٲ� Ÿ��Ʋ�� ��Ŀ�� �μ�(����)
# # 				 confirm_array_array				### �μ� @[][] �� Ȯ���ϱ� ���� ��
# # 				 txt2xls					### �μ�(txt file, xls file) Ȯ���ڸ� �� ���ش�.
# # 				 confirm_2_file_line				### �μ�(��������̸�, title reference array, hash) ���� ����
# # 				 show_file_list					### �μ�( ����Ʈ )
# # 				 make_removed_col_file				### �μ�(����,�÷�����Ʈ) �ش� �÷��� ���ŵ� ���� �ۼ�
# # 				 get_count_from_interval			### �μ�(
# # 				 get_count_between				### �μ�
# # 				 Find_file_from_list				### �μ�(ã�� ���� ����Ʈ ref, ���� ����Ʈ ref)
# # 				 mv_png						### �μ�(ã�� ���� ����Ʈ ref, ���� ����Ʈ ref)
# # 				 get_filename_from_path				### �μ�(��ü��θ� ���� ���ϸ���Ʈ ����);
# # 				 make_own_dir					### �μ� ����. �ش� �����̸� ����
# # 				 HugeMatrixTransform				### �μ�(transformed(created) file name, read file name)
# # 				 Is_DefaultFile					### �μ�(defaulted file name)
# # 				 show_hash_array				### �μ�( hash array )

sub average {
    my $total;
    my (@list) = @_;
    foreach my $sum (@list) {
        $total += $sum;
    }

    #print "$total/($#_+1)";
    return $total / ( $#_ + 1 );
}

sub Stdev {
    my ( $avg, @list ) = @_;
    my $sum;
    foreach my $value (@list) {
        $sum += ( $value - $avg )**2;
    }
    return $sum / ( $#list + 1 );
}

sub max_num    ## �迭���� ���� �ִ밪�� ��������� �˼� ����.
{
    my ( $max, @array ) = @_;
    my $cnt++;
    my $max_num = $cnt;

    foreach my $i (@array) {
        $cnt++;
        if ( $max < $i ) {
            $max_num = $cnt;
            $max     = $i;
        }
    }

    return ( $max, $max_num );
}

sub min_num    ## �迭���� ���� �ִ밪�� ��������� �˼� ����.
{
    my ( $min, @array ) = @_;
    my $cnt++;
    my $min_num = $cnt;

    foreach my $i (@array) {
        $cnt++;
        if ( $min > $i ) {
            $min_num = $cnt;
            $min     = $i;
        }
    }

    return ( $min, $min_num );
}

## �ش� ���ϰ� �÷��� ��ȣ�� �޾Ƽ� �ش� �÷��� ����Ʈ�� �ߺ����� ������.
sub select_col_rm_redun {
    print "start col 1 ����\n�����ڴ� ','\n";

    my ( $file, $col_num ) = @_;
    $col_num--;

    open( F, $file )           || die "$!";
    open( W, ">output-$file" ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;
        my $target = $pt[$col_num];

        my %hash = ();
        my @tmp = split ",", $target;
        foreach my $i (@tmp) {
            $hash{$i}++;
        }

        $replace = join ",", keys %hash;

        $l =~ s/$target/$replace/;

        print W "$l\n";
    }
}

## �迭�� �ߺ� ����
sub array_redun_rm {
    my @array = @_;
    my %hash;

    foreach my $i (@array) {
        $hash{$i}++;
    }
    @array = sort ( keys %hash );
    return (@array);
}

sub compare_A_and_B_file {
    print
"���� A �� B�� ���մϴ�. �̴� A �� B �� �÷��� ���������μ� ���� �÷��� �������� �����հ� ������ ������ Ȯ�� �����ϰ� ���� ������ �μ��� �����ϸ� �׷��� �����͸� ���Ϸ� �����. ���� �뷮�� ������ ������ ����\n";
    my ( $file_A, $col_A, $file_B, $col_B, $file_flag ) = @_
      ; ### ("A.txt","1,2,3","B.txt","2,3,4",���� ����� �ɼ� ����) ������ �μ��� 1 : ������ ���븸 2 : A ���� �ִ� ���� 3 : B ���� �ִ� ����

    my %hash = ( 1 => "common.txt", 2 => "only_$file_A", 3 => "only_$file_B" );
    my %output = ( 1 => "���� �κ�", 2 => "$file_A ����", 3 => "$file_B ����" );
    my %wr     = ( 1 => "C",         2 => "A",            3 => "B" );
    my $W;

    if ($file_flag) {
        print "���� ����� ���� ���� : $output{$file_flag}\n";
        $W = $wr{$file_flag};
        open $W, ">$hash{$file_flag}";
    }

    my ( $cnt_A, $cnt_B );
    my ( %A,     %B );
    $col_A =~ s/\s+//g;
    $col_B =~ s/\s+//g;
    my @A_col_list = split ",", $col_A;
    my @B_col_list = split ",", $col_B;

    open F, $file_A;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;
        my $key;
        foreach my $i (@A_col_list) {
            $pt[ $i - 1 ] =~ s/\s+$//;
            $key .= "$pt[$i-1]	";
        }
        push @{ $A{$key} }, $l;
        $cnt_A++;    ## file A �� ���� ������ ����
    }
    close F;

    open F, $file_B;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;
        my $key;
        foreach my $i (@B_col_list) {
            $pt[ $i - 1 ] =~ s/\s+$//;
            $key .= "$pt[$i-1]	";
        }
        push @{ $B{$key} }, $l;
        $cnt_B++;    ## file B �� ���� ������ ����
    }
    close F;

    my ( $common, $only_A, $only_B );
    foreach my $i ( keys %A ) {
        if ( $B{$i} ) {
            $common++;    ## ����� �� ����
            if ( $W eq "C" ) {
                print $W "$i\n";    ## A,B �������� �ִ°� ���� ���� �����
            }
        }
        else {
            $only_A++;              ## A ���� �ִ� �� ����
            if ( $W eq "A" ) {
                foreach my $j ( sort @{ $A{$i} } ) {
                    print $W "$j\n";    ## A ���� �մ°� ���� ���� �����
                }
            }
        }
    }

    foreach my $i ( keys %B ) {
        if ( $A{$i} ) {
            next;
        }
        else {
            $only_B++;
            if ( $W eq "B" ) {
                foreach my $j ( sort @{ $B{$i} } ) {
                    print $W "$j\n";    ## A ���� �մ°� ���� ���� �����
                }
            }
        }
    }

    print "---------------------------------------------------------------\n";
    print "$file_A line : $cnt_A	only line : $only_A\n";
    print "$file_B line : $cnt_B	only line : $only_B\n";
    print "---------------------------------------------------------------\n";
    print "common line : $common\n";

}

sub factorial {
    my ($num) = @_;
    my $score = 1;
    if ( $num =~ /\d+/ ) {
        foreach my $i ( 1 .. $num ) {
            $score *= $i;
        }
    }
    elsif ( $num == 0 ) {
        $score = 1;
    }
    else {
        die "No num $!\n";
    }
    return $score;
}

sub Upcase {
    my ( $target, $num ) = @_;
    $target =~ s/^(\w{$num})/\U$1/;
    return $target;
}

sub file_concatenate {
    my (@file_list) = @_;
    my ( $F, $W ) = ( 'F', 'W' );

    open( $W, ">concatenate_result.txt" ) || die $!;
    foreach my $i ( sort { $a <=> $b } @file_list ) {
        print "$i file read\n";
        open( $F, $i ) || die $!;
        while ( $l = <F> ) {
            print $W "$l";
        }
        close $F;
    }
    close $W;
}

sub file_divide_line_num {
    my ( $file, $count ) = @_;    #���� �̸�, ��� ������)
    my $F = "F";

    foreach my $i ( 1 .. $count ) {
        my $W = "W$i";
        open $W, ">$i-$file";
    }

    open $F, $file;
    my @all_line = <$F>;
    close $F;

    my $how_much_line;
    if ( ( $#all_line + 1 ) % $count ) {
        $how_much_line = int( ( $#all_line + 1 ) / $count ) + 1;
    }
    else {
        $how_much_line = int( ( $#all_line + 1 ) / $count );
    }

    foreach my $i ( 1 .. $count ) {
        $W = "W$i";
        my $out = join "", splice( @all_line, 0, $how_much_line );
        print $W "$out";
        close $W;
    }
}

sub redun_line_rm {
    my ($file) = @_;
    my ( $F, $W ) = ( "F", "W" );
    my %temp;
    my $cnt;

    open $F, $file;
    while ( chomp( $l = <F> ) ) {
        $temp{$l}++;
    }
    close $F;

    open $W, ">redun_line_rm-$file";
    foreach my $i ( keys %temp ) {
        print $W "$i\n";
        if ( $temp{$i} >= 2 ) {
            $cnt++;
        }
    }
    close $W;
    print "�ߺ��� ������ �����Ͽ�����, �ߺ��� ���� �� $cnt�� \n";
}

sub selected_col_make_key_for_group
{ ## �ش� ������ �÷��� �����ؼ� �ߺ����� �˾ƺ��� ���ϴ��÷��� �����ؼ� ����Ҽ� �ִ� �Լ�

# 	selected_col_make_key_for_group("knownGene.txt","2,3,4,5","1");
# 	sub_routine("�ش�����", " ','�� ���е� �÷� ��ȣ", "���������� �߰��� �÷��̸�, ����Ʈ �÷�")

    my ( $file, $select_col, $out_form_col ) = @_;
    my ( $F, $W ) = ( "F", "W" );

    my @select = split ",", $select_col;
    my @keys;

    foreach my $i (@select) {
        push @keys, '$_[' . ( $i - 1 ) . ']';
    }
    my $key = join "	", @keys;

    my $key_code = 'if(@_){return "' . $key . '";}';

    my $sub_key = eval "sub { $key_code }";
    print "$key	$key_code\n";

    my %temp;
    my ( $cnt, $group );

    open $F, $file;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;
        my $k = &$sub_key(@pt);

        $temp{$k}->{ $pt[ $out_form_col - 1 ] }++;    ## �ؽ��� �ؽ�
    }
    close $F;

    open $W, ">selected_col_make_key_for_group-$file";
    foreach my $i ( sort { $a cmp $b } keys %temp ) {
        $group++;
        my $imsi  = $temp{$i};
        my @array = sort { $a cmp $b } keys %{$imsi};
        my $scala = join ",", @array;
        print $W "group_$group	$i	$scala\n";
    }
    close $W;
}

sub select_col_list_count
## �������÷��� �����ϰ�, �� �ش� �÷��� ����Ʈ�� ������ ���Ѵ�.
## select_col_list_count("certain_miRNA-cluster.txt",6,",");
{

    my ( $file, $selected_col, $delimit ) = @_;
    my $total_count;
    my %hash;
    open F, $file;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;

        map { $hash{$_}++ } ( split "$delimit", $pt[ $selected_col - 1 ] );
    }
    my @key   = keys %hash;
    my $value = $#key + 1;
    return $value;
}

sub diff_array_a    ## �� �迭�� ���۷����� �޾Ƽ� a �迭���� �ִ� ����Ʈ�� ����
{
    my ( $a, $b ) = @_;
    my ( %hash, @remain_a );
    foreach my $i (@$b) {
        $hash{$i}++;
    }
    foreach my $i (@$a) {
        if ( !$hash{$i} ) {
            push @remain_a, $i;
        }
    }
    return @remain_a;
}

sub common_array    ## �� ���� �迭 ref �޾Ƽ� ����� ����Ʈ�� ��ȯ
{
    my ( $a, $b ) = @_;
    my ( %hash, @common );
    foreach my $i (@$b) {
        $hash{$i}++;
    }
    foreach my $i (@$a) {
        if ( $hash{$i} ) {
            push @common, $i;
        }
    }
    return @common;
}

sub convert_file_format
## �ش� ������ �÷��� ��ġ�� ���ϴ� ���·� �÷��� ��迭�� �Ѵ�.
## convert_file_format("����",
## "������ �÷��� 1,2,3,4 �� �Ҷ� ������ �μ��� 4,2,1,3 �̶�� �����ٸ� �̴�� ���·� ��ȯ ������ ��ü �÷��� ���ڸ�ŭ ���� �ʴ´ٸ� �÷� ���ڰ� ���� ���� ������ �����ȴ�",
## "sort �ϱ� ���ϴ� �÷��� ���ڴ� 'chr 2' ���ڴ� 'num 2' ���·� ������ �ȴ� "
## "���� �μ� 'T'�� �ָ� ���� ���ϴ� �÷��� ����� �������� ������� �� �ٴ´�"
# Usage : convert_file_format("certain_miRNA-cluster.txt","2,3","num 2","T", "result.txt");
{
    #### input handle ####
    my ( $file, $arrange_col, $sort_col, $remain, $result_file ) = @_;
    %sort_kind = ( 'chr' => 'cmp', 'num' => '<=>' );
    if ( !$result_file ) { $result_file = "convert_file_format.txt"; }

    my ( $sort_kind, $col );
    if ( $sort_col =~ /^((?:chr|num))\s+(\d+)/ ) {
        ( $sort_kind_symbol, $col ) = ( $sort_kind{$1}, $2 );
    }
    else { die "�ش� sort �÷��� chr or num �� �÷� ��ȣ�� Ȯ���ϼ���\n"; }

    #### excute ####
    my ( $F, $W ) = ( "F", "W" );
    my @new_order = split ",", $arrange_col;
    my %hash;

    open( $F, $file ) || die $!;
    while ( chomp( $l = <$F> ) ) {
        my @pt = split "	", $l;
        my @temp;

        foreach my $i (@new_order) {
            push @temp, $pt[ $i - 1 ];
        }

        my $new_l = join "	", @temp;
        if ($remain) {
            my $remain = join "	", diff_array_a( \@pt, \@temp );
            $new_l .= "	$remain";
        }

        $hash{ $pt[ $col - 1 ] } .= "$new_l\n";
    }
    close $F;

    #### anymous sub start ####
    my $code = 'my %hash = @_;
	 my @lines;
	 foreach my $i(sort {$a ' . $sort_kind_symbol . ' $b} keys %hash)
	 {
		 push @lines,$hash{$i};
	 }
	 return @lines;
	';

    #  	print "$code\n"; #�ۼ��� �ڵ带 ���� �ִ�
    #### anymous sub end ####

    $sub = eval "sub { $code }";
    my $out = join "", &$sub(%hash);

    open $W, ">$result_file";
    print $W "$out\n";
    close $W;
}

sub extract_key_cmp    ## input hash�� ref ����
{
    my ($hash) = @_;
    my @value;

    foreach my $i ( sort { $a cmp $b } keys %{$hash} ) {
        push @value, $i;
    }

    return @value;
}

sub extract_key_num    ## input hash�� ref ����
{
    my ($hash) = @_;
    my @value;

    foreach my $i ( sort { $a <=> $b } keys %{$hash} ) {
        push @value, $i;
    }

    return @value;
}

sub input_file_and_col_default {

    # mother :sub file_3_extract_info
    my ( $f_1, $sel_col ) = @_;

    $sel_col =~ /\s+/;

    my @f_2_sel_col = map { '$_[' . ( $_ - 1 ) . ']' } ( split ",", $` ); ## 1,2
    my @f_3_sel_col = map { '$_[' . ( $_ - 1 ) . ']' } ( split ",", $' ); ## 3,4

    my $f_2_code = '"' . ( join "	", @f_2_sel_col ) . '"';
    my $f_3_code = '"' . ( join "	", @f_3_sel_col ) . '"';

    $sub_f2 = eval " sub { return $f_2_code; } ";
    $sub_f3 = eval " sub { return $f_3_code; } ";

    my ( %f1, %f2, %f3 );
    open F, $f_1;    ### f_1 file handle
    while ( chomp( $l = <F> ) ) {
        my @pt = split "	", $l;
        rm_end_blank(@pt);

        push @{ $f1{ &$sub_f2(@pt) } }, &$sub_f3(@pt);
        $f2{ &$sub_f2(@pt) }++;
        $f3{ &$sub_f3(@pt) }++;
    }
    close F;
    return ( \%f2, \%f3, \%f1 );
}

sub input_file_and_col {

    # mother :sub file_3_extract_info
    my ( $f_2, $col_2, $hash ) = @_;
    my %f = %{$hash};

    $col_2 =~ /\s+/;
    my @f_1_standard_posi =
      map { '$_[' . ( $_ - 1 ) . ']' } ( split ",", $` );    ## 1,2
    my @f_1_output_posi =
      map { '$_[' . ( $_ - 1 ) . ']' } ( split ",", $' );    ## 1,2

    $f_2_code = '"' . ( join "	", @f_1_standard_posi ) . '"';
    $f_3_code = '"' . ( join "	", @f_1_output_posi ) . '"';

    $sub_f2 = eval " sub { return $f_2_code; } ";
    $sub_f3 = eval " sub { return $f_3_code; } ";

    my %output;
    open F, $f_2;
    while ( chomp( $l = <F> ) )                              ### f_2 file handle
    {
        my @pt = split "	", $l;
        if ( $f{ &$sub_f2(@pt) } ) {
            $output{ &$sub_f2(@pt) } = &$sub_f3(@pt);        ## output hash

            # 			print &$sub_f2(@pt)."	".&$sub_f3(@pt)."\n";
        }
    }
    close F;
    return \%output;
}

sub file_3_extract_info    ### 3 �� ������ �μ��� �޴´�

  # daughter : sub input_file_and_col
  # daughter : sub input_file_and_col_default
{
    my ( $f_1, $sel_col, $f_2, $col_2, $f_3, $col_3 ) = @_;
    ## $f_1 ���� , $sel_col �ΰ��� �÷� ����Ʈ�� ���� ex) "1,2 3,4"
    ## $f_2 ���� , $col_2 ���� 1,2 ���� �ش�Ǵ� ���� ������ ���ؼ� �÷� ��ȣ ���� ex) "2,3,4,7"
    ## $f_3 ���� , $col_3 ���� 3,4 ���� �ش�Ǵ� ���� ���´�.���ؼ� �÷� ��ȣ ���� ex) "2,3,4,7"

    my ( $f2, $f3, $f1 ) = input_file_and_col_default( $f_1, $sel_col )
      ;    ## 3���� �ؽ� ref �� ���� ���� Ű�� ���õ� �÷� ���� ++
    my $output_f_2 = input_file_and_col( $f_2, $col_2, $f2 );
    my $output_f_3 =
      input_file_and_col( $f_3, $col_3, $f3 );   ## �ϳ��� �ؽ� ref �� ���� ����

    open W, ">file_3_extract_info-$f_1";
    foreach my $i ( extract_key( \%{$f1} ) ) {
        foreach my $j ( @{ ${$f1}{$i} } ) {
            my ( $first, $second ) = ( $i, $j );
            print W "$i	${$output_f_2}{$i}	$j	${$output_f_3}{$j}\n";

        }
    }
    close W;
}

sub rm_end_blank {
    return map { $_ =~ s/\s+$// } @_;
}

sub A_cols_B_cols_output
### A ���Ͽ��� �÷� ����Ʈ�� ����, B ���Ͽ��� �׿� �ش��ϴ� �÷��� �����ϰ�, ������ �μ��μ� ��� �÷� ����Ʈ�� �ִ´�.
### Usage : A_cols_B_cols_output ("file_3_extract_info-common.txt", "6,7", "knownGene_new.txt", "1,2", "1,2,3,4,5,6", "result.txt");
{
    my ( $A, $A_cols, $B, $B_cols, $out_form_cols, $result_file ) = @_;
    if ( !$result_file ) { $result_file = "A_cols_B_cols_output.txt"; }

    my @cols = ( '$A_cols', '$B_cols', '$out_form_cols' );
    foreach my $i (@cols) {
        $i =~ /\$(.+)_cols/;
        $select = $1;

        my $value = eval " $i ";
        my @column_list =
          map { '$_[' . ( $_ - 1 ) . ']' } ( split ",", $value );
        my $code = 'return "' . ( join "	", @column_list ) . '";';

        ${ "sub_" . $select . "_code" } =
          eval " sub { $code } ";  ## $sub_A_code, $sub_B_code, $sub_output_code
    }

    my %query;
    open( F, $A ) || die $!;
    while ( chomp( $l = <F> ) ) {
        @pt = split "	", $l;

        # 		@pt = rm_end_blank ( @pt );
        $query{ &$sub_A_code(@pt) }++;
    }
    close F;

    open( F, $B ) || die $!;
    open( W, ">$result_file" ) || die $!;
    while ( chomp( $l = <F> ) ) {
        @pt = split "	", $l;
        if ( $query{ &$sub_B_code(@pt) } ) {
            print W &$sub_out_form_code(@pt), "\n";
        }
    }
    close F;
    close W;

}

sub read_msg {
    my ($msg) = shift;
    print "#########################################################\n";
    print "read the file $msg complete\n";
    print "#########################################################\n\n";
}

sub round_off {
    my ( $num, $cut ) = @_;
    my ( $int, $sosu );
    my $a     = "0." . "0" x $cut . "5";
    my $value = $num + $a;
    while ($value) {
        if ( $value !~ /\.(\d{$cut})/ ) {
            $cut--;
        }
        elsif ( $value =~ /\.(\d{$cut})/ ) {
            ( $int, $sosu ) = ( $`, $& );
            last;
        }
    }
    return ( $int + $sosu );
}

sub rm_start_blank {
    return map { $_ =~ s/^\s+// } @_;
}

sub msg {
    my ( $file, $msg ) = @_;
    print "#########################################################\n";
    print "$msg the file $file complete\n";
    print "#########################################################\n\n";
}

sub Seq {
    my ( $end_num, $start_num ) = @_;
    my @a = @base = qw(A C G T);
    open W, ">$start_num-$end_num-seq.txt";
    while ( $end_num > 1 ) {
        my @b;
        my $cnt;
        foreach $i (@a) {
            foreach $j (@base) {
                $b[$cnt] = $i . $j;
                $cnt++;
            }

        }

        if ( length $b[0] >= $start_num ) {
            $result = join "\n", @b;
            print W "$result\n";
        }

        @a = @b;
        $end_num--;
    }
    close W;
}

sub File2Array {
    open my $F, $_[0] or die "$! not exist $_[0]\n";
    my @Array = <$F>;
    close $F;

    map { $_ =~ s/\n// } (@Array);
    return @Array;
}

sub File2hash {
    my ( $file, $col_key, $col_value ) = @_;

    if ( !$file || !$col_key ) { die "No input File and key column!"; }

    my @value = map { '$_[' . ( $_ - 1 ) . ']' } ( split /,/, $col_value );
    my $code = 'return "' . ( join "	", @value ) . '";';
    print "code : $code\n\n";
    my $sub = eval "sub { $code }";

    my @content = File2Array($file);
    my %hash;
    my $cnt;

    foreach my $i (@content) {
        chomp($i);
        $cnt++;
        my @pt = split /\t/, $i;

        if ($col_value) {
            my $sub_value = &$sub(@pt);
            $hash{ $pt[ $col_key - 1 ] } .= "$sub_value,";
        }
        elsif ( !$col_value ) {
            $hash{ $pt[ $col_key - 1 ] } = $cnt;
        }
    }
    return %hash;
}

sub Foreach_hash {
    my %hash = @_;

    foreach ( sort { $a <=> $b } keys %hash ) {
        print "$_	$hash{$_}\n";
    }
}

sub Foreach_array {
    foreach (@_) {
        print "$_\n";
    }
}

sub e {
    print STDERR "$_[0]\n";
}

sub make_dir {
    my ($exist) = ( shift || die "dir do not exist!\n" );

    unless ( -d $exist ) {
        mkdir($exist);
    }
}

sub Fasta_divide {
    my ($file)   = ( shift || die "File argument error!\n" );
    my ($num)    = ( shift || die "Num argument error!\n" );
    my ($folder) = ( shift || "Fasta_divide" );
    make_dir($folder);

    my $cnt        = 0;
    my $handle_cnt = 0;
    my $handle;

    open( FASTA_FILE, $file ) || die $!;
    while ( chomp( my $l = <FASTA_FILE> ) ) {
        if ( $l =~ />/ ) {
            if ( $cnt % $num == 0 ) {

                #print "$l\n";
                $handle_cnt++;
                $handle = "FASTA_FILE_W_$handle_cnt";
                close $handle;
                open( $handle, ">$folder/Fasta_$handle_cnt.txt" ) || die $!;
            }
            $cnt++;

            print $handle "$l\n";
        }
        elsif ( $l =~ /^\w+/ ) {
            print $handle "$l\n";
        }
    }
    close FASTA_FILE;
    close $handle;

}

sub copy_file {
    my ($file) = ( shift || die "File argument error!\n" );
    my ($line) = ( shift || die "Line argument error!\n" );
    my $cnt;
    my $result;

    open( COPY_FILE,   $file )         || die $!;
    open( COPY_FILE_W, ">$file.copy" ) || die $!;
    while ( chomp( my $l = <COPY_FILE> ) ) {
        $cnt++;
        if ( $cnt <= $line ) {
            print COPY_FILE_W $l, "\n";
        }
        else {
            last;
        }
    }
    close COPY_FILE;
    close COPY_FILE_W;
}

sub copy_file_FromTo {
    my ($file)  = ( shift || die "File argument error!\n" );
    my ($start) = ( shift || die "start Line argument error!\n" );
    my ($end)   = ( shift || die "end Line argument error!\n" );
    my ($name)  = ( shift || die "filename argument error!\n" );
    my $cnt;
    my $result;

    open( COPY_FILE,   $file )        || die $!;
    open( COPY_FILE_W, ">$name.txt" ) || die $!;
    while ( chomp( my $l = <COPY_FILE> ) ) {
        $cnt++;
        if ( $cnt >= $start && $cnt <= $end ) {
            print COPY_FILE_W $l, "\n";
        }
        elsif ( $cnt > $end ) { last; }
    }
    close COPY_FILE;
    close COPY_FILE_W;
}

sub rm_end_input {
    my ($target)  = ( shift || die "No insert Target\n" );
    my ($pattern) = ( shift || die "No insert pattern\n" );

    $target =~ s/$pattern$//;
    return $target;
}

sub File_want_col_sort    ### ��� ������ ���ϴ� �÷��� �������� �ٽ� ����
{
    my ($file) = ( shift || die "Target File insert~!\n" );
    my ($col)  = ( shift || die "Target column insert~!\n" );
    my ( %M, @pt );

    open( FILE_WANT_COL_SORT, $file ) || die $!;
    while ( chomp( my $l = <FILE_WANT_COL_SORT> ) ) {
        @pt = split /\t/, $l;
        push @{ $M{ $pt[ $col - 1 ] } }, $l;
    }
    close FILE_WANT_COL_SORT;

    return (%M);

    ### example ###

    # # %M = File_want_col_sort("sam.txt",1);

    # # foreach my $i (sort {$a <=> $b} keys %M)
    # # {
    # #
    # # 	foreach my $j ( @{$M{$i}} )
    # # 	{
    # # 		print "$j\n";
    # # 	}
    # # }
    ### example ###
}

sub Show_File {
    my ($path) = ( shift || die "input path error\n" );
    my ($file) = ( shift || die "input file name error\n" );

    foreach $i ( File2Array("$path/$file") ) {
        print "$i\n";
    }
}

sub get_time {
    my ( $sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst ) =
      localtime(time);
    $year += 1900;    ## 1900 �� ����
    $day = "0" . $day if $day < 10;
    $mon++;
    $mon = "0$mon" if $mon < 10;
    return "$year-$mon-$day-$sec";
}

sub get_time_detail {
    my ( $sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst ) =
      localtime(time);
    $year += 1900;    ## 1900 �� ����
    $day = "0" . $day if $day < 10;
    $mon++;
    $mon = "0$mon" if $mon < 10;
    return "$year$mon$day $hour:$min:$sec";
}

sub get_cpu_time {
    $start = (times)[0];
    foreach $i ( 0 .. 1000000 ) {
        $a = $i;
    }
    $end = (times)[0];
    printf "that took %.2f CPU seconds\n", $end - $start;
}

sub Array2Hash {
    ### desc ###
    ### array �� hash �� ����� ����
    my %hash;
    map { $hash{$_}++ } @_;
    return %hash;
}

sub log_base {
    my ( $target, $base ) = @_;
    return log($target) / log($base);
}

sub Array_div_odd_even_index {
    my ( @odd, @even );
    foreach my $i ( 0 .. $#_ ) {
        if ( $i % 2 == 0 ) {
            push @even, $_[$i];
        }
        else {
            push @odd, $_[$i];
        }
    }
    return ( \@even, \@odd );
}

sub Array_div_odd_even_element {
    my ( @odd, @even );
    foreach my $i ( 0 .. $#_ ) {
        if ( $_[$i] % 2 == 0 ) {
            push @even, $_[$i];
        }
        else {
            push @odd, $_[$i];
        }
    }
    return ( \@even, \@odd );
}

sub cal_linker_length {
    my ( $start, $end ) = @_;
    my @result;

    foreach my $i ( 1 .. $#$start ) {
        push @result, $$start[$i] - $$end[ $i - 1 ];
    }
    return @result;
}

sub Array_start_double_howmany_tab {
    my ( $start_double, $howmany, @target ) = @_;
    my $target_cnt = @target;

    #print "$start_double	$howmany	$target_cnt\n";

    my @result;
    my $cnt = 0;
    while ( $start_double * $cnt + $howmany - 1 <= $target_cnt ) {

        my @temp =
          @target[ $start_double * $cnt .. $start_double * $cnt +
          $howmany -
          1 ];

        #print "@temp\n";
        my $tmp = @temp;
        if ( $tmp == $howmany ) {
            push @result, join "	", @temp;
        }
        $cnt++;
    }
    return @result;
}

sub seq2fasta_form {
    my ( $line, $cnt );
    foreach my $i (@_) {
        chomp($i);
        $cnt++;
        $line .= ">$cnt\n$i\n";
    }
    return $line;
}

sub Write_file {
    my ($content)   = ( shift || die "No content\n" );
    my ($file_name) = ( shift || die "No filename\n" );

    open my $W, ">$file_name.txt" or die $!;
    print $W "$content";
    close $W;
}

sub calculate_promoter_between_gene {
    my ( $as, $ae, $bs, $be ) = @_;

    #print "$as,$ae,$bs,$be\n";
    my $length;

    if ( $as == $bs && $ae == $be ) {

        #$length = $ae-$as+1;		## same position -1 return
    }
    elsif ( $as > $bs && $as > $be ) {
        $length = 0;

        #print "bs out be out left\n";
    }
    elsif ( $as > $bs && $as <= $be && $ae > $be ) {
        $length = $be - $as + 1;

        #print "bs out left be in\n";
    }
    elsif ( $as <= $bs && $as <= $be && $ae > $bs && $ae > $be ) {
        $length = $be - $bs + 1;

        #print "bs in be in\n";
    }
    elsif ( $as <= $bs && $as <= $be && $ae > $bs && $ae <= $be ) {
        $length = $ae - $bs + 1;

        #print "bs in be out right\n";
    }
    elsif ( $as <= $bs && $as <= $be && $ae <= $bs && $ae <= $be ) {
        $length = 0;

        #print "bs out be out right\n";
    }
    return $length;
}

sub confirm_2 {
    my %tmp = @_;
    foreach my $i ( sort { $a cmp $b } keys %tmp ) {
        foreach my $j ( sort { $a cmp $b } keys %{ $tmp{$i} } ) {
            print "$i	$j	$tmp{$i}{$j}\n";
        }
    }
}

sub confirm_3 {
    my %tmp = @_;
    foreach my $i ( sort { $a cmp $b } keys %tmp ) {
        foreach my $j ( sort { $a cmp $b } keys %{ $tmp{$i} } ) {
            foreach my $k ( sort { $a cmp $b } keys %{ $tmp{$i}{$j} } ) {
                print "$i	$j	$k	$tmp{$i}{$j}{$k}\n";
            }
        }
    }
}

sub show_array {
    my @input = @_;
    foreach my $i ( 0 .. 8 ) {
        foreach my $j ( 0 .. 3 ) {
            print "$i	$j	$input[$i][$j]\n";
        }
    }
}

sub comma_count {
    my ($file) = @_;
    my %hash;

    open( COMMA, $file ) || die $!;
    while ( chomp( my $l = <COMMA> ) ) {
        my @pt = split ",", $l;
        foreach my $i (@pt) {
            $hash{$i}++;
        }
    }
    close COMMA;

    my $cnt = keys %hash;
    print "COMMA count : $cnt\n";
    return %hash;
}

sub change_xy {
    my ( $file, $result ) = @_;
    my ( @x, $cnt, $col, %M );
    print "\n\nconvert X --> Y\n";

    open( CHANGE_XY, $file ) || die $!;
    while ( chomp( my $l = <CHANGE_XY> ) ) {
        my @pt = split "	", $l;
        $cnt++;
        if ( $cnt == 1 ) {
            $col = @pt;
        }
        foreach my $i ( 1 .. $col ) {
            $M{$cnt}{$i} = $pt[ $i - 1 ];
        }
    }
    close CHANGE_XY;

    open( CHANGE_XY_W, ">$result.txt" ) || die $!;
    foreach my $i ( 1 .. $col ) {
        my @line;
        foreach my $j ( 1 .. $cnt ) {
            if ( $M{$j}{$i} eq "	" ) { $M{$j}{$i} = " "; }
            push @line, $M{$j}{$i};
        }
        my $line = join "	", @line;
        print CHANGE_XY_W "$line\n";
    }
    close CHANGE_XY_W;
}

sub Key_value {
    my ($file)  = ( shift || die "No File\n" );
    my ($key)   = ( shift || die "No Key column\n" );
    my ($value) = ( shift || die "No value column\n" );
    my %hash;

    foreach my $i ( File2Array($file) ) {
        chomp($i);
        @pt = split "	", $i;
        $hash{ $pt[ $key - 1 ] } = $pt[ $value - 1 ];
    }

    return %hash;
}

sub getFileExtension {
    my $pos = rindex $_[0], ".";
    return "" if $pos < 1;
    substr $_[0], $pos + 1;
}

sub make_hash_from_file {
    my %hash;
    open( F, $_[0] ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        $hash{$l}++;
    }
    close F;
    return %hash;
}

sub Chage {
    my %chage = ( 0 => "AA", 2 => "BB", 1 => "AB", 5 => "FL" );
    open( CH_W, ">out.txt" ) || die $!;
    open( CH,   $_[0] )      || die $!;
    while ( chomp( $l = <CH> ) ) {
        $l =~ s/^\t/NN\t/;
        $l =~ s/\t$/\tNN/;

        $l =~ s/\t\t/\tNN\t/g;
        $l =~ s/\t\t/\tNN\t/g;

        my @pt = split /\t/, $l;

        my @new;
        foreach my $i (@pt) {
            if ( $chage{$i} ) {
                push @new, $chage{$i};
            }
            else {
                push @new, $i;
            }

        }

        my $line = join "	", @new;
        print CH_W "$line\n";
    }
    close CH;
    close CH_W;
}

sub getfilename {
    my ( $pos, $name );
    $pos = rindex $_[0], ".";
    $name = substr $_[0], 0, $pos;

    $pos = rindex $name, "/";
    $name = substr $_[0], $pos + 1, length($name);
    return $name;
}

sub read_matrix {
    e("Read matrix file : $_[0]");
    open my $F, $_[0]
      or die "Cannot read $_[0]\n";

    my ( $cnt, %M, @Marker, $read_cnt );

    while (<$F>) {
        chomp;
        $cnt++;
        my @pt = split "\t";

        if ( $. % 10000 == 0 ) { print STDERR get_time_detail(), "	number $.\n"; }

        @marker = @pt if $cnt == 1;
        if ( $cnt != 1 ) {
            my $sam = shift @pt;
            foreach my $i ( 0 .. $#pt ) {
                ### title �� ��Ŀ�϶�
                #$M{$sam}{$marker[$i+1]} = $pt[$i];

                ### title �� �����϶�
                $M{ $marker[ $i + 1 ] }{$sam} = $pt[$i];

                $read_cnt++;
            }
        }

    }
    close F;

    print STDERR "read matrix list : $read_cnt\n";
    return %M;
}

sub read_matrix_x {
    open( my $F, $_[0] )
      or die $!;
    my ( %M, @Marker );

    while (<$F>) {
        chomp;
        my @pt  = split "\t";
        my $sam = shift @pt;

        @marker = @pt if $. == 1;

        if ( $. > 1 ) {
            map { $M{$sam}{ $marker[$_] } = $pt[$_] } 0 .. $#pt;
        }

    }
    close F;

    return %M;
}

sub make_col_function {
    my @keys;
    foreach my $i (@_) {
        push @keys, '$_[' . ( $i - 1 ) . ']';
    }
    my $key      = join "	", @keys;
    my $key_code = 'if(@_){return "' . $key . '";}';
    my $sub_key  = eval "sub { $key_code }";

    #print "$key	$key_code\n";
    return ($sub_key);
}

sub hash_tab_limited {
    my ( $file, $select_col, $out_form_col ) = @_;

    #print "$file,$select_col,$out_form_col\n";

    my @select = split ",", $select_col;
    my @values = split ",", $out_form_col;
    my @keys;

    my $sub_key = make_col_function(@select);
    my $sub_value =
      $out_form_col eq "all"
      ? undef
      : make_col_function(@values);
    my %temp;
    my ( $cnt, $group );

    open my $F, '<', $file
      or die "Cannot read $file $!\n";
    while (<$F>) {
        chomp;
        my @pt       = split /\t/;
        my $key_text = &$sub_key(@pt);
        my $value_text =
            $out_form_col eq "all"
          ? $_
          : &$sub_value(@pt);

        if ( $temp{$key_text} ) { $temp{$key_text} .= ",$value_text"; }
        else                    { $temp{$key_text} = $value_text; }
    }
    close $F;

    return %temp;
}

sub hash_tab_limited_cnt {
    my ( $file, $select_col ) = @_;
    print "$file,$select_col\n";
    my ($F) = ("F");

    my @select = split ",", $select_col;

    my $sub_key = make_col_function(@select);
    my %temp;

    open $F, $file;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split "	", $l;
        my $key_text = &$sub_key(@pt);

        #print ">key: $key_text\n>value: $value_text\n";

        $temp{$key_text}++;
    }
    close $F;

    return %temp;
}

sub extract_want_col_from_f {
    my $f        = $_[0];                          # target file
    my @user_col = split ",", $_[1];               # user want column
    my $key      = make_col_function(@user_col);

    open( F, $f ) or die $!;
    open( W, ">$f.extracted_col" ) or die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split /\t/, $l;
        my $cols = &$key(@pt);
        print W "$cols\n";
    }
    close F;
    close W;
}

sub Merge {
    my ( $title, $result_name, @list ) = @_;
    open( MERGE, ">$result_name.txt" ) || die $!;

    foreach my $i (@list) {
        print "$i\n";
        my $cnt;
        open( F, $i ) || die $!;
        while ( chomp( my $l = <F> ) ) {
            next if ++$cnt == $title;

            print MERGE "$l\n";
        }
        close F;
    }

    close MERGE;
}

sub Merge_custom {
    my ( $common_title, $result_name, @file_list ) = @_;

    my $cnt;
    open( MERGE, ">$result_name.txt" ) || die $!;
    foreach my $i (@file_list) {
        print "$i\n";
        $cnt++;
        open( F, $i ) || die $!;
        while ( chomp( my $l = <F> ) ) {
            if ( $cnt > 1 && $. == $common_title ) {
                print "skip $. number\n$l\n";
                next;
            }

            print MERGE "$l\n";
        }
        close F;
    }

    close MERGE;
}

sub fasta_f_read {
    open( F, $_[0] ) || die $!;
    @seq = <F>;
    close F;
    shift @seq;
    $seq = join "", @seq;
    $seq =~ s/\n//g;
    return $seq;
}

sub Input_STDIN_f {
    print "\n[Question] $_[0] : ";
    my $input = <STDIN>;
    chomp($input);
    return $input;
}

sub Input_STDIN_t {
    print "\n[Question] $_[0] : ";
    my $input = <STDIN>;
    chomp($input);
    return $input;
}

sub complementary {
    $seq = shift;
    $seq =~ tr/ACGTacgtRYMKWSHDBV/TGCAtgcaYRKMWSDHVB/;
    $seq = reverse($seq);
    if ( $seq =~ /[\[|\]]/ ) { $seq =~ tr/\[\]/\]\[/; }
    return ($seq);
}

sub trim_space {
    $_[0] =~ s/\s+//g;
    return ( $_[0] );
}

sub IUPAC {


    my @tmp = split /\//, $_[0];
    @tmp = sort { $a cmp $b } @tmp;
    my $sort_input = join "", @tmp;

    my %iupac = (
        AG   => "R",
        CT   => "Y",
        AC   => "M",
        GT   => "K",
        AT   => "W",
        CG   => "S",
        CGT  => "B",
        AGT  => "D",
        ACT  => "H",
        ACG  => "V",
        ACGT => "N"
    );
    my $result = $iupac{$sort_input};
    $result = "X" if !$result;

    return ($result);
}

sub iupac2geno {
    my %allele = (
        R => "AG",
        Y => "CT",
        M => "AC",
        K => "GT",
        W => "AT",
        S => "CG",
        B => "CGT",
        D => "AGT",
        H => "ACT",
        V => "ACG",
        N => "ACGT"
    );
    return %allele;
}

sub iupac2genotype {
    my %allele = (
        R => "A/G",
        Y => "C/T",
        M => "A/C",
        K => "G/T",
        W => "A/T",
        S => "C/G",
        B => "C/G/T",
        D => "A/G/T",
        H => "A/C/T",
        V => "A/C/G",
        N => "A/C/G/T"
    );
    return %allele;
}

sub fasta2hash {
    open( F, $_[0] ) || die $!;
    my ( $id, %id2seq );
    while ( chomp( my $l = <F> ) ) {
        if ( $l =~ />/ ) {
            $id = $';
        }
        elsif ( $l =~ /\w+/ && $id ) {
            $id2seq{$id} .= $l;
        }
    }
    close F;

    return %id2seq;
}

sub mssql_connect {
    ######### DBN DB MSSQL Connect ############
    ######## database ����
    my $DSN =
      'driver={SQL Server};Server=DBN;database=rs_db;uid=sa;pwd=dna@link;';
    my $dbh = DBI->connect("dbi:ODBC:$DSN") or die "$DBI::errstr\n";
    return $dbh;

}

sub DB_query {
    my ( $dbh, $qry ) = @_;
    my $sth = $dbh->prepare($qry);
    $sth->execute();
    return $sth;
}

sub divide_size {
    my ( $seq, $size ) = @_;
    my $len_seq   = length($seq);
    my $operation = int( $len_seq / $size );

    foreach my $i ( 0 .. $operation ) {
        my $sub_seq = substr( $seq, $i * $size, $size );
        push @seq, $sub_seq;
    }
    return @seq;
}

sub csv_file_handle_key_value {

    # $file_write --> option ���Ϸ� ����� ������ ���� �ִ´�.

    my ( $file, $key, $value, $file_write ) = @_;
    my $key_function   = make_col_function( split ",", $key );
    my $value_function = make_col_function( split ",", $value );
    my %result;    ## --> result hash

    open( F, $file ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        $l =~ s/^\"//;    ## first ^" rm
        $l =~ s/\"$//;    ## last "$ rm
        @pt = split '","', $l;

        my $key   = &{$key_function}(@pt);
        my $value = &{$value_function}(@pt);

        #print "$key	$value\n";
        $result{$key} = $value;
    }
    close F;

    if ($file_write) { Foreach_hash2file( "name", %result ); }
    else             { return %result; }
}

sub Foreach_hash2file {
    my $name = shift;
    my %hash = @_;
    open( W, ">$name.txt" ) || die $!;
    foreach my $i ( sort { $a cmp $b } keys %hash ) {
        print W "$i	$hash{$i}\n";
    }
    close W;
}

sub show_column_sample_from_file {
    my $file    = shift;
    my $delimit = shift;
    open( F, $file ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split $delimit, $l;
        map { print "$_	$pt[$_]\n" } ( 0 .. @pt );
        print "count : ", scalar(@pt), "\n";
        <STDIN>;
    }
    close F;
}

sub make_2_hash {
    my ( $db_f, $fir_key, $sec_key, $value ) = @_;

    my @fir_key = split ",", $fir_key;
    my @sec_key = split ",", $sec_key;
    my @value   = split ",", $value;

    my $fir_key_sub = make_col_function(@fir_key);
    my $sec_key_sub = make_col_function(@sec_key);
    my $value_sub   = make_col_function(@value);

    my %db;
    open( F, $db_f ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split /\t/, $l;

        my $fir_key   = &{$fir_key_sub}(@pt);
        my $sec_key   = &{$sec_key_sub}(@pt);
        my $value_key = &{$value_sub}(@pt);

        if ( $value eq "all" ) { $value_key = $l; }

        # make db hash
        if ( $db{$fir_key}{$sec_key} ) {
            $db{$fir_key}{$sec_key} .= ",$value_key";
        }
        else { $db{$fir_key}{$sec_key} = $value_key; }
    }
    close F;
    return %db;
}

sub make_2_hash_cnt {
    my ( $db_f, $fir_key, $sec_key ) = @_;

    my @fir_key = split ",", $fir_key;
    my @sec_key = split ",", $sec_key;

    my $fir_key_sub = make_col_function(@fir_key);
    my $sec_key_sub = make_col_function(@sec_key);

    my %db;
    open( F, $db_f ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split /\t/, $l;

        my $fir_key = &{$fir_key_sub}(@pt);
        my $sec_key = &{$sec_key_sub}(@pt);

        # make db hash
        $db{$fir_key}{$sec_key}++;
    }
    close F;
    return %db;
}

sub make_3_hash {
    e("excute function make_3_hash");
    my ( $db_f, $fir_key, $sec_key, $third_key, $value ) = @_;

    my @fir_key   = split ",", $fir_key;
    my @sec_key   = split ",", $sec_key;
    my @third_key = split ",", $third_key;
    my @value     = split ",", $value;

    my $fir_key_sub   = make_col_function(@fir_key);
    my $sec_key_sub   = make_col_function(@sec_key);
    my $third_key_sub = make_col_function(@third_key);
    my $value_sub     = make_col_function(@value);

    my %db;
    open( F, $db_f ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt = split /\t/, $l;

        my $fir_key   = &{$fir_key_sub}(@pt);
        my $sec_key   = &{$sec_key_sub}(@pt);
        my $third_key = &{$third_key_sub}(@pt);
        my $value_key = &{$value_sub}(@pt);

        if ( $value eq "all" ) { $value_key = $l; }

        # make db hash
        if ( $db{$fir_key}{$sec_key}{$third_key} ) {
            $db{$fir_key}{$sec_key}{$third_key} .= ",$value_key";
        }
        else { $db{$fir_key}{$sec_key}{$third_key} = $value_key; }
    }
    close F;
    return %db;
}

sub make_array_with_delimit {
    my ( $value, $delimit ) = @_;
    my @result = split /$delimit/, $value;
    return @result;
}

sub confirm_2_file {
    my ( $name, %tmp ) = @_;
    open( W, ">$name.txt" ) || die $!;
    foreach my $i ( sort { $a cmp $b } keys %tmp ) {
        foreach my $j ( sort { $a <=> $b } keys %{ $tmp{$i} } ) {
            print W "$i	$j	$tmp{$i}{$j}\n";
        }
    }
    close W;
}

sub confirm_3_file {
    my ( $name, %tmp ) = @_;
    open( W, ">$name.txt" ) || die $!;
    foreach my $i ( sort { $a cmp $b } keys %tmp ) {
        foreach my $j ( sort { $a cmp $b } keys %{ $tmp{$i} } ) {
            foreach my $k ( sort { $a cmp $b } keys %{ $tmp{$i}{$j} } ) {
                print W "$i	$j	$k	$tmp{$i}{$j}{$k}\n";
            }
        }
    }
    close W;
}

sub make_matrix_file {
    ## (title hash ref, file name, matrix data hash)
    ## usage format
  #	%matrix = make_2_hash("call.txt",2(sample column),1(marker column),3(call));
  #	%Title = hash_tab_limited("call.txt",1(marker column),2);
  #	make_matrix_file(\%Title,"call_matrix",%matrix);

    my $ref_title = shift;
    my @title     = sort { $a cmp $b } keys %{$ref_title};
    my $title     = join "	", @title;

    my $file_name = shift;
    my %matrix    = @_;

    open( W, ">$file_name.txt" ) || die $!;
    print W "	$title\n";
    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        push @tmp, $i;
        foreach my $j (@title) {
            if ( $matrix{$i}{$j} || $matrix{$i}{$j} == 0 ) {
                push @tmp, $matrix{$i}{$j};
            }
            else { push @tmp, "FL"; }
        }
        my $line = join "	", @tmp;
        print W "$line\n";
    }
    close W;
}

sub make_matrix_file_new {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    #my @title = sort {$a cmp $b} keys @{ $M{ shift keys %matrix  } };

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {

            #print "$i	$j	$matrix{$i}{$j}\n";

            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : "NN";
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfss_ctitle {
    my ( $file, $matrix, $title ) = @_;
    print "make matrix file --> $file.txt\n";
	
	%matrix = %{$matrix};
	my @title  = @{$title};
#map { print "$_\n" } @title;
    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfss_n {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title );

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp );
    }
    close $W;
}


sub mmfss {
    my ( $file, %matrix ) = @_;
	#print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}


sub mmfss_print {
    my ( %matrix ) = @_;
	#print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    print join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print join( "\t", $i, @tmp ), "\n";
    }
}

sub mmfss_header {
    my ( $file, $header,%matrix ) = @_;
	#print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", $header, @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfss_1 {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : -1;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfss_dot {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : ".";
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}


sub mmfss_blank {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : "";
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}


sub mmfss_space2 {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : "  ";
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfns {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a <=> $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a cmp $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfsn {
    my ( $file, %matrix ) = @_;
#print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a <=> $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub mmfnn {
    my ( $file, %matrix ) = @_;
    print "make matrix file --> $file.txt\n";

    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a <=> $b } keys %titles;

    open my $W, '>', "$file.txt"
      or croak "Cannot write file $file $!";

    print $W join( "\t", "probeset_id", @title ), "\n";

    foreach my $i ( sort { $a <=> $b } keys %matrix ) {
        my @tmp;
        foreach my $j (@title) {
            push @tmp, defined $matrix{$i}{$j}
              ? $matrix{$i}{$j}
              : 0;
        }
        print $W join( "\t", $i, @tmp ), "\n";
    }
    close $W;
}

sub h2r {
    my %h = @_;
    my %r;
    for my $i ( keys %h ) {
        map { $r{$_}{$i} = $h{$i}{$_} } keys %{ $h{$i} };
    }
    return %r;
}

sub sam_count_delimit_coma {
    my %hash = @_;
    my $sam_cnt;
    foreach my $i ( keys %hash ) {
        my $cnt = @tmp = split ",", $hash{$i};
        $sam_cnt += $cnt;
    }
    return $sam_cnt;
}

sub make_reverse_hash {
    my %hash = @_;
    my %result;
    foreach my $i ( keys %hash ) {
        my $cnt = $hash{$i};
        $result{$cnt} .= "$i,";
    }
    return %result;
}

sub make_call_matrix {
    my ( $db_f, $snp, $sam, $call ) = @_;

    my %db;
    open( F, $db_f ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my @pt    = split /\t/, $l;
        my $snpid = $pt[ $snp - 1 ];
        my $samid = uc( $pt[ $sam - 1 ] );    ## sample id upper case
        $samid =~ s/\s+//g;                   ## sample id ���� ����

        if ( !$db{$samid}{$snpid} ) {
            $db{$samid}{$snpid} = "$pt[$call-1]";
        }
        else {
            $db{$samid}{$snpid} .= ",$pt[$call-1]";
        }

    }
    close F;
    return %db;
}

sub File_line_check {
    foreach my $i (@_) {
        open( F, $i ) || die $!;
        my @line = <F>;
        print "$i file line " . scalar(@line) . " line\n";
        close F;
    }
}

sub csv2txt {
    my $file = shift;
    open $F, $file            or die $!;
    open $W, ">$file-csv2txt" or die $!;
    while ( chomp( my $l = <F> ) ) {
        $l =~ s/^\"//;
        $l =~ s/\"$//;
        $l =~ s/\",\"/\t/g;
        print $W "$l\n";
    }
    close $F;
    close $W;
}

sub show_array_array {
    my @array = @_;
    foreach my $i (@array) {
        print "@{$i}\n";
    }
}

sub select_col_id_cnt {
    my ( $file, $col ) = @_;
    my $sub_key = make_col_function( split ",", $col );
    my ($F) = "F";

    my %id_cnt;
    open( $F, $file ) || die $!;
    while ( chomp( my $l = <$F> ) ) {
        my @pt = split "	", $l;
        my $key = &{$sub_key}(@pt);
        $id_cnt{$key}++;
    }
    close $F;
    Foreach_hash2file( "id_count", %id_cnt );

    return %id_cnt;
}

sub select_two_col_id_cnt {
    my ( $file, $fir, $sec ) = @_;
    my $sub_1_key = make_col_function( split ",", $fir );
    my $sub_2_key = make_col_function( split ",", $sec );
    my ($F)       = "F";

    my %id_cnt;
    open( $F, $file ) || die $!;
    while ( chomp( my $l = <$F> ) ) {
        my @pt    = split "	", $l;
        my $key_1 = &{$sub_1_key}(@pt);
        my $key_2 = &{$sub_2_key}(@pt);
        $id_cnt{$key_1}{$key_2}++;
    }
    close $F;
    confirm_2_file( "id_count", %id_cnt );

    return %id_cnt;
}

sub key_cnt {
    my %hash = @_;
    @key = keys %hash;
    print "key cnt : ", scalar(@key), "\n";
}

sub select_col_count {
    my ( $file, $col ) = @_;
    my @cont = File2Array($file);
    my %result;
    my @col = split ",", $col;
    my $sub_key = make_col_function(@col);

    foreach my $i (@cont) {
        my @pt = split "	", $i;
        my $key = &{$sub_key}(@pt);
        $result{$key}++;
    }

    my @keys = keys %result;
    print "key : ", scalar(@keys), "\n";

    my $cnt;
    foreach my $i ( keys %result ) {
        if ( $result{$i} > 1 ) {
            $cnt++;
            print "$i	$result{$i}\n";
        }
    }

    print "complete : $cnt EA\n";
}

sub get_name {
    my ($file) = @_;
    $file =~ /\/?(\w+)\./;
    return $1;
}

sub special_variant {
    my @special;
    $special[0] = $0;     ## current file name;
    $special[1] = $^O;    ## OS system
}

sub matrix_call_num2AB {
    my ( $file, $name ) = @_;
    my %num2AB = ( 0 => "AA", 1 => "AB", 2 => "BB", 5 => "NN" );

    open( F, $file )        || die $!;
    open( W, ">$name.txt" ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        $cnt++;
        if ( $cnt == 1 ) { print W "$l\n"; next; }

        my ( $id, @pt ) = split /\t/, $l;

        my @line;
        push @line, $id;
        foreach my $i (@pt) {
            push @line, $num2AB{$i};
        }

        my $line = join "	", @line;

        print W "$line\n";
    }
    close F;
    close W;
}

sub sample_random_selection {
    my ( $select_cnt, @list ) = @_;

    my $list_cnt = scalar(@list);

    print "start sampling : $select_cnt\n";
    print "list count : $list_cnt\n";

    if ( $select_cnt > $list_cnt ) { die "sample size is small\n"; }

    my @result;
    my %exist;

    while (1) {
        my $num = int( rand($list_cnt) );    ## rand (10) 0-9�������� ����
        if ( !$exist{$num} ) {
            $exist{$num}++;
            push @result, $list[ $num - 1 ];
            if ( scalar(@result) == $select_cnt ) { last; }
        }
    }

    print "selected list : " . scalar(@result), "\n";
    $result = join "\n", @result;
    return $result;
}

sub get_string_from_seq {
    my ( $seq, $window_size, $sliding_size, $start, $end, $rs ) = @_;
    my $len = length($seq);
    my $line;

    foreach my $i ( 1 .. ( $len - ( $window_size - 1 ) ) ) {
        my $string = substr( $seq, ( $i - 1 ), $window_size );
        my $pos_s = $start + ( $i - 1 );
        my $pos_e = $pos_s + ( $window_size - 1 );

        $line .= ">$rs-$pos_s-$pos_e\n$string\n";
    }
    return $line;
}

sub dp_f_info {
    my ( $file, $skip_line ) = @_;
    my @text = File2Array($file);

    splice( @text, 0, $skip_line ) if $skip_line;
    my @tab = split /\t/, $text[0];

    print "\t\t< Display File information >\t\t\n";
    print "\t File	$file\n";
    print "\t Line	", scalar(@text), "\n";
    print "\t Tab	",  scalar(@tab),  "\n\n\n\n";

}

sub perl_script {
    my %info;
    $info{pid}          = $$;    ### ���� scipt �� �����ϴ� process ��ȣ
    $info{uid}          = $<;    ### �� process�� �� user ID(uid)
    $info{euid}         = $>;    ### ���� process �� ��ȿ uid
    $info{gid}          = $(;    ### ���� process �� �� gid
    $info{egid}         = $);    ### ���� process �� ��ȿ gid
    $info{program_name} = $0;    ### ���� �������� ��ũ��Ʈ�� ���� �̸�
    $info{perl_version} = $];    ### perl version  check
    $info{osname}       = $^O
      ; ### ���� perl ���̳ʸ��� �����ϵ� �ý����� �ü�� Config ��� ��� ����� �� �ִ� ������ ���
    $info{basetime} = $^T
      ; ### 1970����� �����Ͽ� �ش� ��ũ��Ʈ�� ����� �ð��� �ʴ����� ȯ���� ��
    $info{warning}         = $^W;    ### ���� ��� ����ġ�� ��
    $info{executable_name} = $^X;    ### ����� perl ���̳ʸ� �ڽ��� �̸�

    print "<SYSTEM Information>\n\n[Summary]\n";
    Foreach_hash(%info);

    print "\n\n[ENV]\n";
    Foreach_hash(%ENV);

    print "\n\n[INC]\n";
    Foreach_array(@INC);

    print "\n\n[INC]\n";
    Foreach_hash(%INC);

    print "\n\n[SIG]\n";
    Foreach_hash(%SIG);
}

sub remote_test {
    my ( $host, $timeout ) = @_;

    #$host = "165.132.106.38";
    #$timeout = 10;
    if ( pingecho( $host, $timeout ) ) { print "$host is alive\n"; }
}

sub get_element {
    ## Ư�������϶��� \ �� �ٿ��ش� --> $delimit
    my ( $list, $delimit, $num ) = @_;
    my @list = split "$delimit", $list;
    return ( $list[ $num - 1 ] );
}

sub convert_line {
    my ( $list, $string ) = @_;
    my @list   = @{$list};
    my @string = @{$string};

    foreach my $i (@list) {
        my ( $expression, $replace ) = @{$i};
        foreach my $j (@string) {
            $j =~ s/$expression/$replace/g;
        }
    }
    return @string;
}

sub Array2File {
    my ( $name, @array ) = @_;
    my $data = join "\n", @array;
    Write_file( $data, $name );
}

sub matrix_call_correction {
    my ( $before, $after ) = @_;

    ### data format title marker row sample

    ### read �߸��� hetero call ���� �͸� hash �� ����
    my %bad_matrix = read_matrix_only_fail($before);

    #confirm_2(%bad_matrix);

    ### ������ matrix file �� �а��� ������ ���� hetero call �� fail �� ��ü
    my %corrected = read_matrix_qurated( $after, \%bad_matrix );

    ### title
    my @cont  = File2Array($after);
    my $title = shift @cont;
    $title =~ s/^\s+\t|^\t//;

    ### make matrix file
    my %title_hash = Array2Hash( split /\t/, $title );
    make_matrix_file( \%title_hash, "corrected", %corrected );

    # compare two matrix file
    compare_two_matrix( $after, "corrected.txt" );
}

sub compare_two_matrix {
    ### �ΰ��� matrix file �� �ִ´� ###
    my ( $before, $after ) = @_;

    my %before    = read_matrix($before);
    my %corrected = read_matrix($after);

    my ( $line, $match_cnt );

    print "start compare\n";
    foreach my $i ( sort { $a cmp $b } keys %before ) {
        foreach my $j ( sort { $a cmp $b } keys %{ $before{$i} } ) {
            if ( $corrected{$i}{$j} ne $before{$i}{$j} ) {
                $line .= "$i	$j	$before{$i}{$j} -> $corrected{$i}{$j}\n";
            }
            else { $match_cnt++; }

        }
    }
    print "start Writing\nmatch count : $match_cnt\n";
    Write_file( $line, "compare" );
}

sub read_matrix_qurated {
    e("Read qurated matrix file : $_[0]");
    open( F, $_[0] ) || die $!;
    my $cnt;
    my %qurated = %{ $_[1] };
    my %M;

    my @marker;
    while ( chomp( my $l = <F> ) ) {
        $cnt++;
        my @pt = split "	", $l;

        @marker = @pt if $cnt == 1;
        if ( $cnt != 1 ) {
            my $sam = shift @pt;
            foreach my $i ( 0 .. $#pt ) {
                ### title �� ��Ŀ�϶�
                $M{$sam}{ $marker[ $i + 1 ] } = $pt[$i];

                if ( $qurated{$sam}{ $marker[ $i + 1 ] } ) {
                    $M{$sam}{ $marker[ $i + 1 ] } = 5;
                }

                ### title �� �����϶�
          #if ( $qurated{$sam}{$marker[$i+1]} ) { $M{$marker[$i+1]}{$sam} = 5; }
          #print "$marker[$i+1]	$sam	$pt[$i]\n";
            }
        }

    }
    close F;
    return %M;
}

sub read_matrix_only_fail {
    ### fail ��ų ��Ŀ�� ������ Ű�� �ؼ� �����س��´�.

    e("Read matrix file : $_[0]");
    open( F, $_[0] ) || die $!;
    my $cnt;
    my %M;
    my @marker;
    while ( chomp( my $l = <F> ) ) {
        $cnt++;
        my @pt = split "	", $l;

        @marker = @pt if $cnt == 1;
        if ( $cnt != 1 ) {
            my $sam = shift @pt;
            foreach my $i ( 0 .. $#pt ) {
                ### title �� ��Ŀ�϶�
                if ( $pt[$i] == 1 ) { $M{$sam}{ $marker[ $i + 1 ] } = $pt[$i]; }

                ### title �� �����϶�
                #if( $pt[$i] == 1 ){ $M{$marker[$i+1]}{$sam} = $pt[$i]; }
                #print "$marker[$i+1]	$sam	$pt[$i]\n";
            }
        }

    }
    close F;
    return %M;
}

sub matrix2flat {
    my ($file) = @_;

    my @title;
    open( F, $file )         || die $!;
    open( W, ">flat-$file" ) || die $!;
    while ( chomp( my $l = <F> ) ) {
        my ( $sam, @pt ) = split /\t/, $l;
        if ( $. % 1000 == 0 ) { print "line number : $.\n"; }

        if ( $. == 1 ) { @title = @pt; }
        else {
            my @line;
            foreach my $i ( 0 .. $#pt ) {
                push @line, "$sam	$title[$i]	$pt[$i]";
            }
            print W ( join "\n", @line ), "\n";
        }
    }
    close F;
    close W;
}

sub confirm_array_array {
    my @array = @_;
    print "element count :", scalar(@array), "\n";
    foreach my $i (@array) {
        foreach my $j ( @{$i} ) {
            print "$j\n";
        }
        print "\n";
    }
}


sub confirm_2_file_line {
    my ( $name, $key_2, $hash ) = @_;

    ## file name
    ## title �� reference array
    ## hash

    my @key_2 = sort { $a <=> $b } @{$key_2};
    my %tmp = %{$hash};

    open( W, ">$name.txt" ) || die $!;
    my $title = join "	", @key_2;
    print W "	$title\n";

    foreach my $i ( sort { $a cmp $b } keys %tmp ) {

        my @line;
        push @line, $i;
        foreach my $j (@key_2) {
            if ( !$tmp{$i}{$j} ) { $tmp{$i}{$j} = 0; }
            push @line, $tmp{$i}{$j};
        }
        my $line = join "	", @line;
        print W "$line\n";
    }
    close W;
}

sub show_file_list {
    my @file = @_;

    print "\n\n>> file list\n\n";
    foreach my $i ( 0 .. $#file ) {
        print $i+ 1, "	$file[$i]\n";
    }
    print "\n show file list end\n\n";
}

sub make_removed_col_file {
    my ( $file, $col ) = @_;
    my @col = split ",", $col;

    open my $fh, $file           or die "$!";
    open my $W,  ">$file.rm_col" or die "$!";
    while ( chomp( my $l = <$fh> ) ) {
        if ( $. % 10000 == 0 ) { print get_time_detail(), "	number $.\n"; }

        #$l =~ s/\ //g;
        my (@pt) = split /\t/, $l;
        map { splice( @pt, $_ - 1, 1 ); } reverse @col;
        print $W ( join "	", @pt ) . "\n";
    }
    close $fh;
    close $W;
}

sub get_count_from_interval {
    my ( $file, $number, $content, @interval ) = @_;
    my %result;

    foreach my $i ( File2Array($file) ) {
        my @pt = split /\t/, $i;
        my ( $num, $con ) = ( $pt[ $number - 1 ], $pt[ $content - 1 ] );

        foreach my $j (@interval) {
            my ( $s, $e ) = @{$j};
            if ( $s < $num && $e >= $num ) {
                $result{"$s-$e"}{$con}++;
            }
        }
    }

    make_matrix_file_new( "interval_cal", %result );
}

sub get_count_between {
    ## usage : my @interval = get_count_between(92,99,0.5);
    ##	   get_count_from_interval("content.txt",1,2,@interval);

    my ( $start, $end, $interval, $file ) = @_;

    my @interval;
    my $flag = 1;

    my $op = int( ( $end - $start ) / $interval );

    foreach my $i ( 1 .. $op ) {
        my $s = $start + ( $i - 1 ) * $interval;
        my $e = $s + $interval;

        print "start : $s	end : $e\n";
        push @interval, [ $s, $e ];
    }
    return @interval;
}

sub Find_file_from_list($$) {

    my @will_find_list = @{ $_[0] };
    my @all_file_list  = @{ $_[1] };

    my %will_find_list = %{ { map { lc($_) => $_; } @will_find_list } };

    my $line;
    for (@all_file_list) {

        my ( $name, $dir, $prefix ) = fileparse($_);

        #print "$name	$dir	$prefix\n";
        my $temp_name = lc($name);
        $line .= "$dir	$will_find_list{$temp_name}\n"
          if $will_find_list{$temp_name};
    }

    Write_file( $line, "finded_file_list" );
}

sub mv_png {
    my @list   = @{ $_[1] };
    my @target = @{ $_[0] };

    my %target_list = %{ { map { $_ => 1 } @target } };
    make_dir("temp");

    Foreach_hash(%target_list);
    foreach my $i (@list) {
        my ( $file, $dir, $prefix ) = fileparse($i);
        my $name = getfilename($file);

        if ( $target_list{$name} ) {
            print "$i	temp/$file\n";
            rename( $i, "temp/$file" );
        }
    }
}

sub get_filename_from_path($) {

    my @list;
    for ( File2Array( $_[0] ) ) {
        my ( $filename, $dir, $prefix ) = fileparse($_);
        push @list, $filename;
    }
    return @list;
}

sub make_own_dir {
    my $dir = getfilename($0);
    make_dir($dir);
    return $dir;
}

sub HugeMatrixTransform {

    my ( $CreatedFile, $WillTransformedFile ) = @_;
    print "The $CreatedFile file exist and delete it\n" and unlink($CreatedFile)
      if -e $CreatedFile;

    open my $W, ">$CreatedFile"
      or die "cannot write file $CreatedFile $!\n";
    close $W;

    my $size = 111000;

    tie my @list, 'Tie::File', $CreatedFile
      or die "cannot open file $CreatedFile\n";

    my @LineTemp;
    open my $F, $WillTransformedFile
      or die "cannot read file $WillTransformedFile $!\n";

    while (<$F>) {
        chomp;
        my @element = split /\t/;
        $LineTemp[$_] .= "$element[$_]\t" for ( 0 .. $#element );

        if ( $. % $size == 0 || eof $F ) {
            print scalar localtime(), "	line num : $.\n";
            map { $list[$_] .= "$LineTemp[$_]" } 0 .. $#element;
            @LineTemp = ();
        }
        elsif ( $. % 10000 == 0 ) {
            print scalar localtime(), "	line num : $.\n";
        }
    }
    close $F;
    untie @list;
}

sub Is_DefaultFile {
    my $DefaultTitleFile = shift;

    -e $DefaultTitleFile
      ? ( print "Default File : $DefaultTitleFile loaded\n" )
      : (     print "plz insert file TitleFile name\n> "
          and $DefaultTitleFile = <>
          and chomp $DefaultTitleFile );

    return $DefaultTitleFile;
}

sub show_hash_array {
    my %hash = @_;
    map { print "$_ : @{$hash{$_}}\n" } sort { $a cmp $b } keys %hash;
}

sub hash_tab_limited_linux {
    my ( $f, $k, $v ) = @_;

    my %result;
    my @ks = $k =~ /\d+/g;
    my @vs = $v =~ /\d+/g;

    open my $F, $f or die "$f $!";
    while ( chomp( my $l = <$F> ) ) {
        my @pt = split /\t/, $l;
        my $key   = join( "\t", map { $pt[ $_ - 1 ] } @ks );
        my $value = join( "\t", map { $pt[ $_ - 1 ] } @vs );
        $result{$key} = $value;
    }
    close $F;
    return %result;
}

sub h {
    my ( $file, $select_col, $out_form_col ) = @_;

    #print "$file,$select_col,$out_form_col\n";

    my @select = split ",", $select_col;
    my @values = split ",", $out_form_col;
    my @keys;

    my $sub_key   = make_col_function(@select);
    my $sub_value = make_col_function(@values);
    my %temp;
    my ( $cnt, $group );

    open my $F, '<', $file
      or die "Cannot read $file $!\n";
    while (<$F>) {
        chomp;
        my @pt         = split /\t/;
        my $key_text   = &$sub_key(@pt);
        my $value_text = &$sub_value(@pt);

        #print ">key: $key_text\n>value: $value_text\n";

        if ( $out_form_col eq "all" ) { $value_text = $_; }

        if ( $temp{$key_text} ) { $temp{$key_text} .= ",$value_text"; }
        else                    { $temp{$key_text} = $value_text; }
    }
    close $F;

    return %temp;
}

sub WriteMatrixToFile {
    my @Array = @{ +shift };
    my $file  = shift;

    open my $W, '>', $file
      or die "Cannot write $file $!\n";

    for my $row (@Array) {
        print $W join( "\t", @{$row} ), "\n";
    }

    close $W;
}

sub ReadMatrixToArray {
    my @Array;

    open my $F, '<', $_[0]
      or die "Cannot read $_[0] $!\n";
    while (<$F>) {
        chomp;
        my @F = split /\t/;

        map { $Array[ $. - 1 ][$_] = $F[$_] } 0 .. $#F;
    }

    close $F;

    return \@Array;
}


sub read_matrix_list_col_sum {
    my %M;

    for my $file (@_) {
        open my $F, $file
          or die "Cannot read $file\n";

        my $header = <$F>;
        chomp $header;
        my @col = split "\t", $header;

        while (<$F>) {
            chomp;
            my @F = split "\t";

            map { $M{$file}{ $col[$_] } += $F[$_] if $F[$_] =~ /\d+/ } 1 .. $#F;
        }
        close $F;
    }
    return %M;
}

sub read_matrix_list_row_sum {
    my %M;

    for my $file (@_) {
        open my $F, $file
          or die "Cannot read $file\n";

        my $header = <$F>;

        while (<$F>) {
            chomp;
            my @F = split "\t";

            map { $M{ $F[0] }{$file} += $F[$_] if $F[$_] =~ /\d+/ } 1 .. $#F;
        }
        close $F;
    }
    return %M;
}

sub h1c {
    my %h = @_;
    map { print "$_\t$h{$_}" } sort keys %h;
}

sub h1n {
    my %h = @_;
    map { print "$_\t$h{$_}" } sort { $a <=> $b } keys %h;
}

sub v1n {

    # value 2 sort
    my %h = @_;
    map { print "$_\t$h{$_}" } sort { $h{$a} <=> $h{$b} } keys %h;
}

sub v1np {

    # value 2 sort
    my %h = @_;
	my $total;

	map { $sum += $h{$_} } keys %h;
	$h{TotalCount}=$sum;

	for ( sort { $h{$a} <=> $h{$b} } keys %h ){
		
		$percent = sprintf "%.2f", $h{$_} / $sum * 100;
		print join "\t", $_, $h{$_}, $percent;
	}

}

sub v1n2f {

    # value 2 sort
    my $f = shift;
    my %h = @_;
    my $line;

    map { $line .= "$_\t$h{$_}\n" } sort { $h{$a} <=> $h{$b} } keys %h;
    Write_file( $line, $f );
}

sub hist {
    my %h     = @_;
    my $max   = max values %h;
    my $total = sum values %h;

    for my $i ( sort { $a <=> $b } keys %h ) {
        my $per = $h{$i} / $total * 100;
        my $int = int $per;
        my $bar = "|" x $int;
        $accu += $h{$i};
        printf "%10d %10d %10d %10.2f %10.2f\t%s\n", $i, $h{$i}, $accu, $per,
          $accu / $total * 100, $bar;
    }
}

sub histf {
    my %h     = @_;
    my $max   = max values %h;
    my $total = sum values %h;

    for my $i ( sort { $a <=> $b } keys %h ) {
        my $per = $h{$i} / $total * 100;
        my $int = int $per;
        my $bar = "|" x $int;
        $accu += $h{$i};
        printf "%2.2f %10d %10d %10.2f %10.2f\t%s\n", $i, $h{$i}, $accu, $per,
          $accu / $total * 100, $bar;
    }
}

#sub round
#{
#	    my($number) = shift;
#	    return int($number + .5 * ($number <=> 0));
#}


sub histogram
{
  my ($bin_width, @list) = @_;
  my $total = @list + 0;

  # This calculates the frequencies for all available bins in the data set
  my %histogram;
  $histogram{ ceil(($_ + 1) / $bin_width) -1 }++ for @list;

  my $max;
  my $min;

  # Calculate min and max
  while ( my ($key, $value) = each(%histogram) )
  {
    $max = $key if !defined($min) || $key > $max;
    $min = $key if !defined($min) || $key < $min;
  }


  for (my $i = $min; $i <= $max; $i++)
  {
    my $bin       = sprintf("% 10d", ($i) * $bin_width);
    my $frequency_v = $histogram{$i} || 0;
    my $frequency = $histogram{$i}/$total*100 || 0;
    my $percent = sprintf("% 10d", $frequency);
	my $count = sprintf("% 10d", ($frequency_v) );


    $frequency = "#" x $frequency;

    print $bin." ".$count." ".$percent." ".$frequency."\n";
  }

  print "===============================\n\n";
  print "    Width: ".$bin_width."\n";
  print "    Range: ".$min."-".$max."\n\n";
}

sub histogram_tab
{
  my ($bin_width, @list) = @_;
  my $total = @list + 0;

  # This calculates the frequencies for all available bins in the data set
  my %histogram;
  $histogram{ ceil(($_ + 1) / $bin_width) -1 }++ for @list;

  my $max;
  my $min;

  # Calculate min and max
  while ( my ($key, $value) = each(%histogram) )
  {
    $max = $key if !defined($min) || $key > $max;
    $min = $key if !defined($min) || $key < $min;
  }


  for (my $i = $min; $i <= $max; $i++)
  {
    my $bin       = sprintf("%.1f", ($i) * $bin_width);
    my $frequency_v = $histogram{$i} || 0;
	my $per= $histogram{$i}/$total*100 || 0;
    my $frequency = sprintf ("%.2f", $per);
    my $percent = sprintf("%.2f", $frequency);
	my $count = sprintf("%.0f", ($frequency_v) );


    $frequency = "#" x $frequency;

    print join "\t", $bin,$count,$percent,$frequency;
  }

  print "===============================";
  print "Total: $total";
  print "Width: $bin_width";
  print "Range: $min-$max";
}

sub celname
{
	my ($CEL, $num) = @_;
	$CEL =~ /.+_(\d{6})_(\w{2,3})_(.+)\.\w+$/; 
	($set, $well, $id) = ($1,$2,$3); 
	$id =~ s/_(2|3|4|5)$//; 
	@l=(0,$id,$set,$well);
	return $l[$num];
}

sub celname_substitute_id
{
	my ($file, $id, $substituted_id) = @_;
	$file =~ s/$id/$substituted_id/;
				        
	return($file)
}


sub get_date
{
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;

	my $y = sprintf("%04d", $year + 1900);
	my $m = sprintf("%02d", $mon + 1);
	my $d = sprintf("%02d", $mday);
	return($y.$m.$d);
}

sub ToHash
{
	my ($file, $key, $value) = @_;
	my %h;
	$key--;
	$value-- if $value;

	open my $F, '<', $file;
	while(<$F>){
		my @F = split "\t", $_;
		$h{$F[$key]} = defined $value ? $F[$value] : 1
	}
	close $F;
	return %h;

}

sub snpeff3_6 
{ 
   my %h;
   $h{CODON_CHANGE_PLUS_CODON_DELETION}="Exon";
   $h{CODON_CHANGE_PLUS_CODON_INSERTION}="Exon";
   $h{CODON_DELETION}="Exon";
   $h{CODON_INSERTION}="Exon";
   $h{DOWNSTREAM}="Downstream";
   $h{EXON}="Exon";
   $h{FRAME_SHIFT}="Exon";
   $h{INTERGENIC}="Intergenic";
   $h{INTRAGENIC}="Intron";
   $h{INTRON}="Intron";
   $h{NON_SYNONYMOUS_CODING}="Exon";
   $h{NON_SYNONYMOUS_START}="Exon";
   $h{SPLICE_SITE_ACCEPTOR}="SplicingSite";
   $h{SPLICE_SITE_DONOR}="SplicingSite";
   $h{SPLICE_SITE_REGION}="SplicingSite";
   $h{START_GAINED}="Exon";
   $h{START_LOST}="Exon";
   $h{STOP_GAINED}="Exon";
   $h{STOP_LOST}="Exon";
   $h{SYNONYMOUS_CODING}="Exon";
   $h{SYNONYMOUS_STOP}="Exon";
   $h{UPSTREAM}="Upstream";
   $h{UTR_3_PRIME}="UTR";
   $h{UTR_5_PRIME}="UTR";
   return %h
}

sub timediff
{
#	use Date::Parse;
#	use DateTime;
	
	my ($t1, $t2) = @_; # format timestamp = 05/25/2011 05:22:03
	
	my $t1DateTime = DateTime->from_epoch( epoch => str2time( $t1 ) );
	my $t2DateTime = DateTime->from_epoch( epoch => str2time( $t2 ) );
	my $diff = $t2DateTime->subtract_datetime( $t1DateTime );

	my $day = $diff->in_units('days');
	my $hours = $diff->in_units('hours');
	
	return ( "$day days $hours hrs" );

}

sub Month2Num
{
	my ($mon, $len) = @_;
	%mon2num = qw(Jan 1  Feb 2  Mar 3  Apr 4  May 5  Jun 6 Jul 7  Aug 8  Sep 9  Oct 10 Nov 11 Dec 12);

	$mon=(substr($mon,0,3));
	$mon="\u$mon";

	$out=sprintf "%0".$len."d", $mon2num{$mon};
	return( $out );
}

sub ThisYear
{
	return ( (localtime())[5]+1900 )
}

sub ThreeMonthStr_Day2YMD
{
	my ($STR,$delim) = @_;
	# input : Aug 28 08:34:53
	$STR =~ /(\w{3})\s+(\d+)\s+(\d+:\d+:\d+)/;
	($mon,$day,$time)=($1,$2,$3);
	my $d = $delim ? $delim : "/";

	return ( ThisYear().$d.Month2Num($mon,2).$d.$day." ".$time )
	# ouput : 2016/08/28 08:34:53
}

sub geno2chisqure {
    my ( $aa, $ab, $bb ) = @_;
    my $N = $aa + $ab + $bb;
    my $p = ($aa + $ab) > 0 ? (2*$aa + $ab)/(2*$N) : 0;
    my $q = 1 - $p;
    
    my ($eaa, $eab, $ebb) = ( $N * $p**2, $N * 2*$p*$q, $N * $q**2);
    
    my $daa = abs($aa - $eaa) > 0 ? ($aa - $eaa)**2 / $eaa : 0; 
    my $dab = abs($ab - $eab) > 0 ? ($ab - $eab)**2 / $eab : 0; 
    my $dbb = abs($bb - $ebb) > 0 ? ($bb - $ebb)**2 / $ebb : 0; 
    
    my $chi = sprintf "%.2f", ($daa + $dab + $dbb);
#return ($p,$q, $eaa, $eab, $ebb, $daa, $dab, $dbb, $chi);

	$p =  sprintf "%.2f", $p * 100;
	$q =  sprintf "%.2f", $q * 100;

    return ($p,$q,$chi);
}

sub geno2prob {
    my ( $aa, $ab, $bb ) = @_;
    my $N = $aa + $ab + $bb;
    
    my $paa= sprintf "%.2f", $aa > 0 ? $aa / $N * 100 : 0; 
    my $pab= sprintf "%.2f", $ab > 0 ? $ab / $N * 100 : 0;
    my $pbb= sprintf "%.2f", $bb > 0 ? $bb / $N * 100 : 0;
    
    return($paa, $pab, $pbb)
}

sub VCF2BED_0{

	# 0-based bed
	my ($chr, $bp, $ref, $alt, @remain) = @_;

	my $ref_len = length $ref;
	my $var_len = length $alt;
	my $line ;

	if( $ref_len + $var_len == 2 ){
		$line = join "\t", $chr, $bp-1, $bp, (join ";", @remain);
	}elsif( $ref_len == 1 && $var_len >1){
		$line = join "\t", $chr, $bp, $bp, (join ";", @remain);
	}elsif( $ref_len > 1 ){
		$line = join "\t", $chr, $bp-1, $bp + $ref_len, (join ";", @remain);
	}

}


sub VCF2BED_1{
	
	# 1-based bed
	my ($chr, $bp, $ref, $alt, @remain) = @_;

	my $ref_len = length $ref;
	my $var_len = length $alt;
	my $line ;

	if( $ref_len + $var_len == 2 ){
		$line = join "\t", $chr, $bp, $bp, (join ";", @remain);
	}elsif( $ref_len == 1 && $var_len >1){
		$line = join "\t", $chr, $bp, $bp+1, (join ";", @remain);
	}elsif( $ref_len > 1 ){
		$line = join "\t", $chr, $bp, $bp + $ref_len, (join ";", @remain);
	}

}

sub aa_hash {
	%aa_hash=(
	  Ala=>'A',
	  Arg=>'R',
	  Asn=>'N',
	  Asp=>'D',
	  Cys=>'C',
	  Glu=>'E',
	  Gln=>'Q',
	  Gly=>'G',
	  His=>'H',
	  Ile=>'I',
	  Leu=>'L',
	  Lys=>'K',
	  Met=>'M',
	  Phe=>'F',
	  Pro=>'P',
	  Ser=>'S',
	  Thr=>'T',
	  Trp=>'W',
	  Tyr=>'Y',
	  Val=>'V',
	  Sec=>'U',          
	  Pyl=>'O',
	);
	return(%aa_hash)
}

sub snpsift_anno_string_to_4Class {
    my $str=$_[0];
    my $type="";

    if($str =~ /frameshift/){
        $type = "frameshift"

    }elsif($str =~ /missense/){
        $type = "missense"

    }elsif($str =~ /(nonsense|stop_gained)/){
        $type = "nonsense"

    }elsif($str =~ /(splice_acceptor|splice_donor)/){
        $type = "splice"

    }

    return($type)
}

sub oncotator_anno_string_to_4Class {
    my $str=$_[0];
    my $type="";

    if($str =~ /Frame_Shift/i){
        $type = "frameshift"

    }elsif($str =~ /Missense/i){
        $type = "missense"

    }elsif($str =~ /Nonsense/i){
        $type = "nonsense"

    }elsif($str =~ /Splice_Site/){
        $type = "splice"

    }

    return($type)
}

sub show_hash {
    my %h = @_;
    map { print join "\t", $_, $h{$_} } sort keys %h
}




sub show_hash2 {
    my %h = @_;
    my @k1 = sort keys %h;
    
    for my $i (@k1){
        map { print join "\t", $i, $_, $h{$i}{$_} } sort keys %{ $h{$i} }
    }
}


sub show_matrix {
    my %matrix = @_;
    
    my %titles;
    for my $i ( keys %matrix ) {
        @titles{ keys %{ $matrix{$i} } } = undef;
    }

    my @title = sort { $a cmp $b } keys %titles;

	print join( "\t", "probeset_id", @title ), "\n";

	foreach my $i ( sort { $a cmp $b } keys %matrix ) {
   		my @tmp;
	    foreach my $j (@title) {

		#print "$i  $j      $matrix{$i}{$j}\n";
		push @tmp, defined $matrix{$i}{$j}
		? $matrix{$i}{$j}
		: ".";
		}
		print join( "\t", $i, @tmp ), "\n";
	}

}

sub convert_hash2_to_hash1_by_delim {
    my %h = %{ $_[0] };  ## hash2
    my $delim = $_[1] || ",";
    my %h2;
        
    map { $h2{$_} = join "\t", (join $delim, sort keys %{ $h{$_} }), (keys %{ $h{$_} })+0 } sort keys %h; 
    
    return(%h2)
}

sub Alt_Freq {
	my ($A,$B) = split ",", $_[0];
	return( sprintf "%.2f", $B / ($A+$B) * 100 )
}

sub percent { 
	return (sprintf "%.$_[1]f",$_[0]*100) 
}

sub round { 
	sprintf("%.$_[1]f", $_[0]);
}

sub GenoMatchType_detail{

	$geno{"0/0-0/0"} = "rHom";
	$geno{"0/0-0/1"} = "rHomHet";
	$geno{"0/0-1/1"} = "rHomaHom";
	$geno{"0/1-0/0"} = "HetrHom";
	$geno{"0/1-0/1"} = "Het";	
	$geno{"0/1-1/1"} = "HetaHom";		
	$geno{"1/1-0/0"} = "aHomrHom";	
	$geno{"1/1-0/1"} = "aHomHet";	
	$geno{"1/1-1/1"} = "aHom";	
	
	return($geno{join "-", @_} || "UnEval");
}

sub GenoMatchType{

	$geno{"0/0-0/0"} = "Hom";
	$geno{"0/0-0/1"} = "Het";
	$geno{"0/0-1/1"} = "Hom";
	$geno{"0/1-0/0"} = "Het";
	$geno{"0/1-0/1"} = "Het";	
	$geno{"0/1-1/1"} = "Het";		
	$geno{"1/1-0/0"} = "Hom";	
	$geno{"1/1-0/1"} = "Het";	
	$geno{"1/1-1/1"} = "Hom";	
	
	return($geno{join "-", @_} || "UnEval");
}

sub random{
	return( int(rand($_[0]))+1 )
}

sub DMR_make_cov_file{

	my ($tag, $group, $ids, $h) = @_;
	my @ids = @{$ids};
	my %h =   %{$h};

	if( @ids > 1 ){
		map { $file= $h{$_};  print join "\t", $tag, $id, $file, $group } @ids
	}else{
		$id=$ids[0];
		map { $file=$h{$id}; print join "\t", $tag, $id."_".$_, $file, $group } 1,2; 
	}
}


sub fastq2id{

	$_[0] =~/\/.+\/(.+?)_\w{6,8}_L/;
	return($1)
}


sub args2list{

	$_[0] =~ s/\s+//g;
	return( map { --$_ } split ",", $_[0] );
}

sub read_matrix_list_num {

	## += num 
    my %M;

    for my $file (@_) {
        open my $F, $file
          or die "Cannot read $file\n";

        my $header = <$F>;
        chomp $header;
        my @col = split "\t", $header;

        while (<$F>) {
            chomp;
            my @F = split "\t";

            map { $M{ $F[0] }{ $col[$_] } += $F[$_] if $F[$_] =~ /\d+/ }
              1 .. $#F;
        }
        close $F;
    }
    return %M;
}


sub read_matrix_list_string {

	## = "string" 
    my %M;

    for my $file (@_) {
        open my $F, $file
          or die "Cannot read $file\n";

        my $header = <$F>;
        chomp $header;
        my @col = split "\t", $header;

        while (<$F>) {
            chomp;
            my @F = split "\t";

            map { $M{ $F[0] }{ $col[$_] } = $F[$_] } 1 .. $#F;
        }
        close $F;
    }
    return %M;
}


sub isSNVType {
	($ref, $alt) = @_;
	
	if( $ref eq "-" ){
		$type = "Insertion"
	}elsif( $alt eq "-" ){
		$type = "Deletion"
	}elsif( length($ref.$alt) == 2 ){
		$type = "SNP"
	}else{ 
		$type = "MNP"
	}
	
	return $type
}


1;
__END__

perltoc �� perldoc �� ���� ������ ������ document �ε�,
�� �߿��� ���ϴ� ����̳� ������ ��� �ִ��� ã�� ��,
����ϴ� ��ũ��Ʈ

perldoc -t perltoc | perl -nle "print if /�ܾ�/"


� doc ���� ����� ����ϴ� ���

perldoc -t perl | perl -MList::Util=shuffle -nle"/^\s*perl\w/ and push @L,$_;END{print((shuffle@L)[0])}"








sub cancer_gDNA {
        my %h=();

        @gDNA = $_[0] =~ /:(g\.\d+.+?)[\$,]/g;
        map { $h{"$_[1]:$_"} ++ } @gDNA;
        
        return ( join ",", sort keys %h ) 
}

sub cancer_cDNA { 
        my %h=();

        @cDNA = $_ =~ /:(c..+?)[\$,]/g;
        map { $h{$_} ++ } @cDNA;

        return ( join ",", sort keys %h ) 
}


sub cancer_var { 
        my %h=();

        @var = $_ =~ /:(p..+?)[\$,]/g;
        map { $h{ cancer_3to1($_) } ++ } @var;

        return ( join ",", sort keys %h ) 
}

sub cancer_3to1 {

        $var = $_[0];
        %aa=aa_hash();
 
        if( $var=~ /(\w{3})(\d+)_(\w{3})(\d+)ins(\w+)/ ){
                $pre = $aa{$1}.$2."_".$aa{$3}.$4."ins";
                $remain = $5;
                @aa = $remain =~ /(\w{3})/g;

                $str = $pre.(join "", map { $aa{$_} } @aa);
                    #print join "\t", $var, $str, $remain;
        }elsif( $var =~ /(\w{3})(\d+)_(\w{3})(\d+)del/ ){
                $str = $aa{$1}.$2."_".$aa{$3}.$4."del";
        }elsif( $var =~ /(\w{3})(\d+)del/ ){
                    $str = $aa{$1}.$2."del"
        }elsif( $var =~/(\w{3})(\d+)fs/ ){
                    $str = $aa{$1}.$2."fs";
        }elsif( $var =~/(\w{3})(\d+)\*/ ){
                    $str = $aa{$1}.$2."*"
        }elsif( $var =~/(\w{3})(\d+)(\w{3})/ ){
                    $str = $aa{$1}.$2.$aa{$3};
        }

        return $str
}


