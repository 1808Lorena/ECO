cd "C:\Users\LENOVO\Downloads\PC 3_Econometría"
use "eitc (1).dta",clear

// Summarize all variables in the dataset
summarize
table state
describe children

// (2) 2.	[5 points ] Calculate the sample means of all variables for (a) single women with no children, (b) single women with 1 child, and (c) single women with 2+ children.


// Display the sample means for different groups of single women
list

// (3) Construct variables for treatment and time
gen anykids = children >= 1
gen post93 = year >= 1994
gen post_treatmen= anykids*post93
egen state_numeric = group(state)
egen year_numeric = group(year)
global controls "urate nonwhite age ed unearn i.state_numeric i.year_numeric"

// (4) Run regression using difference-in-differences specification
reg earn anykids post93 post_treatmen

// (5) [7 points ] Repeat (iv), but now include state and year fixed effects [Hint: state fixed effects, are included when we include a dummy variable for each state]. Do you get similar estimated treatment effects compared to (iv)?
tabulate state
reg earn anykids post_treatmen post93 i.state_numeric i.year_numeric 

// (6)[7 points]  Using the specification from (v), re-estimate this model including urate nonwhite age ed unearn, as well as state and year FEs as controls. Do you get similar estimated treatment effects compared to (v)?

reg earn anykids post93 post_treatmen $controls, robust

//7.	[7 points ] Estimate a version of your model that allows the treatment effect to vary by those with 1 or 2+ children. Include all other variables as in (vi). Does the intervention seem to be more effective for one of these groups over the other? Why might this be the case in the real world?

gen onekid= 0 
replace onekid = 1 if children==1
gen twomorekids= 0 
replace twomorekids = 1 if children>=2
gen post_treatmen1=onekid*post93
gen post_treatmen2=twomorekids*post93
reg earn onekid twomorekids post93 post_treatmen1 post_treatmen2 $controls, robust



// 8. 8.	[6 points ] Estimate a “placebo” treatment model as follows: Take data from only the pre-reform period (up to and including 1993). Drop the rest, or restrict your model to run only if year <= 1993. Estimate the effect for all affected women together, just as in (vi). Introduce a placebo policy that begins in 1992 (so 1992 and 1993 are both “treated” with this fake policy). What do you find? Are your results “reassuring”?

preserve
keep if year <= 1993
gen pos91 = (year>=1992)
gen post_treatment3= anykids*pos91
reg earn anykids pos91 post_treatment3 $controls, robust

restore





