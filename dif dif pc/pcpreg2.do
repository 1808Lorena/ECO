
*Integrantes

**Lorena Pacora Abanto 20180602
**Ariadna Chávez
**Luis Valverde Ramos 20191930


*Mujeres solteras de 20-54 con menos de educacion secundaria. 
*grupo más posible afectado por EITC Earned income tax credit

clear

use "C:/Users/Lorena/Documents/curso python-ML-EC/ECO/dif dif pc/base.dta",clear

**************************************
*1 Table summarizing all data

summarize
table state
describe children

********************************************
*2 Calculate the sample means of all variables for (a) single women with no children, (b) single women with 1 child, and (c) single women with 2+ children

*a) Sin hijos

summarize state year urate nonwhite finc earn age ed work unearn if children ==0

*b) Con 1 hijos

summarize state year urate nonwhite finc earn age ed work unearn if children ==1

*c) Con 2 a más hijos

summarize state year urate nonwhite finc earn age ed work unearn if children >=2

*******************************************
*3) Construct a variable for the “treatment” called anykids (indicator for 1 or more kids) and a variable for time being after the expansion (called post93—should be 1 for 1994 and later)

generate anykids= 1 if children >=1 
replace anykids =0 if missing(anykids)

generate post93 =1 if year >= 1994
replace post93= 0 if missing(post93)

********************************************
*4) Using the “interaction term” diff-in-diff specification, run a regression to estimate the difference-in-differences estimate of the effect of the EITC program on earnings. Use all women with children as the treatment group

gen post_treatment = post93*anykids

reg earn post93 anykids post_treatment, robust

** --Coeficiente de post_treatment -> 1668.678, pvalue de 0.007
**--Coeficiente de constante -> 13798.56, pvalue de 0.000
**--r2: 0.0264

**********************************************

*5) Repeat (iv), but now include state and year fixed effects [Hint: state fixed effects, are included when we include a dummy variable for each state]. Do you get similar estimated treatment effects compared to (iv)

reg earn post93 anykids post_treatment i.state i.year, robust

**-Coeficiente de post_treatment -> 1612.131 pvalue de 0.0089
**-Coeficiente de constante -> 8576.592 , pvalue de 0.000
**-r2:  0.0438  

*Rpta: Aumentó el R cuadrado cuando se aplican los fixes effects de state y year

*****************************************************
*6) Using the specification from (v), re-estimate this model including urate  nonwhite age ed unearn, as well as state and year FEs as controls. Do you get similar estimated treatment effects compared to (v)?

global controls_model "urate nonwhite age ed unearn state i.year i.state"
reg earn post93 anykids post_treatment i.state i.year $controls_model, robust

**-Coeficiente de post_treatment -> 1661.812  pvalue de 0.013. Todavía significativo, pero aumentó el pvalue
**-Coeficiente de constante ->  6843.79, pvalue de 0.009
**-r2:  0.0481 

*Rpta: Aumentó un poco el R cuadrado cuando se aplican los controles

*Como es positivo, se indica un incremento en ingresos para el grupo de tratamiento de mujeres con hijos


***************************************

*7) Estimate a version of your model that allows the treatment effect to vary by those with 1 or 2+ children. Include all other variables as in (vi). Does the intervention seem to be more effective for one of these groups over the other? Why might this be the case in the real world

generate un_hijo= 0 
replace un_hijo = 1 if children==1
gen dos_mas= 0 
replace dos_mas = 1 if children>=2
gen post_treatment2=un_hijo*post93
gen post_treatment3=dos_mas*post93
reg earn un_hijo dos_mas post93 post_treatment2 post_treatment3 $controls_model, robust

**El coeficiente de post_treatment2 es de 2699.664 con un pvalue de 0.002
**El coeficiente de post_treatment3 es de 953.5636 con un pvalue de 0.162, lo que significa que ya no es significativo la intervención

*La intervención es más efectiva para el grupo de solo 1 hijo a diferencia del grupo con 2 hijos a más. Una explicación puede ser porque cuando se tiene más hijos, esto representa más gastos.

*********************************+

*8) Estimate a “placebo” treatment model as follows: Take data from only the pre-reform period (up to and including 1993). Drop the rest, or restrict your model to run only if year <= 1993. Estimate the effect for all affected women together, just as in (vi). Introduce a placebo policy that begins in 1992 (so 1992 and 1993 are both “treated” with this fake policy). What do you find? Are your results “reassuring”?

preserve
keep if year <= 1993
gen post91 = (year>=1992)
gen post_treatment4= anykids*post91
reg earn anykids post91 post_treatment4 $controls_model, robust

restore

*En este caso, el coeficiente de post_treatment4 es de 942.4213 y el pvalue es de 0.250, lo que indica que no es estadísticamente significativo. Entonces, los resultados estarían mostrando que la intervención o el tratamiento realizado en el grupo de mujeres realmente sí tiene validez o impacto, pues al trabajar con un 'placebo' o con datos anteriores a la intevención, se  ve que no hay relevancia.













		
		
		
		
		
		
		
		
		
		
		


















