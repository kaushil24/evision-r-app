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
- Go to parent dir and run: `R -e "shiny::runApp('evision-r-app', port=5008)"`
  

## Dockerization
- Bulding image:  `docker build . -t rshiny`
- Running the container `docker run rshiny -p 5008:5008`
- To sh into the running docker container: 
    ```
    # get container id
    docker ps
    docker exec -it <container_id> sh
    ```
