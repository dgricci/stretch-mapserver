#!/bin/bash

# Dockerfile for Mapserver

# Exit on any non-zero status.
trap 'exit' ERR
set -E

echo "Compiling Mapserver ${MAPSERVER_VERSION}..."

# get php5 as php7 is not yet supported by nor gdal, neither mapserver :
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php56.list
# thanks to @debsuryorg

01-install.sh

# WITH_V8 needs libv8-dev but a lot of errors when compiling (deprecated functions, members, etc ...)
apt-get -qy --no-install-recommends install \
    libcurl4-gnutls-dev \
    libgeos-dev \
    libjpeg62-turbo-dev \
    libpq-dev \
    php5.6-dev \
    python-dev \
    libgif-dev \
    libfreetype6-dev \
    libfcgi-dev \
    libcairo2-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libexempi-dev \
    libpixman-1-dev \
    libprotobuf-c-dev \
    librsvg2-dev \
    libxslt1-dev \
    default-libmysqlclient-dev \
    fcgiwrap \
    protobuf-c-compiler \
    openjdk-8-jdk \
    swig

# Cf. https://github.com/mapserver/mapserver/blob/branch-7-2/CMakeLists.txt
cd /tmp
wget --no-verbose "$MAPSERVER_DOWNLOAD_URL"
tar xzf mapserver-$MAPSERVER_VERSION.tar.gz
rm -f mapserver-$MAPSERVER_VERSION.tar.gz*

{
    cd mapserver-$MAPSERVER_VERSION ; \
    mkdir build ; \
    cd build ; \
    cmake --trace-expand \
        -Wno-dev \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_PREFIX_PATH=/usr \
        -DCMAKE_BUILD_TYPE=Release \
        -DJAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
        -DWITH_PROJ=ON \
        -DWITH_PROTOBUFC=ON \
        -DWITH_KML=ON \
        -DWITH_SOS=ON \
        -DWITH_WMS=ON \
        -DWITH_FRIBIDI=ON \
        -DWITH_HARFBUZZ=ON \
        -DWITH_ICONV=ON \
        -DWITH_CAIRO=ON \
        -DWITH_SVGCAIRO=OFF \
        -DWITH_RSVG=ON \
        -DWITH_MYSQL=ON \
        -DWITH_FCGI=ON \
        -DWITH_GEOS=ON \
        -DWITH_POSTGIS=ON \
        -DWITH_GDAL=ON \
        -DWITH_OGR=ON \
        -DWITH_CLIENT_WMS=ON \
        -DWITH_CLIENT_WFS=ON \
        -DWITH_CURL=ON \
        -DWITH_WFS=ON \
        -DWITH_WCS=ON \
        -DWITH_LIBXML2=ON \
        -DWITH_THREAD_SAFETY=ON \
        -DWITH_GIF=ON \
        -DWITH_PYTHON=ON \
        -DWITH_PHP=ON \
        -DWITH_PERL=OFF \
        -DWITH_RUBY=OFF \
        -DWITH_JAVA=ON \
        -DWITH_CSHARP=OFF \
        -DWITH_POINT_Z_M=OFF \
        -DWITH_ORACLESPATIAL=OFF \
        -DWITH_ORACLE_PLUGIN=OFF \
        -DWITH_MSSQL2008=OFF \
        -DWITH_EXEMPI=ON \
        -DWITH_XMLMAPFILE=ON \
        -DWITH_V8=OFF \
        -DWITH_PIXMAN=ON \
        ../ 2>&1 | tee ../../config.log && \
    NPROC=$(nproc) && \
    make -j$NPROC 2>&1 | tee ../../make.log && \
    make install ; \
    ldconfig ; \
    cd ../.. ; \
    rm -fr mapserver-$MAPSERVER_VERSION ; \
}

# clean
# don't auto-remove otherwise all libs are gone (not only headers) :
apt-get purge -y \
    libcairo2-dev \
    libcurl4-gnutls-dev \
    libexempi-dev \
    libexpat1-dev \
    libfcgi-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libgeos-dev \
    libgif-dev \
    libharfbuzz-dev \
    libice-dev \
    libjpeg62-turbo-dev \
    libmariadb-dev \
    libpixman-1-dev \
    libpng12-dev \
    libpthread-stubs0-dev \
    libpq-dev \
    libprotobuf-c-dev \
    libpython-dev \
    libpython2.7-dev \
    librsvg2-dev \
    libssl-dev \
    libxau-dev \
    libxcb-shm0-dev \
    libxcb1-dev \
    libxdmcp-dev \
    libxext-dev \
    libxrender-dev \
    libxslt1-dev \
    zlib1g-dev \
    x11proto-input-dev \
    x11proto-kb-dev \
    x11proto-render-dev \
    x11proto-xext-dev \
    xtrans-dev \
    php5.6-dev \
    python-dev \
    python2.7-dev \
    protobuf-c-compiler \
    swig
01-uninstall.sh y

exit 0

