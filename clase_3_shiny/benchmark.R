

library(bench)

bench::mark(iterations = 20, check = FALSE,
  readr::read_csv2("datos/campamentos_chile_2024.csv"),
  readr::read_rds("datos/dato_campamentos.rds"),
  readRDS("datos/dato_campamentos.rds")
)
