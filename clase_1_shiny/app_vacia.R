# hacer una aplicación shiny que esté vacía

# cargar los paquetes
library(shiny)
library(bslib)

# ui
ui <- page_fluid(
  
  p("Bienvenid@s"),
  h1("Mi primera aplicación")
  
  )

# server
server <- function(input, output, session) {
}

shinyApp(ui, server)