library(shiny)
library(bslib)

# página con barra de navegación al lado izquierdo
ui <- page_sidebar(
  title = "Aplicación",
  sidebar = div(
    h2("Opciones"),
                p("Opción 1"),
    sliderInput("input", "Mi input", min = 1, value = 5, max = 10)
    ),

  h1("Contenido")
)


server <- function(input, output) {
}

shinyApp(ui, server)