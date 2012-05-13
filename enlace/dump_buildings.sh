#!/usr/bin/env bash
# dump crimes out with everything but coordinate data, plus with times split out
DATABASE='datakind'
WORKING_DIR=`pwd`
psql -c "copy (select request_number, date_received, location_on_lot, dangerous_or_hazardous, dangerous, open_or_boarded, open, entry_point, vacant_or_occupied, vacant_flag, vacant_due_to_fire, fire_flag, people_using_property, in_use_flag, address_street_num, address_street_dir, address_street_name, address_street_suffix, zip_code, full_address, x_coordinate, y_coordinate, latitude, longitude, location, the_geom, area_number, community_area, neigh_number, neighborhood from vacant_311) to '${WORKING_DIR}/vacant_311_plus.csv' csv header" $DATABASE
