# HappyNurse
Job scheduling algorithm for hospital

This implementation assumes constant work load. Schedule is generated for 28 days, 4 week. Week starts with Sunday.  Work load on Saturday and Sunday are fixed hence not handled here. There are two type of resource available CC and MS. Each nurse has to work minimum 2 days in a week and maximum 3 day in a week, Total number of working day per 4 week is 9 (Excluding the Saturday and Sunday). There is constraint on minimum number of nurse and type of nurse working in a day. The algorithm considers the choice given by nurse, leave request and arrives at the schedule that aligns as much as possible with the given preference.

Input
----------
Input is given in as modelSchedule.csv, present under the Data directory. Each row corresponds to one resource (Nurse). First two columns are name and type of resource, Remaining 28 column corresponds to user preference.
Values in modelSchedule.csv can be filled with any one of the following values. -2 leave request are hard constraint whereas -1/1 are just preferences which can be overridden. The matrix will be largely sparse, so leaving it blank mean 0 (No preference).
-2: Leave
-1: Requested not to work
0: Ready to work/not work (No preference)
1: Requested to work
BLANK: Equivalent to 0.

Output
--------
Output will written to Solution _ YYYY-MM-DD_HH-MM-SS.csv. It has same structure as that of input. Cells are filled with one or zero. One means resource has to work on that day, Zero mean need not work. Also a satisfaction rate is generated.

Technical Model Details – In Simple English.
--------
Integer Linear Programming (ILP) is used to arrive at the schedule. The decision variable can take a value one or zero means resource has to work or not. Twenty variables are used for each resource (5 week days * 4 weeks). So total number of decision variables 20 * number of resource.

User given preference -2, -1, 0 and 1 are used as objective function coefficient. Maximizing the objective function leads to align the schedule with the user given preference.

For each resource following constricts are used. Total of 9 constraint per resource, 4 minimum, 4 maximum and one equality constraint.  
2 <= No. of Work day per Week <= 3  
Total workday per month == 9  
Resource per day >= Required number; 20 such constraint one for each day  
Type1 Resource per day >= Required number; 20 such constrint one for each day  
Then hard leave constraint  

This optimization problem is quite a hard one, with the advent of computational advancement and availability of solvers we are able to solve this.
Used lpSolve 5.6.13 available in R as ILP solver.
