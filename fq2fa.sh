perl -nle'
BEGIN{
$/="+\n";}
	m{ 
	 ^@(\w+
	 \n
	 .+)
	 \n
	}xsm;
print ">$1";

' $1 

