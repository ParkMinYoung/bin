sudo mount -t cifs //211.174.205.5/Default /home/adminrig/workspace.min/AFFX/211.174.205.5 -o user=affxuser,password=affxpd
sudo mount -t cifs //211.174.205.19/Default /home/adminrig/workspace.min/AFFX/211.174.205.19 -o user=affxuser,password=affxpd
sudo mount -t cifs //211.174.205.66/Default /home/adminrig/workspace.min/AFFX/211.174.205.66 -o user=affxuser,password=affxpd
sudo mount -t cifs //211.174.205.50/WetData /home/adminrig/workspace.min/211.174.205.50 -o user=minmin3,password=dn@link$
sudo mount -t nfs -o nfsvers=3,rsize=32768,wsize=32768,tcp,intr,retrans=0,bg 211.174.205.75:/ifs/data/microarray /microarray
#sudo mount -t nfs -o  nfsvers=3,rsize=32768,wsize=32768,tcp,intr,retrans=0,bg 211.174.205.75:/ifs/home/wes /home/adminrig/workspace.min/WES 
sudo mount -t nfs -o  nfsvers=3,rsize=32768,wsize=32768,tcp,intr,retrans=0,bg 211.174.205.75:/ifs/data/wes /home/adminrig/workspace.min/WES

sudo /etc/init.d/crond start
sudo /usr/sbin/apachectl start

nohup sh /home/adminrig/workspace.min/AFFX/deamon.sh &

#sudo vi /etc/sysconfig/iptables
#iptables -I INPUT 4 -p tcp -m state --state NEW -m tcp --dport 8787 -j ACCEPT

#grep -e 000041 -e 000042 -e 000044 -e 000047 -e 000050 -e 000052 -e 000054 -e 000059 -e 000060 -e 000062 -e 000068 -e 000069 -e 000070 -e 000072 -e 000074 -e 000077 -e 000076 -e 000098 -e 000099  CEL.matrix.txt

