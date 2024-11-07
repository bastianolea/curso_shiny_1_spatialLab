# https://github.com/bastianolea/campamentos_chile

library(readr)

datos <- read_csv2("datos/campamentos_chile_2024.csv")

datos |> glimpse()

datos_2 <- datos |> 
  select(nombre:comuna, hogares, hectareas, area)

readr::write_rds(datos_2, "datos/dato_campamentos.rds")
