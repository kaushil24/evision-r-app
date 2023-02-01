install.packages("shiny")
install.packages("shinyWidgets")
install.packages("reticulate")
install.packages("keras")
install.packages("Metrics")
install.packages("tensorflow")

library(reticulate)
library(tensorflow)
# readRenviron(".env")
# PYTHON_ENV = Sys.get("PYTHON_ENV_DIR")
PYTHON_ENV <- "pyenv"
reticulate::conda_create(PYTHON_ENV)
reticulate::conda_install(PYTHON_ENV, packages = c("pandas", "pytrends", "selenium", "webdriver-manager"))
reticulate::use_condaenv(PYTHON_ENV, required = TRUE)
install_tensorflow()

# reticulate::virtualenv_create(envname = 'python_env',
#                               python = '/usr/bin/python3')
# reticulate::virtualenv_install(envname = 'python_env',
#                                packages = c('pandas', 'pytrends', 'selenium', 'tensorflow', 'keras'))
# reticulate::use_virtualenv('python_env', required = T)