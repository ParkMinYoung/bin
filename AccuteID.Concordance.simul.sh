for i in 10 15 20 25 30 35 40 45 50;
	do
		for j in 0.5 0.1 0.15 0.2 0.25 0.3 0.35 0.4;
			do
			echo "AccuteID.DepthOfCoverage.report.Parsing.sh $i $j";
			AccuteID.DepthOfCoverage.report.Parsing.sh $i $j
			
			DIR=DP$i.Het$j
			FILE=DepthOfCoverage.report2Genotype.$DIR.txt

			mkdir $DIR && mv $FILE $DIR
			(cd $DIR;
			 ln -s ../TrueSet.txt ./;
			 Concordance.sh $FILE TrueSet.txt
			)
			done
	done

AccuteID.Concordance.simul.summary.sh	

