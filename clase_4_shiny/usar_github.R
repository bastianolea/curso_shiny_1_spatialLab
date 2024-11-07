# install.packages("usethis")

# crear repositorio local
usethis::use_git()

# abre ventana de github, generar y copiar token
usethis::create_github_token()

# ingresar el token
gitcreds::gitcreds_set()

# crear repositorio remoto y conectarlo con el local
usethis::use_github()