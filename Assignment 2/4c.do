clear 

cd "C:\Users\azure\OneDrive\Desktop\school stuff\econ 3210\Assignment 2 Materials-20201009"
use WAGE2

sum wage
scalar wagemean = r(mean)
di wagemean

sum IQ
scalar IQmean = r(mean)
di IQmean

scalar IQsd = r(sd)
di IQsd

*****************

reg wage IQ

*****************

reg lwage IQ