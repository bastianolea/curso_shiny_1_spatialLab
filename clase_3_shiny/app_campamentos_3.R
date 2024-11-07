library(shiny)
library(bslib)
library(htmltools)
library(dplyr)
library(gt)
library(glue)
library(shinyjs)
library(ggplot2)
library(thematic)
library(purrr)

# ejemplo de aplicación con tema, en formato sidebar

color_detalle = "#C9C9C9" # hex color
color_titulos = "#916650"
color_texto = "#bd7a56"
color_destacado = "#ce8d6a"
color_fondo = "#f9f4f2"

datos <- readr::read_rds("datos/dato_campamentos.rds")

regiones <- unique(datos$region)

thematic_shiny()


ui <- page_sidebar(
  useShinyjs(),
  theme = bs_theme(bg = color_fondo, 
                   fg = color_texto, 
                   primary = color_destacado,
                   base_font = font_google("Montserrat"),
                   heading_font = font_google("Alegreya")
  ),
  
  # definir estilos css manualmente para los títulos
  tags$style(
    HTML("
  h1 { color:", color_titulos, " !important;}
  h2 { color:", color_titulos, ";}
  ")),
  
  title = h1("Campamentos"),
  
  # sidebar ----
  sidebar = div(
    
    h2("Opciones"),
    # inputs
    selectInput("region",
                "Seleccionar región",
                choices = regiones)  |> tooltip("Seleccione una región para poder elegir una comuna"),
    
    selectInput("comuna",
                "Seleccionar comuna",
                choices = NULL) |> tooltip("Seleccione una comuna para ver sus datos en el gráfico"),
    
    div(style = css(margin_top = "30px"),
        actionButton("opciones", 
                     label = "Mostrar más información")
    ),
    
    div(style = css(margin_top = "30px"),
        actionButton("mostrar_modal", 
                     label = "Mostrar información en ventana")
    )
    
  ),
  
  # cuerpo ----
  div(
    div(style = css(background_color = color_titulos, color = color_fondo, padding_bottom = "0px",
                    padding = "8px", border_radius = "6px", opacity = "80%"),
        p("Explicación de el contenido de los datos, su fuente, para qué sirven y cómo se interpretan") |> tooltip("Más información")
    ),
    
    ## alerta ----
    # cuadro de alerta, que estará oculto, y se mostrará por medio de un observer
    div(id = "alerta", 
        style = "padding: 16px; color: white; margin-top: 30px; margin-bottom: 30px; background-color: #DF5665; border-radius: 5px; opacity: 80%;",
        strong("Alerta: más de 10 campamentos en la comuna seleccionada")
    ) |> shinyjs::hidden(),
    
    hr(),
    
    uiOutput("prueba_ui"),
    
    hr(),
    
    # ui desde map ----
    div(style = css(max_height = "600px", overflow_y = "scroll"),
    uiOutput("ui_campamentos")
    ),
    
    hr(),
    
    
    textOutput("texto_grafico") |> shinyjs::hidden(),
    
    # gráfico ----
    div(
      h2("Visualización"),
      plotOutput("grafico", height = 500)
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
  
  
  texto_informacion <- reactive({
    n_campamentos <- datos_filtrados_comuna() |> nrow()
    glue("En la comuna de {input$comuna} existen {n_campamentos} campamentos.")
  })
  
  
  # generar output de texto
  output$texto_grafico <- renderText({
    texto_informacion()
  })
  
  output$texto_modal <- renderText({
    texto_informacion()
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
      theme(axis.text = element_text(color = color_titulos))
  }, res = 120)
  
  
  
  # modal ----
  # ventana de información...
  observeEvent(input$mostrar_modal, {
    message("botón apretado")
    
    showModal(
      modalDialog(title = "Información",
                  "Contenido que queramos",
                  textOutput("texto_modal"),
                  selectInput("selector2", "Cosa", choices = 1:10)
      )
    )
  })
  
  
  # notificaciones ----
  # notificaciones
  observe({
    showNotification(ui = paste("Comuna:", input$comuna), duration = 0.9)
  })
  
  
  # notificaciones con condición
  observe({
    total_hogares <- sum(datos_filtrados_comuna()$hogares)
    if (total_hogares > 1000) {
      
      showNotification(ui = paste("Alto número de hogares en la comuna:", total_hogares),
                       type = "warning", duration = 0.9)
    }
  })
  
  
  # crear interfaz ----
  output$prueba_ui <- renderUI({
    req(datos_filtrados_comuna() |> nrow() > 0)
    
    # browser()
    div(
      h2("Título"),
      em("Texto al respecto:", sum(datos_filtrados_comuna()$hectareas))
    )
    
  })
  
  
  
  
  output$ui_campamentos <- renderUI({
    req(datos_filtrados_comuna() |> nrow() > 0)
    
    # browser()
    
    campamentos <- datos_filtrados_comuna()$nombre
    
    map(campamentos, \(nombre_campamento) {
      
      dato_filtrado <- datos_filtrados_comuna() |> 
        filter(nombre == nombre_campamento) |> 
        slice(1)
      
      div(style = css(margin_bottom = "24px"),
        h4(nombre_campamento),
        em("El campamento", nombre_campamento, "se compone de", 
           dato_filtrado$hogares, "hogares en", round(dato_filtrado$hectareas, 1), "hectáreas."),
        
        if (dato_filtrado$hectareas > 4) {
         strong("Es muy grande") 
        }
      )
    })
    
  })
  
  
}

shinyApp(ui, server)