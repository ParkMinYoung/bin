source /home/jin/src/ngs-analysis/ngs.config.sh

BAMFILES=$@

# Create symlinks to bam files in bam directory
mkdir bam
for file in $BAMFILES; do
  absbam=`readlink -f $file`
  ln -s $absbam bam/
done

# Create index
for file in `ls bam/*bam`; do
  qsub_jn.sh snu.byj.bamindex 1 picard.buildbamindex.sh $file
done

# Wait for bam index to finish
qsub_wrapper.sh snu.byj.wait4bamindex \
                $Q_HIGH \
                1 \
                snu.byj.bamindex \
                y \
                hello_world.sh

# Create symlink of bai to bam.bai files
bam.linkindex.sh bam/*bam

# Get list of bamfiles and create bamlist
ls bam/*bam | python_ngs.sh detect_normal_tumor_pairs.py > bamlist
paste <(cut -f1 bamlist | cut -f2 -d'/' | cut -f1 -d'_') bamlist > foo
mv -f foo bamlist

# Run varscan
/home/adminrig/workspace.jin/SNU.BYJ.proton.varscan.20131125.autoscript/scripts/ngs.pipe.somatic.varscan.ge.sh \
  bamlist \
  $HG_REF \
  0.05 \
  0.8 \
  8 \
  8 \
  0.9 \
  0.25 \
  0.05 \
  0.20 \
  3 \
  1 \
  0.17 \
  0.05 \
  0.07

sleep 300

# Wait for varscan pipeline to finish
qsub_wrapper.sh snu.byj.wait4varscan \
                $Q_HIGH \
                1 \
                snu.byj.varscan* \
                y \
                hello_world.sh

# COUNTS SUMMARY =======================================================================================================

echo "======================================"
echo " Generating Counts summary"
echo "======================================"

qstat

DIRNAME=varscan

for file in `ls $DIRNAME/*snp`; do grep Somatic $file > $file.grepsomatic ; done
for file in `ls $DIRNAME/*snp.fpfilter.pass`; do grep Somatic $file > $file.grepsomatic ; done
for file in `ls $DIRNAME/*snp.fpfilter.pass.somaticfilter`; do grep Somatic $file > $file.grepsomatic ; done
paste \
  <(wc -l $DIRNAME/*snp.grepsomatic | head -n -1) \
  <(wc -l $DIRNAME/*snp.fpfilter.pass.grepsomatic | head -n -1) \
  <(wc -l $DIRNAME/*snp.fpfilter.pass.somaticfilter.grepsomatic | head -n -1) \
  <(wc -l $DIRNAME/*snp.fpfilter.pass.somaticfilter.procsom.dp | head -n -1) \
  | python -c "import sys; rows = (line.strip().split() for line in sys.stdin); [sys.stdout.write('%s\n' % '\t'.join([row[0],row[2],row[4],str(int(row[6])-1)])) for row in rows]" \
  > $DIRNAME/counts.summary.snp


for file in `ls $DIRNAME/*indel`; do grep Somatic $file > $file.grepsomatic ; done
for file in `ls $DIRNAME/*indel.fpfilter.pass`; do grep Somatic $file > $file.grepsomatic; done
paste \
  <(wc -l $DIRNAME/*indel.grepsomatic | head -n -1) \
  <(wc -l $DIRNAME/*indel.fpfilter.pass.grepsomatic | head -n -1) \
  <(wc -l $DIRNAME/*indel.fpfilter.pass.procsom.dp | head -n -1) \
  | python -c "import sys; rows = (line.strip().split() for line in sys.stdin); [sys.stdout.write('%s\n' % '\t'.join([row[0],row[2],str(int(row[4])-1)])) for row in rows]" \
  > $DIRNAME/counts.summary.indel

# Get sample ids as well, for building table
wc -l $DIRNAME/*indel.grepsomatic | cut -f2  -d'/'  | cut -f1 -d'.' | head -n -1 > varscan/counts.summary.sampleids


# Generate tiers files ====================================================================================================

mv varscan varscan.filter

DIRNAME=varscan.filter

# SNPS
for file in `ls $DIRNAME/*varscan.snp`; do
sample=`echo $file | cut -f2 -d'/' | cut -f1 -d'.'`
f1=$file.grepsomatic
f2=$file.fpfilter.pass.grepsomatic
f3=$file.fpfilter.pass.somaticfilter.grepsomatic
f4=$file.fpfilter.pass.somaticfilter.procsom.dp
python -c "import sys;
load_rows = lambda filename: set([line.strip() for line in open(filename)]);
f2set = load_rows('$f2');
f3set = load_rows('$f3');
f4set = load_rows('$f4');
test_f2set = lambda line: True if line in f2set else False;
test_f3set = lambda line: True if line in f3set else False;
test_f4set = lambda line: True if line in f4set else False;
tests = [test_f4set, test_f3set, test_f2set, lambda x: True];
get_rank_of_test = lambda line: [test(line.strip()) for test in tests].index(True) + 1;
get_first3cols = lambda line: [line.strip().split()[0], str(int(line.strip().split()[1]) - 1), line.strip().split()[1]];
process_line = lambda line: get_first3cols(line) + [str(get_rank_of_test(line))];
[sys.stdout.write('%s\n' % '\t'.join(process_line(line))) for line in open('$f1')];
" > $DIRNAME/$sample.variant_tiers.snp
done


# INDELS
for file in `ls $DIRNAME/*varscan.indel`; do
sample=`echo $file | cut -f2 -d'/' | cut -f1 -d'.'`
f1=$file.grepsomatic
f2=$file.fpfilter.pass.grepsomatic
f3=$file.fpfilter.pass.procsom.dp
python -c "import sys;
load_rows = lambda filename: set([line.strip() for line in open(filename)]);
f2set = load_rows('$f2');
f3set = load_rows('$f3');
test_f2set = lambda line: True if line in f2set else False;
test_f3set = lambda line: True if line in f3set else False;
tests = [test_f3set, test_f2set, lambda x: True];
get_rank_of_test = lambda line: [test(line.strip()) for test in tests].index(True) + 1;
get_end_pos_deletion = lambda line: str(int(line.strip().split()[1]) + len(line.strip().split()[3]) - 1);
get_end_pos_insertion= lambda line: str(int(line.strip().split()[1]) + 1);
get_end_pos = lambda line: get_end_pos_deletion(line) if line.strip().split()[3][0] == '-' else get_end_pos_insertion(line);
get_first3cols = lambda line: [line.strip().split()[0], line.strip().split()[1], get_end_pos(line.strip())];
process_line = lambda line: get_first3cols(line) + [str(get_rank_of_test(line))];
[sys.stdout.write('%s\n' % '\t'.join(process_line(line))) for line in open('$f1')];
" > $DIRNAME/$sample.variant_tiers.indel
done

