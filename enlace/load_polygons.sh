#!/usr/bin/env bash
# loads recent crimes
# assumes you've made a database (you can change the name below) with a typical template_postgis setup
# but one which doesn't have the SRID for http://spatialreference.org/ref/esri/102671/
# (NAD 1983 StatePlane Illinois East FIPS 1201 Feet)
DATABASE='datakind'

shp2pgsql -d -I -s 9102671 shapefiles/neighborhoods/Neighborhoods.shp | psql ${DATABASE}
shp2pgsql -d -I -s 9102671 shapefiles/comm_areas/CommAreas.shp | psql ${DATABASE}
shp2pgsql -d -I -s 9102671 shapefiles/school_grounds/School_Grounds.shp | psql ${DATABASE}
shp2pgsql -d -I -s 9102671 shapefiles/tracts/CensusTractsTIGER2010.shp | psql ${DATABASE}
