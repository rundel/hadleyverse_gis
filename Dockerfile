FROM rocker/hadleyverse
MAINTAINER "Colin Rundel" rundel@gmail.com

RUN printf "deb http://httpredir.debian.org/debian testing main\ndeb http://httpredir.debian.org/debian testing-updates main\ndeb http://security.debian.org testing/updates main\ndeb-src http://http.debian.net/debian testing main\n" > /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends software-properties-common bzip2 \
  && add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable \
  && apt-get install -y --no-install-recommends curl libgdal-dev libproj-dev \
  && wget --quiet http://download.osgeo.org/geos/geos-3.6.0.tar.bz2 \
  && tar xvjf geos-3.6.0.tar.bz2 \
  && cd geos-3.6.0 \
  && ./configure \
  && make install \
  && cd .. \
  && rm -rf geos-3.6.0 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Install the tidyverse package, RStudio pkg dev (and some close friends). 
RUN install2.r \
  -r 'https://cran.rstudio.com' \
  --dep TRUE  \
  jsonlite rgdal rgeos sf \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## httr authentication uses this port
EXPOSE 1410
ENV HTTR_LOCALHOST 0.0.0.0
