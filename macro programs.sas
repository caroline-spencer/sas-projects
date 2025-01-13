/****************************************************************************
*
* Project	: BIOS 511
*
* Program name	: lab24_730238605.sas
*
* Author	: Caroline Spencer (CS)
*
* Date created	: 2024-11-20
*
****************************************************************************/

%put %upcase(no)TE: Program being run by 730238605; 
options nofullstimer;

ods pdf file="/home/u63982526/BIOS511/Output/lab24_730238605.pdf";

LIBNAME datalib "~/my_shared_file_links/u49231441/Data" access=readonly;
LIBNAME mylib "/home/u63982526/BIOS511/Data";

title1 "BIOS 511 Lab 24";

options mprint;
options mlogic; 
options symbolgen; 

/* Write a macro program that contains the following:
	a. Macro parameters for: libref, data set name, class variable list, analysis variable list, statistic list
	b. Title statement that contains a reference to the macro parameter containing dataset name
	c. Statement to suppress printing of the proc title
	d. Proc means statement that references macro parameters: libref, data set name, statistic list
	e. Class statement that references class variable list macro parameter
	f. Var statement that references analysis variable list macro parameter
	g. Output out= statement that creates a data set with the name of the original dataset then _stats
	h. Proc print step to print data created in g
		subset to _type_ = 1 and _stat_ = min
		var statement with class var list and analysis var list
		create another title statement with new dataset name */

%macro analysis (lib=, ds=, class=, var=, stat=);

	title2 "Analysis of &ds Data Set";
	ods noproctitle;
	proc means data=&lib..&ds &stat;
		class &class;
		var &var;
		output out=&ds._stats;
	run;

	title2 "Printed Output of &ds._stats Data Set";
	proc print data=&ds._stats;
		where _type_ = 1 and _stat_ = "MIN";
		var &class &var;
	run;

%mend analysis;
	
		
/* Execute the macro %analysis with different parameters: */

/* 1. */ %analysis(lib=datalib, ds=order_fact, class=order_type, var=total_retail_price, stat=sum min);		
/* 2. */ %analysis(lib=datalib, ds=diabetes, class=location, var= ratio stab_glu, stat=min max);
/* 3. */ %analysis(lib=datalib, ds=tumor2, class=stage gen, var=tumorsize, stat=sum mean min);	
	

ods _all_ close;