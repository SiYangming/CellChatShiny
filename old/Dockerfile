FROM rocker/shiny:4.0.1

LABEL maintainer="Ivan Chang iychang@uci.edu"


#OS level prereq pacakges
RUN apt-get update \
	&& apt-get install -y libxml2 libglpk-dev libxml2-dev\
	&& rm -rf /var/lib/apt/lists/*

#Install managers
RUN Rscript -e 'install.packages("devtools")' \
	&& Rscript -e 'install.packages("BiocManager")'

#BiocManager prereq installs for CellChat
RUN Rscript -e 'BiocManager::install("ComplexHeatmap")' \
	&& Rscript -e 'BiocManager::install("BiocGenerics")' \
	&& Rscript -e 'BiocManager::install("Biobase")'

#Github prereq installs for CellChat
RUN Rscript -e 'Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS=TRUE); devtools::install_github("renozao/NMF")' \
	&& Rscript -e 'devtools::install_github("jokergoo/circlize")'

#CellChat install
RUN Rscript -e 'devtools::install_github("sqjin/CellChat")'

#Packages supporting Shiny and graphics
RUN Rscript -e 'install.packages(c("shinyWidgets", "shinythemes", "ggplot2", "ggalluvial", "shinyjs", "shinycssloaders", "dplyr"))'

RUN rm -Rf /srv/shiny-server/*
RUN mkdir /srv/shiny-server/Cellchat

COPY ./shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY ./*.R /srv/shiny-server/Cellchat/
