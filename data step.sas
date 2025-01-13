/****************************************************************************
*
* Project	: BIOS 511
*
* Program name	: lab13.sas
*
* Author	: Caroline Spencer (CS)
*
* Date created	: 2024-10-09
*
****************************************************************************/

ods pdf file="/home/BIOS511/Output/lab13.pdf";

LIBNAME datalib "~/my_shared_file_links/Data" access=readonly;
LIBNAME mylib "/home/BIOS511/Data";

title1 "BIOS 511 Lab 13";	

/* Create new version of 1b data set */

data lb;
	set datalib.lb;
	
	where visit = 'Week 32';
	lbcat = propcase(lbcat);
	length lb_cat_test $100;
	lb_cat_test = catx(': ', lbcat, lbtest);
	keep usubjid visit lbstresn lb_cat_test;
	
run;
	

/* Create new version of learn_modalities data set */

data learn_modalities;
	set datalib.learn_modalities (keep=district_name operational_schools student_count);
	
	avg_students_per_school = (student_count/operational_schools);
	if avg_students_per_school > 2000;
	label avg_students_per_school = "Average Number of Students per Operational School";
	drop operational_schools student_count;
run;


/* Create new version of employee_donations data set */

data employee_donations;
	set datalib.employee_donations;
	
	total = sum(of qtr1-qtr4);
	label total = "Year Total Donation Amount";
run;


/* Run proc freq on sashelp.heart data set with renamed variables */

data heart;
	set sashelp.heart (rename=(chol_status=chol bp_status=bp));
run;
	
title2 "Crosstabulation of Cholesterol and Blood Pressure Status";

proc freq data=heart;
	tables chol*bp;
run;


ods _all_ close;
