/****************************************************************************
*
* Project	: BIOS 511
*
* Program name	: lab11.sas
*
* Author	: Caroline Spencer (CS)
*
* Date created	: 2024-10-02
*
****************************************************************************/

ods pdf file="/home/BIOS511/Output/lab11.pdf";

LIBNAME datalib "~/my_shared_file_links/Data" access=readonly;
LIBNAME mylib "/home/BIOS511/Data";

/* 1. Create panel of hbox plots using prostate data with proc sgpanel */

title1 "Prostate Tumor Size by Treatment and Stage";

proc sgpanel data=datalib.prostate;
	panelby treatment stage / columns=4 ;
	where tumorsize not = -9999;
	hbox tumorsize / outlierattrs=(color=red) displaystats=(mean);
run;

/* 2. Create panel of histograms with density curves using preemies data set with proc sgpanel */

title1 "Histogram of Birth Weight by Sex";

proc sgpanel data=datalib.preemies noautolegend;
	panelby sex / novarname;
	histogram bw;
	density bw / lineattrs=(color=purple);
	label bw='Birth Weight';
	rowaxis values=(0 to 50 by 10) label='Percent (%)';
run;

/* 3. Create same histogram/density curve as #2 using proc sgplot for comparison */

proc sort data=datalib.preemies out=work.preemies;
	by sex;
run;

proc sgplot data=work.preemies noautolegend;
	by sex;
	histogram bw;
	density bw / lineattrs=(color=purple);
	label bw='Birth Weight';
	yaxis values=(0 to 50 by 10) label ='Percent (%)';
	options nobyline;
	title2 '#byvar1 = #byval1 for this graph';
run;


ods _all_ close;