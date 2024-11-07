library(shiny)
library(bslib)

# página con botones arriba y también sidebar
ui <- page_navbar(
  sidebar = div(
        h2("Opciones"),
                    p("Opción 1"),
        sliderInput("input", "Mi input", min = 1, value = 5, max = 10)
        ),
  nav_panel("Página 1",
            div(
              h2("Contenido 1")
            )),
  nav_panel("Página 2",
            div(
              h2("Contenido 2")
            ))
)


server <- function(input, output) {
}

shinyApp(ui, server)