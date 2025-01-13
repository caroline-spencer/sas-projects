/****************************************************************************
*
* Project	: BIOS 511
*
* Program name	: lab15.sas
*
* Author	: Caroline Spencer (CS)
*
* Date created	: 2024-10-21
*
****************************************************************************/

ods pdf file="/home/BIOS511/Output/lab15.pdf";

LIBNAME datalib "~/my_shared_file_links/Data" access=readonly;
LIBNAME mylib "/home/BIOS511/Data";

title1 "BIOS 511 Lab 15";	

/* 1. Create data set merging ae and dm data sets. 
	Use if statement to:
	a. Assign numeric indicator variable of 0 or 1 indicating if subject had adverse event 
	b. Create character categorical variable based on serious, severity, outcome variables */
proc sort data=datalib.ae out=sorted_ae;
	by usubjid;
run;

proc sort data=datalib.dm out=sorted_dm;
	by usubjid;
run;

data aedm;
	merge sorted_dm sorted_ae (in=inae);
	by usubjid;

	label adverse_event = "Occurence of adverse event boolean";
	
	if inae = 1
		then adverse_event = 1;
	if inae = 0
		then adverse_event = 0;
		
	length category $20;
	label category = "Category of adverse event derived from serious, severity, outcome variables";
		
	if aeser = 'Y' and aesev = 'SEVERE' and (aeout = 'NOT RECOVERED/NOT RESOLVED' or aeout = 'RECOVERING/RESOLVING')
		then category = 'Very Bad';
	else if aeser = 'Y' and (aesev = 'MODERATE' or aesev = 'MILD')
		then category = 'Bad';
	else if aeser = 'N' and aesev = 'SEVERE' and (aeout = 'NOT RECOVERED/NOT RESOLVED' or aeout = 'RECOVERING/RESOLVING')
		then category = 'Not Good';
	else if  aeser = 'N' and (aesev = 'MODERATE' or aesev = 'MILD')
		then category = 'Acceptable';
	else
		category = 'N/A';
run;


/* 2. Use proc freq to check results for variables in #1 - have counts for all 5 categories */
title2 "Frequency of Adverse Event Categories";

proc freq data=aedm;
	tables category;
run;


/* 3. Create same dataset as #1 using select statement */
data aedm2;
	merge sorted_dm sorted_ae (in=inae);
	by usubjid;

	label adverse_event = "Occurence of adverse event boolean";
	
	select (inae);
		when(1) adverse_event = 1;
		when(0) adverse_event = 0;
		otherwise;
	end;
	
	length category $20;
	label category = "Category of adverse event derived from serious, severity, outcome variables";
		
	
	select;
	 	when (aeser = 'Y' and aesev = 'SEVERE' and (aeout = 'NOT RECOVERED/NOT RESOLVED' or aeout = 'RECOVERING/RESOLVING'))
			category = 'Very Bad';
		when (aeser = 'Y' and (aesev = 'MODERATE' or aesev = 'MILD'))
			category = 'Bad';
		when (aeser = 'N' and aesev = 'SEVERE' and (aeout = 'NOT RECOVERED/NOT RESOLVED' or aeout = 'RECOVERING/RESOLVING'))
			category = 'Not Good';
		when (aeser = 'N' and (aesev = 'MODERATE' or aesev = 'MILD'))
			category = 'Acceptable';
		otherwise category = 'N/A';
	end;
run;


/* 4. Use proc compare to check that data sets have all the same values */
title2 "Compare Data Outputs Using IF vs SELECT Statements";

proc compare base = aedm comp = aedm2;
run;

ods _all_ close;
