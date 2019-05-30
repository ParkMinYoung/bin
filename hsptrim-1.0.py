#!/usr/bin/env python

# Python version should be 2.7.2 (or equivalent).

######################
##  IMPORT MODULES  ##
######################
import sys, getopt

########################
##  GLOBAL VARIABLES  ##
########################
PROGRAM   = 'hsptrim'
VERSION   = '1.0.0'
COMMAND   = ['se', 'pe']
nQualType = {'illumina': 64, 'sanger': 33, 'phred': 0}
argv      = []

#############
##  USAGE  ##
#############
def usage():
        global PROGRAM, VERSION

        main = '''
Program: %s
Version: %s
Contact: Suk-Jun Kim <juniya23@snu.ac.kr>

Usage:   hsptrim.py <command> [options]

Command: se     Trim single-end reads
         pe     Trim paired-end reads
'''%(PROGRAM, VERSION)

        se = '''
Usage:   hsptrim.py se -f <.fastq> -o <.trm.fastq> -t <quality_type>

Options: -f STR   Input fastq file (required)
         -o STR   Output trimmed fastq file (required)
         -t STR   Type of quality values: illumina(+64), sanger(+33) (required)
         -q INT   Minimum quality to get reward score [30]
         -l INT   Threshold to keep a read based on length after trimming [20]
         -w INT   Reward score [1]
         -e INT   Panelty score [-5]
         -n INT   Rewrite read name and zerofill by INT [10]
'''
        pe = '''
Usage:   hsptrim.py pe -f <_1.fastq> -r <_2.fastq> -o <_1.trm.fastq> -p <_2.trm.fastq> -s <se.trm.fastq> -t <quality_type>

Options: -f STR   Input paired-end fastq file 1 (required, must have same number of records as pe2)
         -r STR   Input paired-end fastq file 2 (required, must have same number of records as pe1)
         -o STR   Output trimmed fastq file 1 (required)
         -p STR   Output trimmed fastq file 2 (required)
         -t STR   Type of quality values: illumina(+64), sanger(+33) (required)
         -s STR   Output trimmed singles fastq file (required)
         -q INT   Minimum quality to get reward score [30]
         -l INT   Threshold to keep a read based on length after trimming [20]
         -w INT   Reward score [1]
         -e INT   Panelty score [-5]
         -n INT   Rewrite read name and zerofill by INT [10]
'''
        print locals()[sys._getframe(1).f_code.co_name]



##########
##  SE  ##
##########
def se(argv):
        global PROGRAM, nQualType

        if len(argv) == 0:
                usage()
                sys.exit()

        sOpt = 'f:o:t:q:l:w:e:n:'
        try: opts, args = getopt.getopt(argv, sOpt)
        except getopt.GetoptError, err:
                sys.stderr.write('\n%s: %s\n'%(PROGRAM, err))
                usage()
                sys.exit()

        opt  = list(sOpt.replace(':', ''))
        bool = [False, False, False, False, False, False, False, False]
        val  = ['',    '',    '',    '30',  '20',  '1',   '-5',  '10' ]
        for o, v in opts:
                try: i = opt.index(o[1])
                except:
                        sys.exit('%s: unhandled option \'%s\''%(PROGRAM, o))
                bool[i] = True
                val[i]  = v

        # check: file name
        if val[0] == '' or val[1] == '':
                sys.exit('%s: You must specify the name of file')

        # check: quality type
        try: nBase = nQualType[val[2]]
        except:
                if val[2] == '':
                        sys.exit('%s: You must specify -t option.'%(PROGRAM))
                else:
                        sys.exit('%s: quality type error: %s'%(PROGRAM, val[2]))

        sName  = val[0].split('.')[0]
        nReads = 0
        nSeek  = 0
        out_f  = open(val[1], 'w')
        for sLine in open(val[0]):
                nSeek += 1
                if nSeek == 1:
                        sID     = sLine[1:].strip()
                elif nSeek == 2:
                        sSeq    = sLine.strip()
                elif nSeek == 4:
                        nSeek   = 0
                        sQual   = sLine.strip()
                        nSpan   = len(sQual) / 2
                        nScore  = map(lambda x: score(ord(x) - nBase, int(val[3]), int(val[5]), int(val[6])), sQual)
                        nLScore = [sum(nScore[0:(i+1)]) for i in xrange(nSpan)]
                        nRScore = [sum(nScore[len(nScore)-(i+1):len(nScore)]) for i in xrange(nSpan)]
                        nFrom   = nLScore.index(min(nLScore)) + 1
                        nTo     = len(sQual)-nRScore.index(min(nRScore)) - 1
                        if nTo - nFrom < int(val[4]): pass
                        else:
                                nReads += 1
                                if bool[7]: sID = '%s_%0*d'%(sName, int(val[7]), nReads)
                                out_f.write('@%s\n%s\n+\n%s\n'%(sID, sSeq[nFrom:nTo], sQual[nFrom:nTo]))
        # end of for 'sLine'


##########
##  PE  ##
##########
def pe(argv):
        global PROGRAM, nQualType

        if len(argv) == 0:
                usage()
                sys.exit()

        sOpt = 'f:r:o:p:s:t:q:l:w:e:n:'
        try: opts, args = getopt.getopt(argv, sOpt)
        except getopt.GetoptError, err:
                sys.stderr.write('\n%s: %s\n'%(PROGRAM, err))
                usage()
                sys.exit(2)

        opt  = list(sOpt.replace(':', ''))
        bool = [False, False, False, False, False, False, False, False, False, False, False]
        val  = ['',    '',    '',    '',    '',    '',    '30',  '20',  '1',   '-5',  '10' ]
        for o, v in opts:
                try: i = opt.index(o[1])
                except:
                        sys.exit('%s: unhandled option \'%s\''%(PROGRAM, o))
                bool[i] = True
                val[i]  = v

        # check: file name
        if val[0] == '' or val[1] == '' or val[2] == '' or val[3] == '' or val[4] == '':
                sys.exit('%s: You must specify the name of file'%PROGRAM)

        # check: quality type
        try: nBase = nQualType[val[5]]
        except:
                if val[5] == '':
                        sys.exit('%s: You must specify -t option.'%PROGRAM)
                else:
                        sys.exit('%s: quality type error: %s'%(PROGRAM, val[5]))

        sName  = val[0].split('_')[0]
        nReads = 0
        nSeek  = 0
        in_f1  = open(val[0])
        in_f2  = open(val[1])
        out_f1 = open(val[2], 'w')
        out_f2 = open(val[3], 'w')
        out_f3 = open(val[4], 'w')

        while 1:

                nSeek += 1
                sLine1 = in_f1.readline()
                sLine2 = in_f2.readline()
                if sLine1.strip() == '' or sLine2.strip() == '': break

                if nSeek == 1:
                        # id check
                        sID1    = sLine1[1:].strip()
                        sID2    = sLine2[1:].strip()
                        bDiff   = map(lambda x, y: x == y, list(sID1), list(sID2))
                        if bDiff.count(False) > 1: sys.exit('%s: ID error'%PROGRAM)
                elif nSeek == 2:
                        sSeq1   = sLine1.strip()
                        sSeq2   = sLine2.strip()
                elif nSeek == 4:
                        nSeek   = 0
                        sQual1  = sLine1.strip()
                        sQual2  = sLine2.strip()
                        nSpan1  = len(sQual1) / 2
                        nSpan2  = len(sQual2) / 2
                        nScore1 = map(lambda x: score(ord(x) - nBase, int(val[6]), int(val[8]), int(val[9])), sQual1)
                        nScore2 = map(lambda x: score(ord(x) - nBase, int(val[6]), int(val[8]), int(val[9])), sQual2)
                        nLScore1 = [sum(nScore1[0:(i+1)]) for i in xrange(nSpan1)]
                        nLScore2 = [sum(nScore2[0:(i+1)]) for i in xrange(nSpan2)]
                        nRScore1 = [sum(nScore1[len(nScore1)-(i+1):len(nScore1)]) for i in xrange(nSpan1)]
                        nRScore2 = [sum(nScore2[len(nScore2)-(i+1):len(nScore2)]) for i in xrange(nSpan2)]
                        nFrom1   = nLScore1.index(min(nLScore1)) + 1
                        nFrom2   = nLScore2.index(min(nLScore2)) + 1
                        nTo1     = len(sQual1)-nRScore1.index(min(nRScore1)) - 1
                        nTo2     = len(sQual2)-nRScore2.index(min(nRScore2)) - 1

                        if nTo1 - nFrom1 >= int(val[7]) and nTo2 - nFrom2 >= int(val[7]):
                                nReads += 1
                                if bool[10]:
                                        sID1 = '%s_%0*d/1'%(sName, int(val[10]), nReads)
                                        sID2 = '%s_%0*d/2'%(sName, int(val[10]), nReads)
                                out_f1.write('@%s\n%s\n+\n%s\n'%(sID1, sSeq1[nFrom1:nTo1], sQual1[nFrom1:nTo1]))
                                out_f2.write('@%s\n%s\n+\n%s\n'%(sID2, sSeq2[nFrom2:nTo2], sQual2[nFrom2:nTo2]))
                        elif nTo1 - nFrom1 >= int(val[7]):
                                nReads += 1
                                if bool[10]: sID1 = '%s_%0*d'%(sName, int(val[10]), nReads)
                                out_f3.write('@%s\n%s\n+\n%s\n'%(sID1, sSeq1[nFrom1:nTo1], sQual1[nFrom1:nTo1]))
                        elif nTo2 - nFrom2 >= int(val[7]):
                                nReads += 1
                                if bool[10]: sID2 = '%s_%0*d'%(sName, int(val[10]), nReads)
                                out_f3.write('@%s\n%s\n+\n%s\n'%(sID2, sSeq2[nFrom2:nTo2], sQual2[nFrom2:nTo2]))
                        else:
                                pass
        # end of for 'sLine'



################
##  FUNCTIONS ##
################
def score(nQual, nCutoff, nReward, nPenalty):
        if nQual >= nCutoff: return nReward
        else: return nPenalty




############
##  MAIN  ##
############
def main():
        global PROGRAM, COMMAND

        try:    sCmd = sys.argv[1]
        except: sCmd = ''

        if sCmd in COMMAND:
                argv = sys.argv[2:]
                globals()[sCmd](argv)
        elif sCmd == '-h' or sCmd == '--help' or sCmd == '':
                usage()
        else:
                sys.stderr.write('%s: command \'%s\' not recognized\n'%(PROGRAM, sCmd))


#############
##  ENTRY  ##
#############
if __name__ == '__main__':
        main()

