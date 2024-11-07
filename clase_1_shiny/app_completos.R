# hacer una aplicación shiny que permita cambiar el cálculo a partir de inputs
# cargar los paquetes

library(shiny)
library(bslib)


# ui
ui <- page_fluid(
  h1("Completada"),
  
  sliderInput("completo_precio",
              "Precio del completo",
              min = 1000, max = 5000,
              value = 3000, step = 500),
  
  sliderInput("personas_n",
              "Personas",
              min = 1, max = 50,
              value = 4, step = 1),
  
  sliderInput("completos_por_persona",
              "Completos por persona",
              min = 1, max = 50,
              value = 4, step = 1),
  br(),
  strong("Total:"),
  
  textOutput("texto_total")
)


# server
server <- function(input, output, session) {
  
  completos_cantidad <- reactive({
    completos_cantidad = input$personas_n * input$completos_por_persona
  })
  
  # cálculo a partir de las ui
  total <- reactive({
    
    total_completos_precio = completos_cantidad() * input$completo_precio
    
    total_completos_precio
  })
  
  # output del texto que pasa al UI
  output$texto_total <- renderText({
    format(total(), big.mark = ".")
  })
}

shinyApp(ui, server)