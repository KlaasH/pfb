#!/usr/bin/env bash

set -e

cd `dirname $0`

export PGHOST="${NB_POSTGRESQL_HOST:-127.0.0.1}"
export PGDATABASE="${NB_POSTGRESQL_DB:-pfb}"
export PGUSER="${NB_POSTGRESQL_USER:-gis}"
export PGPASSWORD="${NB_POSTGRESQL_PASSWORD:-gis}"

NB_OUTPUT_SRID="${NB_OUTPUT_SRID:-4326}"
NB_BOUNDARY_BUFFER="${NB_BOUNDARY_BUFFER:-0}"

psql -c "SELECT tdgMakeNetwork('neighborhood_ways');"

psql -c "SELECT tdgNetworkCostFromDistance('neighborhood_ways');"

/usr/bin/time -v psql -f connectivity/census_blocks.sql

/usr/bin/time -v psql -v nb_boundary_buffer="${NB_BOUNDARY_BUFFER}" -v nb_output_srid="${NB_OUTPUT_SRID}" \
  -f connectivity/census_block_roads.sql

/usr/bin/time -v psql -f connectivity/reachable_roads_high_stress.sql

/usr/bin/time -v psql -f connectivity/reachable_roads_low_stress.sql

/usr/bin/time -v psql -v nb_boundary_buffer="${NB_BOUNDARY_BUFFER}" \
  -f connectivity/connected_census_blocks.sql

/usr/bin/time -v psql -f connectivity/access_population.sql

/usr/bin/time -v psql -f connectivity/census_block_jobs.sql

/usr/bin/time -v psql -f connectivity/access_jobs.sql

/usr/bin/time -v psql -v nb_output_srid="${NB_OUTPUT_SRID}" -f connectivity/schools.sql

/usr/bin/time -v psql -v nb_boundary_buffer="${NB_BOUNDARY_BUFFER}" -f connectivity/school_roads.sql

/usr/bin/time -v psql -v nb_boundary_buffer="${NB_BOUNDARY_BUFFER}" \
  -f connectivity/connected_census_blocks_schools.sql

/usr/bin/time -v psql -f connectivity/access_schools.sql

/usr/bin/time -v psql -f connectivity/overall_scores.sql
