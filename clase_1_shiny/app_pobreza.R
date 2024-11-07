library(shiny)
library(bslib)
library(dplyr)
library(gt)

pobreza <- readr::read_rds("dato_pobreza.rds") |> 
  filter(!is.na(region))

regiones <- unique(pobreza$region)

# ui
ui <- page_fluid(
  h1("Pobreza"),
  
  selectInput("region", 
              "Seleccione una región",
              choices = regiones),
  
  
  gt_output("tabla")
)

# server
server <- function(input, output, session) {
  
  datos <- reactive({
  pobreza |> 
      filter(region == input$region) |> 
      arrange(desc(pobreza_p))
  })
  
  
  output$tabla <- render_gt({
    datos() |> 
      select(nombre_comuna, poblacion, pobreza_n, pobreza_p) |> 
      gt() |> 
      gt::fmt_percent(pobreza_p, decimals = 1) |> 
      gt::fmt_number(c(poblacion, pobreza_n), 
                     decimals = 0, sep_mark = ".") |> 
      gt::data_color(columns = c(pobreza_n, pobreza_p),
                     method = "numeric", palette = "viridis") |> 
      gt::cols_label(nombre_comuna = "Comuna",
                     poblacion = "Población",
                     pobreza_n = "Personas en situación de pobreza",
                     pobreza_p = "Porcentaje de personas en situación de pobreza") |> 
      gt::tab_header(title = "Pobreza comunal")
  })
  
  
}

shinyApp(ui, server)