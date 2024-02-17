*Integrantes

**Lorena Pacora Abanto 20180602
**Ariadna Chávez 20155335
**Luis Valverde Ramos 20191930


* Problema 1

* Importamos las datas

shell curl -o cbp98st.zip "https://www2.census.gov/programs-surveys/cbp/datasets/1998/cbp98st.zip"
unzipfile cbp98st.zip, replace

import delimited "cbp98st.txt", clear
keep if substr(naics,4,3)=="///"
keep fipstate naics emp qp1 ap est
gen year=1998
save cbp98st.dta, replace

shell curl -o cbp99st.zip "https://www2.census.gov/programs-surveys/cbp/datasets/1999/cbp99st.zip"
unzipfile cbp99st.zip, replace

import delimited "cbp99st.txt", clear
keep if substr(naics,4,3)=="///"
keep fipstate naics emp qp1 ap est
gen year=1999
save cbp99st.dta, replace

shell curl -o cbp00st.zip "https://www2.census.gov/programs-surveys/cbp/datasets/2000/cbp00st.zip"
unzipfile cbp00st.zip, replace

import delimited "cbp00st.txt", clear
keep if substr(naics,4,3)=="///"
keep fipstate naics emp qp1 ap est
gen year=2000
save cbp00st.dta, replace

shell curl -o cbp01st.zip "https://www2.census.gov/programs-surveys/cbp/datasets/2001/cbp01st.zip"
unzipfile cbp01st.zip, replace

import delimited "cbp01st.txt", clear
keep if substr(naics,4,3)=="///"
keep fipstate naics emp qp1 ap est
gen year=2001
save cbp01st.dta, replace

shell curl -o cbp02st.zip "https://www2.census.gov/programs-surveys/cbp/datasets/2002/cbp02st.zip"
unzipfile cbp02st.zip, replace

import delimited "cbp02st.txt", clear
keep if substr(naics,4,3)=="///"
keep fipstate naics emp qp1 ap est
gen year=2002
save cbp02st.dta, replace

shell curl -o cbp03st.zip "https://www2.census.gov/programs-surveys/cbp/datasets/2003/cbp03st.zip"
unzipfile cbp03st.zip, replace

import delimited "cbp03st.txt", clear
keep if substr(naics,4,3)=="///"
keep fipstate naics emp qp1 ap est
gen year=2003
save cbp03st.dta, replace

shell curl -o cbp04st.zip "https://www2.census.gov/programs-surveys/cbp/datasets/2004/cbp04st.zip"
unzipfile cbp04st.zip, replace

import delimited "cbp04st.txt", clear
keep if substr(naics,4,3)=="///"
keep fipstate naics emp qp1 ap est
gen year=2004
save cbp04st.dta, replace

shell curl -o cbp05st.zip "https://www2.census.gov/programs-surveys/cbp/datasets/2005/cbp05st.zip"
unzipfile cbp05st.zip, replace

import delimited "cbp05st.txt", clear
keep if substr(naics,4,3)=="///"
keep fipstate naics emp qp1 ap est
gen year=2005
save cbp05st.dta, replace

shell curl -o cbp06st.zip "https://www2.census.gov/programs-surveys/cbp/datasets/2006/cbp06st.zip"
unzipfile cbp06st.zip, replace

import delimited "cbp06st.txt", clear
keep if substr(naics,4,3)=="///"
keep fipstate naics emp qp1 ap est
gen year=2006
save cbp06st.dta, replace

use cbp98st.dta, clear 
append using cbp99st.dta 
append using cbp00st.dta 
append using cbp01st.dta 
append using cbp02st.dta 
append using cbp03st.dta
append using cbp04st.dta 
append using cbp05st.dta
append using cbp06st.dta


* Pregunta 2 

gen post_china=(year>=2001)


* Pregunta 3

gen new_naics= substr(naics, 1,2)
des new_naics
destring new_naics, replace 

gen manuf = new_naics
recode manuf (31 32 33 = 1) (else= 0)

* Pregunta 4 

 label var qp1 "Total First Quearter Payroll"
 label var emp "Total Mid-March Employees"
 label var post_china "China entering the WTO"
 label var manuf "Manufactoring industries"
 label var est "Total Number of Establishments"

 gen emp_post_china= emp if post_china== 1
 gen emp_pre_china= emp if post_china == 0

* Estimamos

 egen emp_manu_pre= mean(emp_pre_china) if manuf ==1
 
 egen emp_manu_post= mean(emp_post_china) if manuf ==1
 
 egen emp_other_pre= mean(emp_pre_china) if manuf == 0
 
 egen emp_other_post= mean(emp_post_china) if manuf == 0
 
 * avenmp_manu_post - avenmp_manu_pre
 
 gen res_manuf= emp_manu_post - emp_manu_pre
 
* avenmp_other_post - avenmp_other_pre
 gen res_other= emp_other_post - emp_other_pre 
 
* Replicamos
 egen res_manuf1 = max(res_manuf)
 
 egen res_other1 = max(res_other)
 
* DID
 
 gen DID = res_manuf1 - res_other1
 
 summarize res_manuf1 res_other1 DID
 
* Los resultados representan una reducción significativa en el empleo en el sector manufacturero, en contraste con el aumento en el empleo en los sectores no manufactureros, sugiere un efecto adverso claro de la entrada de China a la OMC sobre el empleo manufacturero en EE. UU. La magnitud de la estimación DiD (-3292.579) resalta la severidad de dicho impacto.
 

* Pregunta 5 

 gen post_treatment= post_china*manuf
 reg emp post_china manuf post_treatment
 
*La adhesión de China a la OMC resultó en una disminución de 3292.58 puestos de trabajo en el sector manufacturero de Estados Unidos.

* Pregunta 6

gen average= qp1/emp

reg est post_china manuf post_treatment

* La incorporación de China a la OMC provocó una reducción de 52 establecimientos en el ámbito manufacturero estadounidense.

reg  average post_china manuf post_treatment
 
* La inclusión de China en la OMC disminuyó el salario medio en 0.21 unidades de moneda.


* Los resultados muestran que la entrada de China a la Organización Mundial del Comercio (OMC) en 2001 no tuvo un impacto significativo en el número de establecimientos manufactureros en Estados Unidos, aunque sí se observó una tendencia negativa que no alcanzó significancia estadística. No obstante, esta adhesión se asocia con un incremento significativo en el pago promedio a nivel nacional, lo que refleja posiblemente ajustes en sectores fuera de la manufactura.



* Pregunta 7

gen lemp= log(emp)

reg lemp post_china manuf post_treatment

* La regresión confirma un impacto negativo significativo de la entrada de China a la OMC sobre el empleo en el sector manufacturero de EE. UU., destacando una disminución en el empleo en este sector posterior a la entrada de China a la OMC. La falta de significancia estadística en post_china sugiere que el efecto no se extendió uniformemente a través de todos los sectores de la economía.


* Pregunta 8

gen dummy_98=(year==1998)
gen dummy_99=(year==1999)
gen dummy_00=(year==2000)
gen dummy_01=(year==2001)
gen dummy_02=(year==2002)
gen dummy_03=(year==2003)
gen dummy_04=(year==2004)
gen dummy_05=(year==2005)
gen dummy_06=(year==2006)


gen treatment_year_98= dummy_98*manuf

gen treatment_year_99= dummy_99*manuf

gen treatment_year_00= dummy_00*manuf

gen treatment_year_01= dummy_01*manuf

gen treatment_year_02= dummy_02*manuf

gen treatment_year_03= dummy_03*manuf

gen treatment_year_04= dummy_04*manuf

gen treatment_year_05= dummy_05*manuf

gen treatment_year_06= dummy_06*manuf

* Pregunta 9

gen naics3 = substr(naics, 1, 3)

* Generamos el logaritmo del empleo
gen log_emp = log(emp)

* Para la pregunta 10, generamos el logaritmo del número de establecimientos y el pago promedio
gen log_est = log(est)
gen average_pay = qp1 / emp
gen log_average_pay = log(average_pay)

* Instalamos reghdfe 
ssc install reghdfe, replace

* Estimación del estudio de eventos para log(emp)
reghdfe log_emp i.year##i.manuf, absorb(naics3 fipstate) vce(cluster fipstate)

* Los resultados muestran un gran impacto negativo del shock de China en el empleo del sector manufacturero de EE. UU., evidenciado por los coeficientes negativos en las interacciones entre el año y el sector manufacturero después de la entrada de China a la OMC en 2001. Específicamente, antes de la entrada de China a la OMC, en 1999 y 2000, las interacciones año-manufactura ya muestran efectos negativos significativos (-0.0534 y -0.0990, respectivamente, con P<0.000 para ambos), lo que indica que el mercado anticipaba el impacto de la competencia china. Estos efectos se profundizan significativamente después de 2001, con el coeficiente de interacción para 2001 en -0.1383 y una tendencia decreciente hasta alcanzar -0.4183 en 2006, todos significativos al nivel P<0.000.

*Este patrón demuestra que el shock de China tuvo un efecto negativo sustancial en el empleo manufacturero de EE. UU. que no solo fue anticipado por el mercado antes de la adhesión de China a la OMC, sino que también se intensificó en los años posteriores, indicando un impacto a largo plazo. La magnitud creciente de los coeficientes negativos a lo largo del tiempo subraya cómo el impacto no solo fue inmediato sino que también se exacerbó, reflejando un ajuste estructural profundo y prolongado dentro del sector manufacturero estadounidense frente a la competencia china. La significancia estadística y la magnitud de estos coeficientes destacan la relevancia del shock de China como un factor disruptivo en el empleo manufacturero estadounidense, evidenciando efectos tanto a corto como a largo plazo.


* Pregunta 10

* Estimación del estudio de eventos para log(est) / (cómo la entrada de China a la OMC afectó la cantidad de establecimientos manufactureros en los Estados Unidos)
reghdfe log_est i.year##i.manuf, absorb(naics3 fipstate) vce(cluster fipstate)

*El número de establecimientos ha tendido a aumentar a lo largo del tiempo, como se evidencia por los coeficientes positivos y significativos para los años desde 1999 hasta 2006. Sin embargo, cuando se observa la interacción entre el año y el sector manufacturero, los resultados indican un impacto negativo significativo en el número de establecimientos manufactureros para años seleccionados después de 2000. Este impacto negativo se vuelve más pronunciado y significativo desde 2002 en adelante, con el coeficiente más negativo en 2006 (-0.1618), lo que sugiere una aceleración en la reducción del número de establecimientos manufactureros a medida que avanza el tiempo desde la entrada de China a la OMC.


* Estimación del estudio de eventos para log(average_pay) / (impacto en el pago promedio a los empleados dentro del sector manufacturero)
reghdfe log_average_pay i.year##i.manuf, absorb(naics3 fipstate) vce(cluster fipstate)

*Para el pago promedio, los coeficientes de año muestran un aumento significativo en el pago promedio a lo largo del tiempo, indicando un crecimiento general en los salarios. No obstante, la interacción entre el año y el sector manufacturero revela efectos mixtos. En años específicos como 2001, 2002, 2003, 2004, 2005, y 2006, se observa un efecto negativo significativo en el pago promedio dentro del sector manufacturero, siendo más notable en 2006 (-0.0296). Esto indica que, aunque los salarios en general han aumentado, el sector manufacturero ha experimentado un crecimiento salarial menor en comparación con otros sectores.


* Problema 2

*Mujeres solteras de 20-54 con menos de educacion secundaria. 
*grupo más posible afectado por EITC Earned income tax credit

clear

use "C:\Users\arica\OneDrive\Escritorio\Cursos - Qlab\Econometría Avanzada\base.dta",clear

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


