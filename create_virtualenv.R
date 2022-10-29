create_virtualenv <- function() {
  reticulate::virtualenv_create("python_env", python = "python3")
  reticulate::virtualenv_install("python_env", packages = c("pandas", "pytrends", "selenium", "tensorflow", "keras"))
  reticulate::use_virtualenv("python_env", required = TRUE)
}