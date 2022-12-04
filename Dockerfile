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

RUN Rscript -e "install.packages('devtools')" \
            -e "devtools::install_github('abresler/nbastatR')" \
            -e "install.packages('DT')" \
            -e "install.packages('shinydashboard')" \
            -e "install.packages('shinycssloaders')" \
            -e "install.packages('shinyWidgets')"
            
#RUN chown shiny /srv/shiny-server/nba-combine

USER shiny      
#RUN chmod 700 /srv/shiny-server/nba-combine
            
EXPOSE 3838

ENTRYPOINT ["/usr/bin/shiny-server"]