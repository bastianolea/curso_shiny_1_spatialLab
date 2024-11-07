
# Aplicaciones interactivas con R y Shiny
## Clase 1

Docente: _Bastián Olea Herrera._ baolea@uc.cl

----

En la clase 1 vimos tres ejemplos de aplicacions Shiny:

### Ejemplo de app 1: app vacía
- La app `app_vacia.R` corresponde a una aplicación básica Shiny, que solo tiene textos en la UI, y sirve de plantilla para otras aplicaciones.

### Ejemplo de app 2: completada bailable
- El script `completos.R` hace el ejercicio manual de sacar una cuenta o presupuesto
- La app `app_completos.R` traduce el script anterior en una aplicación interactiva

### Ejemplo de app 3: tabla de datos

- El script `obtener_datos_pobreza.R` descarga los datos, los limpia, y guarda el resultado como `dato_pobreza.R`.
- El script `tabla_pobreza.R` hace una tabla con `{gt}` a partir de los datos
- La app `app_pobreza.R` crea una app donde el input es el vector de _regiones_ en la base de datos, y el output es la misma tabla del script anterior. La interactividad en la app corresponde a un selector `selectInput` que, en base al vector de las regiones sacado de la base, filtra la base de datos, y genera una tabla con los datos filtrados.