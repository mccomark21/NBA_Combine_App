FROM rocker/shiny-verse:4.0

COPY . /srv/shiny-server/nba-combine
COPY shiny-server.conf etc/shiny-server/shiny-server.conf

RUN apt-get update && \ 
    apt-get -y install \
        libxml2 \
        libxml2-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libssl-dev \
        libtiff-dev

RUN Rscript -e "install.packages('packrat')" \
            -e "packrat::restore('/srv/shiny-server/nba-combine')"
            
RUN chown shiny /srv/shiny-server/nba-combine

USER shiny      
RUN chmod 700 /srv/shiny-server/nba-combine
            
EXPOSE 3838

ENTRYPOINT ["/usr/bin/shiny-server"]