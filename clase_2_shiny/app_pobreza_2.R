# actualización de la versión 1 de la aplicación de datos de pobreza de la clase 1

library(shiny)
library(bslib)
library(dplyr)
library(gt)
library(glue)
library(shinyWidgets)

# library(reactlog)
# reactlog_enable()

# cargar los datos
pobreza <- readr::read_rds("datos/dato_pobreza.rds") |> 
  filter(!is.na(region))

regiones <- unique(pobreza$region)


# ui
ui <- page_fluid(
  fluidRow(
    column(4,
           h1("Pobreza"),
           
           selectInput("region", 
                       "Seleccione una región",
                       choices = regiones),
           
           h2(textOutput("titulo")),
           
           textOutput("cifra"),
           
           br(),
           awesomeCheckbox(
             inputId = "opcion",
             label = "Colorear cifras", 
             value = TRUE
           ),
           
           sliderInput("decimales",
                       "Decimales",
                       min = 0, max = 4, value = 0)
    ),
    
    column(8,
           gt_output("tabla")
    )
  )
)

# server
server <- function(input, output, session) {
  
  datos <- reactive({
    message("filtrando datos")
    
    dato <- pobreza |> 
      filter(region == input$region) |> 
      arrange(desc(pobreza_p))
    
    print(dato)
  })
  
  output$tabla <- render_gt({
    message("generando tabla")
    
    tabla <- datos() |> 
      select(nombre_comuna, poblacion, pobreza_n, pobreza_p) |> 
      gt() |> 
      gt::fmt_percent(pobreza_p, decimals = input$decimales) |>
      gt::fmt_number(c(poblacion, pobreza_n), 
                     decimals = 0, sep_mark = ".")
    
    if (input$opcion == TRUE) {
      tabla <- tabla |> 
        gt::data_color(columns = c(pobreza_n, pobreza_p),
                       method = "numeric", palette = "viridis")
    }
    
    tabla <- tabla |> 
      gt::cols_label(nombre_comuna = "Comuna",
                     poblacion = "Población",
                     pobreza_n = "Personas en situación de pobreza",
                     pobreza_p = "Porcentaje de personas en situación de pobreza") |> 
      gt::tab_header(title = "Pobreza comunal")
  })
  
  
  output$titulo <- renderText({
    
    if (input$region == "Metropolitana") {
      paste("Datos de pobreza para la región", input$region)
      
    } else {
      paste("Datos de pobreza para la región de", input$region)
      
    }
  })
  
  
  output$cifra <- renderText({
    
    comuna_mayor <- datos() |> 
      arrange(desc(pobreza_p)) |> 
      slice(1)
    
    comuna <- comuna_mayor$nombre_comuna
    porcentaje <- scales::percent(comuna_mayor$pobreza_p, accuracy = 1)
    
    glue("En la región de {input$region}, la comuna con mayor porcentaje de pobreza
          es {comuna}, con un {porcentaje} de pobreza.")
  })
  
  
  
}

shinyApp(ui, server)