# descarga una tabla de excel y la limpia para su posterior uso en tabla_pobreza.R
# y en la aplicación app_pobreza.R

# descargar datos
download.file("https://bid-ckan.ministeriodesarrollosocial.gob.cl/dataset/b317bf52-693e-44a9-b75e-ffaa72b9482d/resource/71997eac-b660-4fd3-9f5d-61b5656491ad/download/estimaciones_indice_pobreza_multidimensional_comunas_2022.xlsx",
              "dato_pobreza.xlsx")

library(readxl)
library(janitor)
library(dplyr)

# cargar dato de excel
dato <- readxl::read_excel("dato_pobreza.xlsx")

# limpiar
dato_2 <- dato |> 
  janitor::row_to_names(2) |> 
  janitor::clean_names() |> 
  rename(poblacion = 4,
         pobreza_n = 5, 
         pobreza_p = 6) |> 
  select(1:8)

# convertir columnas a su formato correcto
dato_3 <- dato_2 |> 
  mutate(across(c(poblacion, pobreza_n, pobreza_p, starts_with("limite")),
                as.numeric))

# guardar resultado
readr::write_rds(dato_3, "dato_pobreza.rds")
