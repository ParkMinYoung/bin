mkdir ClusterReview
ln -s `find $PWD/Analysis.* -type f | grep -e AxiomGT1.calls.txt$ -e AxiomGT1.summary.txt -e SAM$ -e MARKER$` ClusterReview/

#perl `which create_cluster_new.v2.pl` ClusterSignal.txt
