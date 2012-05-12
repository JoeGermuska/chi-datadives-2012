#!/usr/bin/env bash
# dump crimes out with everything but coordinate data, plus with times split out
DATABASE='datakind'
WORKING_DIR=`pwd`
psql -c "copy (select case_number, crime_date, block, iucr, primary_type, description, location_description, arrest, domestic, beat, ward, fbi_code, year, area_number, community_area, neigh_number, neighborhood, census_tract, extract(hour from crime_date) as hour, extract(month from crime_date) as month, extract(day from crime_date) as day from crimes) to '${WORKING_DIR}/crimes_plus.csv' csv header" $DATABASE
