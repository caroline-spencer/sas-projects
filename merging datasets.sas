/****************************************************************************
*
* Project	: BIOS 511
*
* Program name	: lab14.sas
*
* Author	: Caroline Spencer (CS)
*
* Date created	: 2024-10-14
*
****************************************************************************/

ods pdf file="/home/u63982526/BIOS511/Output/lab14.pdf";

LIBNAME datalib "~/my_shared_file_links/Data" access=readonly;
LIBNAME mylib "/home/BIOS511/Data";

title1 "BIOS 511 Lab 14";	

/* 1. Create dataset named aedm by merging the dm and ae data sets by subject id */
proc sort data=datalib.dm out=sorted_dm;
	by usubjid;
run;

proc sort data=datalib.ae out=sorted_ae;
	by usubjid;
run;

data mylib.aedm;
	merge sorted_dm sorted_ae;
	by usubjid;
run;


/* 2. Create dataset merging ae and dm by subject id and subset to subjects that do NOT have adverse event */
data temp_aedm;
	merge sorted_dm (in=indm) sorted_ae (in=inae);
	by usubjid;
	if indm=1 and inae=0;
	keep usubjid sex age;
run;


/* 3. Create dataset named aedm2 and subset to subjects that have adverse event */
data mylib.aedm2;
	merge sorted_dm (in=indm) sorted_ae (in=inae);
	by usubjid;
	if indm=1 and inae=1;
run;


/* 4. Create dataset that contains variables usubjid, visitnum, visit, diabp, and sysbp */
	/* a. Create one data set with observations for diabp and one data set with observations for sysbp */
proc sort data=datalib.vs out=sorted_vs;
	by usubjid visitnum;
run;

data dia_bp sys_bp;
	set sorted_vs;
	if vstestcd = 'DIABP' then output dia_bp;
	if vstestcd = 'SYSBP' then output sys_bp;
	keep usubjid visitnum visit vstestcd vsstresn;
run;

	/* b. Create dataset by merging datasets created in a. by merging on subjid and visitnum */
data vs_bp;
	merge dia_bp(rename=(vsstresn=DIABP)) sys_bp(rename=(vsstresn=SYSBP));
	by usubjid visitnum;
	drop vstestcd;
run;



/* 5. Create the same vs_bp dataset as in #4 using one data step */
data vs_bp_2;
	merge sorted_vs(where=(vstestcd='DIABP') rename=(vsstresn=DIABP)) sorted_vs(where=(vstestcd='SYSBP') rename=(vsstresn=SYSBP));
	by usubjid visitnum;
	keep usubjid visitnum visit diabp sysbp;
run;


ods _all_ close;