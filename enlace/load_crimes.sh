#!/usr/bin/env bash
# loads recent crimes
# assumes you've made a database (you can change the name below) with a typical template_postgis setup
# but one which doesn't have the SRID for http://spatialreference.org/ref/esri/102671/
# (NAD 1983 StatePlane Illinois East FIPS 1201 Feet)
DATABASE='datakind'
WORKING_DIR=`pwd`

psql -f create_crimes.sql ${DATABASE}
psql -c "copy crimes from '${WORKING_DIR}/Crimes_2012.csv' csv header" $DATABASE
psql -c "copy crimes from '${WORKING_DIR}/Crimes_2011.csv' csv header" $DATABASE

psql -c "select AddGeometryColumn('crimes', 'the_geom', 9102671, 'POINT', 2);" $DATABASE
psql -c "create index crimes_geom on crimes using gist(the_geom)" $DATABASE

psql -c "update crimes set the_geom = ST_SetSRID(ST_MakePoint(X_Coordinate, Y_Coordinate), 9102671)" $DATABASE

psql -c "alter table crimes add area_number integer;" $DATABASE
psql -c "alter table crimes add community_area varchar(80);" $DATABASE
psql -c "alter table crimes add neigh_number integer;" $DATABASE
psql -c "alter table crimes add neighborhood varchar(80);" $DATABASE


# uncomment to code all community areas. slow...
# psql -c "update crimes set area_number = commareas.area_numbe::integer, community_area = commareas.community from commareas where ST_Contains(commareas.the_geom,crimes.the_geom)"
# uncomment to code only crimes in South Lawndale
psql -c "update crimes set area_number = commareas.area_numbe::integer, community_area = commareas.community from commareas where ST_Contains(commareas.the_geom,crimes.the_geom) and commareas.area_numbe = '30'"

# uncomment to code all neighborhoods. slow...
# psql -c "update crimes set neigh_number = neighborhoods.pri_neigh_::integer, neighborhood = neighborhoods.pri_neigh from neighborhoods where  ST_Contains(neighborhoods.the_geom,crimes.the_geom)"
# uncomment to code only "Little Village" (neighborhood #110)
psql -c "update crimes set neigh_number = neighborhoods.pri_neigh_::integer, neighborhood = neighborhoods.pri_neigh from neighborhoods where  ST_Contains(neighborhoods.the_geom,crimes.the_geom) and neighborhoods.pri_neigh_ = '110'"

psql -c "alter table crimes add census_tract varchar(11);" $DATABASE
# uncomment to code all neighborhoods. slow...
psql -c "update crimes set census_tract = censustractstiger2010.geoid10 from censustractstiger2010 where ST_Contains(censustractstiger2010.the_geom,crimes.the_geom)"  $DATABASE
# uncomment to code only "Little Village" (neighborhood #110)
# psql -c "update crimes set neigh_number = neighborhoods.pri_neigh_::integer, neighborhood = neighborhoods.pri_neigh from neighborhoods where  ST_Contains(neighborhoods.the_geom,crimes.the_geom) and neighborhoods.pri_neigh_ = '110'"
