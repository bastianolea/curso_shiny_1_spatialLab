
# Aplicaciones interactivas con R y Shiny
## Clase 3

Docente: _Bastián Olea Herrera._ baolea@uc.cl

----
  
En la clase 3 vimos formas de construir interfaces de aplicaciones shiny usando el paquete `{bslib}`.
  
En la carpeta `apps_ejemplo_bslib` hay plantillas para aplicaciones Shiny de tipo columnas, menú, pestañas, sidebar, y tarjetas. Elige la que más creas que sirve para tu proyecto, o combina sus características.

### App campamentos 1
- La aplicación de la clase pasada, pero con modificaciones hechas en css para alterar la apariencia de la aplicación manualmente.
- La tabla se reemplaca por un gráfico `{ggplot2}`.

### App campamentos 2
- La misma aplicación, pero modificada para el formato _tarjetas_ de `{bslib}`.

### App campamentos 3
- La misma aplicación, pero usando el formato `sidebar`, con un tema de `{bslib}` aplicado, tipografías personalizadas, y tema para gráficos de `{thematic}`.
- Funcionalidad de _modal_ o ventana emergente.
- Funcionalidad de notificaciones de Shiny, al cambiar un input, y al cumplirse una condición.
- Tooltips sobre elementos de la interfaz.
- UI creada a partir de un loop de R programado con `{purrr}`, que genera elementos de la interfaz en base a los datos. 

----

## Recursos 

- [Documentación de `{bslib}`](https://rstudio.github.io/bslib/index.html)
- [Blog R-Bloggers](https://www.r-bloggers.com/author/r-on-nicola-rennie/)
- [Tipografías de Google](https://fonts.google.com/)
- [Pares de tipografías](https://www.fontpair.co/all)
- [Pigment: paletas de colores](https://pigment.shapefactory.co)
- [Realtime Colors: simulador de interfaz web con paletas de colores](https://www.realtimecolors.com/?colors=1b110c-f9f4f2-bd7a56-d9ae97-ce8d6a&fonts=Poppins-Poppins)
- [2 Color Combinations: pares de colores](https://2colors.colorion.co)