FROM rocker/shiny:latest

RUN  apt-get update \
    && apt-get install -y \
    wget \
    tar \
    make \
    curl \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /usr/src/app/

RUN mkdir temp; cd temp ;\
    wget "https://repo.anaconda.com/miniconda/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh"

RUN cd temp; bash Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b -p /root/miniconda
ENV PATH=/root/miniconda/bin:${PATH}

RUN mkdir rvision
COPY src/ rvision/.
RUN Rscript rvision/setup.R

EXPOSE 5008

CMD ["R",  "-e", "shiny::runApp('rvision', port=5008, host='0.0.0.0')"]
