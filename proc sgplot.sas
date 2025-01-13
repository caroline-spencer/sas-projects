/****************************************************************************
*
* Project	: BIOS 511
*
* Program name	: lab10_730238605.sas
*
* Author	: Caroline Spencer (CS)
*
* Date created	: 2024-09-30
*
****************************************************************************/

ods pdf file="/home/BIOS511/Output/lab10.pdf";

LIBNAME datalib "~/my_shared_file_links/Data" access=readonly;
LIBNAME mylib "/home/BIOS511/Data";

/* 1. Create horizontal bar chart using depression data set */

title1 "Bed Days by Education Level for Depression Data";
proc sgplot data=datalib.depression;
	hbar education / response=beddays dataskin=gloss stat=mean fillattrs=(color=lavender);
run;
	
/* 2. Create overlaid vertical bar chart for sashelp.cars data set */

title1 "Sum MSRP and Invoice Price by Type of Car";
proc sgplot data=sashelp.cars;
	vbar type / response=msrp stat=sum transparency=0.3 fillattrs=(color=darkblue) outlineattrs=(color=darkblue);
	vbar type / response=invoice stat=sum transparency=0.3 barwidth=0.5 fillattrs=(color=aqua) outlineattrs=(color=aqua);
	yaxis label = "Price (Sum)";
run;

/* 3. Summarize the vs data set and store results in temporary data set */

proc means data=datalib.vs noprint nway;
	class vstestcd vstest visitnum visit;
	var vsstresn;
	output out=work.meanvs mean=/autoname;
run;

/* 4. Create plot with data created in 3 */
title1 "Mean Heart Rate by Visit Number";
proc sgplot data=work.meanvs noautolegend;
	where vstestcd='HR';
	series x=visit y=vsstresn_mean;
	scatter x=visit y=vsstresn_mean / markerattrs=(symbol=starfilled size=10);
	yaxis values=(59.9 to 60.4 by 0.05);
	label vsstresn_mean = 'Heart Rate';
run;

ods _all_ close;