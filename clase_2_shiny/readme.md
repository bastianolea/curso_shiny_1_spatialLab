
# Aplicaciones interactivas con R y Shiny
## Clase 2

Docente: _Bastián Olea Herrera._ baolea@uc.cl

----
  
En la clase 2 vimos dos aplicaciones Shiny:
  
### App 4: tabla de datos, actualizada
- Actualización de la aplicación de la clase 1.
- La app `app_pobreza.R` crea una app donde el input es el vector de _regiones_ en la base de datos, y el output es la misma tabla del script anterior. La interactividad en la app corresponde a un selector `selectInput` que, en base al vector de las regiones sacado de la base, filtra la base de datos, y genera una tabla con los datos filtrados.
- En esta actualización, agregamos nuevos inputs para modificar el comportamiento de la app: un botón que desactiva/activa los colores de la tabla, y un slider que modifica los decimales de la tabla.
- Además, agergamos un texto que explica los resultados de la región seleccionada, en base a los datos de la tabla.

### App 5: datos de campamentos
- El script `datos_campamentos.R` carga datos en csv y los guarda como `.rds` para la app.
- La app `app_campamentos.R` muestra una tabla de campamentos, con un selector de regiones, que a su vez filtra un selector de comunas, el cual finalmente filtra los datos a mostrarse.
- La app cuenta con un botón que muestra/oculta un texto que describe los resultados, y una alerta que aparece o desaparece en base a los datos de la comuna seleccionada.