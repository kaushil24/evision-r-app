library(rsconnect)

rsconnect::deployApp(
  appDir = '~/Desktop/Jobs/eVision/R\ Project/UI',
  appTitle = 'eVision',
  logLevel = 'verbose')