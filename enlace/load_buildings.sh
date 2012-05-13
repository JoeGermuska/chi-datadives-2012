#!/usr/bin/env bash
# loads recent crimes
# assumes you've made a database (you can change the name below) with a typical template_postgis setup
# but one which doesn't have the SRID for http://spatialreference.org/ref/esri/102671/
# (NAD 1983 StatePlane Illinois East FIPS 1201 Feet)
DATABASE='datakind'
WORKING_DIR=`pwd`


psql -f create_buildings.sql ${DATABASE}
psql -c "copy vacant_311 from '${WORKING_DIR}/311_Vacant_and_Abandoned_Buildings.csv' csv header" $DATABASE

psql -c "select AddGeometryColumn('vacant_311', 'the_geom', 9102671, 'POINT', 2);" $DATABASE
psql -c "create index vacant_311_geom on vacant_311 using gist(the_geom)" $DATABASE

psql -c "update vacant_311 set the_geom = ST_SetSRID(ST_MakePoint(X_Coordinate, Y_Coordinate), 9102671)" $DATABASE

psql -c "alter table vacant_311 add area_number integer;" $DATABASE
psql -c "alter table vacant_311 add community_area varchar(80);" $DATABASE
psql -c "alter table vacant_311 add neigh_number integer;" $DATABASE
psql -c "alter table vacant_311 add neighborhood varchar(80);" $DATABASE

psql -c "update vacant_311 set area_number = commareas.area_numbe::integer, community_area = commareas.community from commareas where ST_Contains(commareas.the_geom,vacant_311.the_geom)" $DATABASE

psql -c "update vacant_311 set neigh_number = neighborhoods.pri_neigh_::integer, neighborhood = neighborhoods.pri_neigh from neighborhoods where  ST_Contains(neighborhoods.the_geom,vacant_311.the_geom)" $DATABASE
