/****************************************************************************
*
* Project	: BIOS 511
*
* Program name	: lab6.sas
*
* Author	: Caroline Spencer (CS)
*
* Date created	: 2024-09-09
*
****************************************************************************/

title1 "BIOS 511 Lab 6";

LIBNAME datalib "~/my_shared_file_links/Data" access=readonly;
LIBNAME mylib "/home/BIOS511/Data";

/* 1. Run PROC MEANS on primary_biliary_cirrhosis data set and request 6 statistics */
title2 "Primary Biliary Cirrhosis Data Statistics";
title3 "(Upper confidence limit of the mean, Lower confidence limit of the mean, Mode, Sum, Range, Number of missing values)";

proc means data=datalib.primary_biliary_cirrhosis uclm lclm mode sum range nmiss;
run;

title3;

/* 2. Run PROC MEANS on diabetes data set */

title2 "Diabetes Data Statistics for Waist and Hip Measurements by Body Frame";

proc means data=datalib. diabetes N sum mean;
	class frame;
	var waist hip;
run;

/* 3. Run PROC MEANS on sashelp.orsales data */

proc means data=sashelp.orsales noprint nway; /* suppress print, highest _type_ value */
	class product_line product_category; /* stats by product line and category */
	var quantity profit total_retail_price; /* anaysis variables */
	where year = 2002; /* subset data to year 2002 */
	output out=orsales_sumstats sum= / autoname; /* request sum statistic with autoname variables */
run;

/* 4. Run PROC PRINT on data set generated in #3 */

title2 "Sum Profit of Sports Products";

proc print data=orsales_sumstats noobs;
	where product_line = "Sports";
	format profit_sum dollar12.2;
	var product_line product_category profit_sum; 
run;
	
/* 5. Modify code from #3 to create new output dataset with sum and mean stats for profit and retail price */

proc means data=sashelp.orsales noprint nway; /* suppress print, highest _type_ value */
	class product_line product_category; /* stats by product line and category */
	var profit total_retail_price; /* anaysis variables */
	where year = 2002; /* subset data to year 2002 */
	output out=orsales_summeanstats sum=sum_profit sum_retail mean= mean_profit mean_retail; /* create variable names (in order of variables in var statement) */
run;

/* 6. Run PROC UNIVARIATE on diabetes data set */

proc sort data=datalib.diabetes out=sorted_diabetes;
	by gender;
run;

title2 "Statistics and Confidence Limit Information for Diabetes Data by Gender";

proc univariate data=sorted_diabetes cibasic;
	by gender;
	var stab_glu;
run;

/* 7. Create histogram of cholesterol by gender with diabetes data set using PROC UNIVARIATE */

title2 "Histogram of Cholesterol Distribution by Gender";

proc univariate data=sorted_diabetes noprint;
	class gender;
	histogram chol;
	inset mean std / position=NE;
run;