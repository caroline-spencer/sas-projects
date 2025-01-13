/****************************************************************************
*
* Project	: BIOS 511
*
* Program name	: lab25_730238605.sas
*
* Author	: Caroline Spencer (CS)
*
* Date created	: 2024-11-25
*
****************************************************************************/

%put %upcase(no)TE: Program being run by 730238605; 
options nofullstimer;

ods pdf file="/home/u63982526/BIOS511/Output/lab25_730238605.pdf";

LIBNAME datalib "~/my_shared_file_links/u49231441/Data" access=readonly;
LIBNAME mylib "/home/u63982526/BIOS511/Data";

options mprint;
options mlogic; 
options symbolgen; 


/* Goal: Use macro program to loop through 5 vital sign tests in vs data set and create reports with proc report based on vs data */

proc sort data=datalib.vs (keep=vstestcd vstest) out=vs nodupkey;
	by vstestcd;
run;

/* create a series of macro variables vstest1-vstestN and vsname1-vsnameN */

data _null_;
	set vs;
	call symputx(cats('vstest', _n_), vstest, 'g');
	call symputx(cats('vsname', _n_), vstestcd, 'g');
run;

%let n=5;

%macro loop;
	%do i=1 %to &n;
		title2 "&&vsname&i";
		proc report data=datalib.vs;
			where vstest = "&&vstest&i";
			column visitnum visit vsstresn;
			define visitnum / order group noprint;
			define visit / order group;
			define vsstresn / analysis mean "Mean Result";
		run;
	%end;
%mend loop;
	
%loop;


ods _all_ close;