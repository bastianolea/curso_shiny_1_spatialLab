library(shiny)
library(bslib)
library(htmltools)
library(dplyr)
library(gt)
library(glue)
library(shinyjs)
library(ggplot2)

# ejemplo de aplicación en formato tarjetas (cards)

datos <- readr::read_rds("datos/dato_campamentos.rds")

regiones <- unique(datos$region)

ui <- page_fluid(
  useShinyjs(),
  
  titlePanel("Prueba"),
  
  card(
    card_header("Campamentos"
    ),
    card_body(
      p("Aplicación creada por mi")
    )
  ),
  
  layout_columns(
  card(
       p("Explicación de el contenido de los datos, su fuente, para qué sirven y cómo se interpretan"),
       p("Aquí podría ir un texto explicativo")
       
  ),
  
  # inputs
  card(
       card_body(
         selectInput("region",
                     "Seleccionar región",
                     choices = regiones),
         
         selectInput("comuna",
                     "Seleccionar comuna",
                     choices = NULL),
         
         div(style = css(margin_top = "10px"),
             actionButton("opciones", 
                          label = "Mostrar más información")
         )
       )
       
       )
  ),
  
  card(
       card_header("Datos"),
       
       
       # cuadro de alerta, que estará oculto, y se mostrará por medio de un observer
       div(id = "alerta", 
           style = css(padding = "16px", margin_top = "10px", margin_bottom = "30px", 
                       background_color = "#DF5665", border_radius = "5px", opacity = "90%"),
           strong("Alerta: más de 10 campamentos en la comuna seleccionada")
       ) |> shinyjs::hidden(),
       
       # outputs
       textOutput("texto") |> shinyjs::hidden(),
       
       # div(style = css(height = "300px", overflow_y = "scroll"),
           plotOutput("grafico", height = 500)
       # )
       # plotly
       # ggiraph
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
  
  
  # generar output de texto
  output$texto <- renderText({
    
    n_campamentos <- datos_filtrados_comuna() |> nrow()
    
    glue("En la comuna de {input$comuna} existen {n_campamentos} campamentos.")
    
  })
  
  
  # gráfico ----
  
  output$grafico <- renderPlot({
    req(input$comuna != "")
    # req(datos_filtrados_comuna() |> nrow() > 0)
    
    # browser()
    # dev.new()
    
    datos_filtrados_comuna() |> 
      arrange(desc(hogares)) |> 
      mutate(id = row_number()) |> 
      filter(id <= 10) |> 
      mutate(nombre = forcats::fct_reorder(nombre, hogares)) |> 
      ggplot() +
      geom_col(aes(x = hogares, y = nombre)) +
      theme_classic()
  })
  
}

shinyApp(ui, server)