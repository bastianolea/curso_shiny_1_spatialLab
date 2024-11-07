library(shiny)
library(bslib)

# página por columnas
ui <- page_fluid(
  fluidRow(
    column(6,
           h1("Contenido 1")
    ),
    column(6,
           h1("Contenido 2")
    )
  )
)

server <- function(input, output) {
}

shinyApp(ui, server)