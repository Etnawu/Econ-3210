clear all
set more off

************
//Open data* 
************
*You do not need to execute the next two lines if you are opening the data manually (File -> Open, etc.)
*If you want to execute the next two lines,  you'll need to change the directory (after the "cd") to the where your data is. 
cd "C:\Users\azure\OneDrive\Desktop\school stuff\econ 3210\Assignment 1 Materials -20200921" 
use all_BGS_data_v13, clear

*keeping only students from the Bloom high school part of the experiment 
keep if session == "Bloom 2009 spring" | session == "Bloom 2009 winter" | session == "Bloom 2010"





*What are the values for the grouping variable? (Treatments vs. Control)
/*
Note: the experiment was run for two different years and the variables are coded
a little differently in each year. Lets' see:
*/

tab  treatment_full_name treatment if session == "Bloom 2009 spring" | session == "Bloom 2009 winter"
*What did we just learn?
/*
Treatment in the 2009 sessions was as follows:

D_i = INF : if the student was offered a low financial reward $10
D_i = INH : if the student was offered a high financial reward $20
D_i = NS  : if the student was told nothing and offered nothing (control group)
*/

tab  treatment_full_name treatment if session == "Bloom 2010"
*What did we just learn?
/*
Treatment in the 2010 session was as follows:

D_i = INLH : if the student was offered a high financial reward $20 but it was framed as a loss
D_i = INH  : if the student was offered a high financial reward $20
D_i = INC  : if the student was told nothing and offered nothing (control group)
*/

*Finally we can look at both 2009 and 2010 pooled, if we want (don't need to):
tab  treatment_full_name treatment 


*************************************************
*************************************************
*************************************************

	//		Problem Set 1, Question 2		//

*************************************************
*************************************************
*************************************************
list id in 1/5
*******
//Part A
*******
*Let's generate an indicator variable for the control group.
*Generate a variable equal to one if the student is in the control group 
*in either 2009 or 2010:
gen control = treatment=="INC" | treatment=="NS" 


*Let's generate an indicator variable for the low incentive treatment group.
*Generate a variable equal to one if the student is in the
*low incentive treatment group, which was only constructed in the 2009 trial:
gen low_incentive = treatment=="INF"

*Now we can get some conditional means


/*
***************************
*A little note that may prove helpful throughout:

Stata's commands store certain results in memory until you execute a new command.

The "sum" command, for example,  will store the following objects as scalars:

r(N) number of observations 				
r(mean) mean 
r(sd) standard deviation	
r(Var) variance							
r(sum) sum of variable	
r(sum_w) sum of the weights 				
r(min) minimum 								
r(max) maximum 			
r(skewness) skewness (detail only) 						
r(kurtosis) kurtosis (detail only)			 				
r(p1) 1st percentile (detail only)						
r(p5) 5th percentile (detail only) 
r(p10) 10th percentile (detail only) 
r(p25) 25th percentile (detail only)
r(p50) 50th percentile (detail only)						
r(p75) 75th percentile (detail only)						
r(p90) 90th percentile (detail only)
r(p95) 95th percentile (detail only)
r(p99) 99th percentile (detail only)


Therefore, if I want to save a number after a command for Stata to keep storing,
I would create a new scalar to tell Stata what to remember it as. 

Say I wanted to save the sample mean of the variable called x. 

The command

"sum x"

will summarize x.

The command s 

"scalar mean_of_x = r(mean)"

typed right after "sum x" will create a scalar that Stata stores, called 
"mean_of_x", and this scalar will be the sample mean of x. 

You can also perform simple maninpulation of scalars. Say you also had another 
scalar called "mean_of_y". Then you could create the sum as another scalar. The 
command: 

"scalar sum_of_meanxy = mean_of_x + mean_of_y"

will do it. 
***************************
*/


*Note that the free lunch variable in this data set is "free_reduced"


*First, the control group:
sum free_reduced if control==1
scalar n_c = r(N)
scalar mean_c = r(mean)
di mean_c

*Second, the low incentive treatment group:
sum free_reduced if low_incentive==1
scalar mean_l = r(mean)
di mean_l

*I have got you started, now you finish...

**a is already answered


*******
//Part B (hint: continue using scalars)
*******
*?
*?

sum free_reduced if control==1 | low_incentive==1
scalar var_a = r(Var)
di var_a

*******
//Part C (hint: continue using scalars and simple operations with them)
*******
*?
*?

scalar difference_l_c = mean_l - mean_c
di difference_l_c


*******
//Part D (hint: continue using scalars and simple operations with them)
*******
**First, get the control group N_c:
*?
*?

sum free_reduced if control==1
scalar n_c = r(N)
di n_c

**Second, the low incentive treatment group N_L:
*?
*?

sum free_reduced if low_incentive==1
scalar n_l = r(N)
di n_l



**Third, variance is then:
*?
*?

scalar estimator_diff = var_a*(1/n_l+1/n_c)
di estimator_diff

*******
//Part E
*(hint1: continue using scalars and simple operations with them)
*(hint2: look at the Project STAR data and files to see the command for how we did hyp tests in Stata)
*******
*?
*?

gen l_vs_c= control== 1 if control==1 | low_incentive==1 
ttest free_reduced, by (l_vs_c)



*Lvsc = 1 when control is 1 and 0 when low_incentive is 1, i dont know how this is working but hopefully its correct*

*************************************************
*************************************************
*************************************************

	//		Problem Set 1, Question 3		//

*************************************************
*************************************************
*************************************************

*Note: test score is given by "current_score_t" in this data set

*******
//Part A
*******
*?
*?

ttest current_score_t, by (l_vs_c)

*******
//Part B
*******
*Let's generate an indicator variable for the high incentive treatment group.
*Generate a variable equal to one if the student is in the
*high incentive treatment group, which was constructed in the 2009 & 2010 trials
*(as mentioned in the problem set, include students who had high incentives framed as
*losses in this group as well):
gen high_incentive = treatment=="INH" | treatment=="INLH"

*Now you can keep going much like in the Project STAR example...
*?
*?

gen h_vs_c= control== 1 if control==1 | high_incentive==1 
ttest current_score_t, by (h_vs_c)

*******
//Part C
*******
/*
*Regressions in Stata are run by the command

"reg y x"

we did an example of a regression in the first lecture and in the do file 
called "CPS Returns to Schooling Example"

You can also run a regression on only a sample that meets certain criteria. Say
the sample that has variable z==1 or variable c==1. That would be:

"reg y x if z==1 | c==1"
*/

*Now you can keep going 
*?
*?

reg current_score_t high_incentive if control==1|high_incentive==1

* I honestly dont really understand regression, hopefully this works 8)
* Ethan wu, 215551955 

