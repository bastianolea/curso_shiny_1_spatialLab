library(shiny)
library(bslib)

# página con pestañas
ui <- page_fillable(
  navset_card_tab(
      nav_panel("Página 1",
                div(
                  h2("Contenido 1")
                )),
      nav_panel("Página 2",
                div(
                  h2("Contenido 2")
                ))
  )
)


server <- function(input, output) {
}

shinyApp(ui, server)