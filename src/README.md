## Dev setup

### Webscraper setup:
- Follow these steps to install the chrome driver 
```
wget -nc https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt update 
sudo apt install -f ./google-chrome-stable_current_amd64.deb 
```

### Python setup
- The code currently takes care of installing the python dependencies.

### Start server
- Go to parent dir and run: `R -e "shiny::runApp('evision-r-app')"`
  