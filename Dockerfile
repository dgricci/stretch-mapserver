## MapServer web mapping
FROM dgricci/gdal:2.4.0
MAINTAINER Didier Richard <didier.richard@ign.fr>
LABEL       version="1.3.0" \
            mapserver="v7.2.1" \
            os="Debian Stretch" \
            description="MapServer service"

ARG MAPSERVER_VERSION
ENV MAPSERVER_VERSION ${MAPSERVER_VERSION:-7.2.1}
ARG MAPSERVER_DOWNLOAD_URL
ENV MAPSERVER_DOWNLOAD_URL ${MAPSERVER_DOWNLOAD_URL:-http://download.osgeo.org/mapserver/mapserver-$MAPSERVER_VERSION.tar.gz}

COPY build.sh /tmp/build.sh
    
RUN /tmp/build.sh && rm -f /tmp/build.sh

WORKDIR /geodata

# check and print capabilities
CMD ["mapserv", "-v"]

