% MapServer web mapping  
% Didier Richard  
% 2018/10/02

---

revision:
    - 1.0.0 : 2018/09/04 : proj 5.1.0, gdal 2.3.1, mapserver 7.2.0  
    - 1.1.0 : 2018/09/16 : proj 5.2.0, gdal 2.3.1, mapserver 7.2.0  
    - 1.2.0 : 2018/09/28 : proj 5.2.0, gdal 2.3.2, mapserver 7.2.0  
    - 1.2.1 : 2018/10/02 : proj 5.2.0, gdal 2.3.2, mapserver 7.2.1  

---

# Building #

```bash
$ docker build -t dgricci/mapserver:$(< VERSION) .
$ docker tag dgricci/mapserver:$(< VERSION) dgricci/mapserver:latest
```

## Behind a proxy (e.g. 10.0.4.2:3128) ##

```bash
$ docker build \
    --build-arg http_proxy=http://10.0.4.2:3128/ \
    --build-arg https_proxy=http://10.0.4.2:3128/ \
    -t dgricci/mapserver:$(< VERSION) .
$ docker tag dgricci/mapserver:$(< VERSION) dgricci/mapserver:latest
```

## Build command with arguments default values ##

```bash
$ docker build \
    --build-arg MAPSERVER_VERSION=7.2.1 --build-arg MAPSERVER_DOWNLOAD_URL=http://download.osgeo.org/mapserver/mapserver-7.2.1.zip \
    -t dgricci/mapserver:$(< VERSION) .
$ docker tag dgricci/mapserver:$(< VERSION) dgricci/mapserver:latest
```

# Use #

See `dgricci/strech` README for handling permissions with dockers volumes.

```bash
$ docker run --rm dgricci/mapserver:$(< VERSION)
MapServer version 7.2.1 OUTPUT=PNG OUTPUT=JPEG OUTPUT=KML SUPPORTS=PROJ SUPPORTS=AGG SUPPORTS=FREETYPE SUPPORTS=CAIRO SUPPORTS=SVG_SYMBOLS SUPPORTS=RSVG SUPPORTS=ICONV SUPPORTS=XMP SUPPORTS=FRIBIDI SUPPORTS=WMS_SERVER SUPPORTS=WMS_CLIENT SUPPORTS=WFS_SERVER SUPPORTS=WFS_CLIENT SUPPORTS=WCS_SERVER SUPPORTS=SOS_SERVER SUPPORTS=FASTCGI SUPPORTS=THREADS SUPPORTS=GEOS SUPPORTS=PBF INPUT=JPEG INPUT=POSTGIS INPUT=OGR INPUT=GDAL INPUT=SHAPEFILE
```


_fin du document[^pandoc_gen]_

[^pandoc_gen]: document généré via $ `pandoc -V fontsize=10pt -V geometry:"top=2cm, bottom=2cm, left=1cm, right=1cm" -s -N --toc -o mapserver.pdf README.md`{.bash}
