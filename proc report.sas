/****************************************************************************
*
* Project	: BIOS 511
*
* Program name	: lab7.sas
*
* Author	: Caroline Spencer (CS)
*
* Date created	: 2024-09-11
*
****************************************************************************/

title1 "BIOS 511 Lab 7";

LIBNAME datalib "~/my_shared_file_links/Data" access=readonly;
LIBNAME mylib "/home/BIOS511/Data";

/* 1. Create a detailed report based on the learn_modalities data set */

title2 "Detailed Report of Learning Modalities in Arizona School Districts";

proc report data=datalib.learn_modalities (obs=50);
	where state = "AZ";
	column district_name ('Learning Modality and Enrollment by District' learning_modality student_count);
run;

/* 2. Create a summary report based on diabetes data set */

title2 "Summary Report of Body Measurements by Location for Diabetes Data";

proc report data=datalib.diabetes;
	column location frame waist hip;
	define location / group "Location";
	define frame / group "Body Frame";
	define waist / max "Maximum Waist Measurement";
	define hip / max "Maximum Hip Measurement";
run;

/* 3. Create report based on budget data */

title2 "Budget Data Report by Department for 2018-2020";

proc report data=datalib.budget;
	column department, (yr2018-yr2020);
	define department / across '';
run;

/* 4. Create summary report based on employee_donations data */

title2 "Summary Report of Employee Donations";

proc report data=datalib.employee_donations;
	column paid_by qtr1-qtr4;
	define paid_by / group;
	format qtr1-qtr4 dollar8.;
	define qtr4 / style (column)=[background=lightyellow];
run;

/* 5. Create a report based on sashelp.cars data set */

title2 "Number of Cars by Origin and Type";

options missing=0;

proc report data=sashelp.cars;
	column origin type, n;
	define origin / group "";
	define type / across "";
	define n / "";
run;