install.packages("shiny")
install.packages("shinyWidgets")
install.packages("reticulate")
install.packages("keras")
install.packages("Metrics")

library(reticulate)
# readRenviron(".env")
# PYTHON_ENV = Sys.get("PYTHON_ENV_DIR")
PYTHON_ENV <- "./.python_env"
reticulate::virtualenv_create(PYTHON_ENV, python = "python3")
reticulate::virtualenv_install(PYTHON_ENV, packages = c("pandas", "pytrends", "selenium", "webdriver-manager"))
reticulate::use_virtualenv(PYTHON_ENV, required = TRUE)
install_tensorflow()

# reticulate::virtualenv_create(envname = 'python_env',
#                               python = '/usr/bin/python3')
# reticulate::virtualenv_install(envname = 'python_env',
#                                packages = c('pandas', 'pytrends', 'selenium', 'tensorflow', 'keras'))
# reticulate::use_virtualenv('python_env', required = T)
