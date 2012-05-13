#!/usr/bin/env bash
DATABASE='datakind'
WORKING_DIR=`pwd`

psql -c "drop table combined;" $DATABASE
psql -c "create table combined (label varchar(200),type varchar(10))" $DATABASE
psql -c "select AddGeometryColumn('combined', 'the_geom', 9102671, 'POINT', 2);" $DATABASE
psql -c "create index combined_geom on combined using gist(the_geom)" $DATABASE

psql -c "insert into combined (type, label, the_geom) select 'crime', case_number || E'\\r\\n' || block || E'\\r\\n' || location_description || E'\\r\\n' || primary_type || E'\\r\\n' || description, the_geom from crimes where neigh_number = 110" $DATABASE

psql -c "insert into combined (type, label, the_geom) select 'vacant', request_number || E'\\r\\n' || full_address, the_geom from vacant_311 where neigh_number = 110" $DATABASE

# ogr2ogr -f KML combined.kml -t_srs epsg:900913 "PG:dbname=${DATABASE}" combined
#ogr2ogr -f "ESRI Shapefile" combined -t_srs epsg:900913 "PG:dbname=${DATABASE}" combined