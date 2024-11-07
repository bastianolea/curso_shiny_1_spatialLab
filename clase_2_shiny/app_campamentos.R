library(shiny)
library(bslib)
library(dplyr)
library(gt)
library(glue)
library(shinyjs)

# library(reactlog)
# reactlog_enable()

datos <- readr::read_rds("datos/dato_campamentos.rds")

regiones <- unique(datos$region)

ui <- page_fluid(
  useShinyjs(),
  
  fluidRow(
    column(12,
           
           h1("Campamentos"),
           
           # inputs
           selectInput("region",
                       "Seleccionar región",
                       choices = regiones),
           
           selectInput("comuna",
                       "Seleccionar comuna",
                       choices = NULL),
           
           actionButton("opciones", 
                        label = "Mostrar más información"),
           
           # cuadro de alerta, que estará oculto, y se mostrará por medio de un observer
           div(id = "alerta", 
               style = "padding: 16px; margin-top: 12px; margin-bottom: 12px; background-color: red; border-radius: 5px;",
               strong("Alerta: más de 10 campamentos en la comuna seleccionada")
           ) |> shinyjs::hidden(),
           
           # outputs
           textOutput("texto") |> shinyjs::hidden(),
           
           gt_output("tabla")
    )
  )
)

server <- function(input, output, session) {
  
  # filtrar datos
  datos_filtrados_region <- reactive({
    datos |> 
      filter(region == input$region)
  })
  
  # extraer comunas de la región filtrada
  comunas <- reactive({
    datos_filtrados_region() |> 
      pull(comuna) |> 
      unique()
  })
  
  # output de texto de comunas de la región
  output$prueba <- renderText({
    comunas()
  })
  
  # en base a las comunas de la región, rellena el selector de comunas
  observe({
    updateSelectInput(session,
                      "comuna", 
                      choices = comunas()
    )
  })
  
  # mostrar/ocultar le texto en base al botón
  observeEvent(input$opciones, {
    shinyjs::toggle("texto")
  })
  
  # si se cumple ciertas condiciones, se muestra u oculta el texto de alerta
  observe({
    if (nrow(datos_filtrados_comuna()) > 10) {
      shinyjs::show("alerta")
    } else {
      shinyjs::hide("alerta")
    }
  })
  
  
  # filtrar datos de región en base al selector de comunas
  datos_filtrados_comuna <- reactive({
    datos_filtrados_region() |> 
      filter(comuna == input$comuna)
  })
  
  
  # generar tabla
  output$tabla <- render_gt({
    datos_filtrados_comuna() |> 
      arrange(desc(hogares)) |> 
      gt()
  })
  
  
  # generar output de texto
  output$texto <- renderText({
    
    n_campamentos <- datos_filtrados_comuna() |> nrow()
    
    glue("En la comuna de {input$comuna} existen {n_campamentos} campamentos.")
    
  })
  
}

shinyApp(ui, server)