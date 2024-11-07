library(shiny)
library(bslib)

# página con tarjetas que rellenan el espacio de la aplicación
ui <- page_fluid(
 card(
   card_header("Título"),
   p("Contenido...")
 ),
 card(
   card_header("Título"),
   p("Contenido...")
 ),
 layout_columns(
   card(
     card_header("Título"),
     p("Contenido...")
   ),
   card(
     card_header("Título"),
     p("Contenido...")
   )
 ),
 card(
   card_header("Título"),
   p("Contenido...")
 )
)

server <- function(input, output) {
}

shinyApp(ui, server)