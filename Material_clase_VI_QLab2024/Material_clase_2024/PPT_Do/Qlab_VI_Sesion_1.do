
/*---------------------------
----QLAB - PUCP -------------
-- Econometría Aplicada -----
---- Avanzada ---------------
-----------------------------
---- Sesión 1 ---------------
-- Aplicación -  Card (1993)-
-----------------------------
-- César Mora - 2024 --------
-----------------------------*/

use "card",clear

/*---------------
- Regresión MCO -
-----------------*/

* Esta regresión omite la endogeneidad de la variable explicativa de educación:

reg lwage educ,robust

* Por dicho motivo, la estimación de beta será sesgada


/*---------------------------------------------------
- Regresión con variable instrumental de proximidad -
----------------------------------------------------*/

* Usaremos como instrumento a la variable "nearc4", la cual es una variable dummy que toma el valor 1 si había cerca una escuela de 4 años, cerca del lugar de residencia del individuo

ivregress 2sls lwage (educ=nearc4),robust    
 * corre educacion q depende d nearc4*
 *ESTA ES LA LINEA FINAL LA Q PUEDES USAR PA CALCULAR

* Mostrando las dos etapas:

ivregress 2sls lwage (educ=nearc4), first robust

* first es muestrame la 1 etapa!!! salen 2 tablas

/*-----------------------------
- Dos etapas de manera manual -
--------------------------------*/

* Primera etapa:   educacion con Z, y sale estimado de educacion sombrero
reg educ nearc4,robust
predict educ_est         
* ahora predictea educ sombrero o educ estimado, permite eliminar endogeneidad 

* Segunda etapa:
reg lwage educ_est,robust      
*agarro loc y lo corro con educ estimada
*agarra y = educ con sombrero

