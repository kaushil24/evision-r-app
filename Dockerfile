# FROM python:3.10.9
FROM rocker/shiny:latest
RUN apt-get update && apt install -y python3-venv
# RUN python3 -m venv .venv
# RUN apt-get update && apt-get install -y \
#     libssl-dev \
#     libcurl4-gnutls-dev \
#     curl \
#     libsodium-dev \
#     libxml2-dev \
#     libicu-dev \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# # RUN apt-get update && apt-get install -y python3-pip
# # RUN apt-get update && apt-get install -y python3-virtualenv 
# # RUN python3 -m pip install virtualenv
# # RUN apt install python3-venv

COPY src/ app/
RUN Rscript app/setup.R
# Reticulate throws on the above step:
# Error: '/.python_env/bin/python' was not built with a shared library.
# reticulate can only bind to copies of Python built with '--enable-shared'.
EXPOSE 5008

# CMD ["R",  "-e", "shiny::runApp('app', port=5008, host='0.0.0.0')"]
