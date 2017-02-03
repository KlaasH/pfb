#!/usr/bin/env bash

# vars
export PGHOST="${NB_POSTGRESQL_HOST:-127.0.0.1}"
export PGDATABASE="${NB_POSTGRESQL_DB:-pfb}"
export PGUSER="${NB_POSTGRESQL_USER:-gis}"
export PGPASSWORD="${NB_POSTGRESQL_PASSWORD:-gis}"

# drop old tables
echo 'Dropping old tables'
psql -c "DROP TABLE IF EXISTS received.neighborhood_ways;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_ways_intersections;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_relations_ways;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_osm_nodes;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_osm_relations;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_osm_way_classes;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_osm_way_tags;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_osm_way_types;"
psql -c "DROP TABLE IF EXISTS scratch.neighborhood_cycwys_ways;"
psql -c "DROP TABLE IF EXISTS scratch.neighborhood_cycwys_ways_vertices_pgr;"
psql -c "DROP TABLE IF EXISTS scratch.neighborhood_cycwys_relations_ways;"
psql -c "DROP TABLE IF EXISTS scratch.neighborhood_cycwys_osm_nodes;"
psql -c "DROP TABLE IF EXISTS scratch.neighborhood_cycwys_osm_relations;"
psql -c "DROP TABLE IF EXISTS scratch.neighborhood_cycwys_osm_way_classes;"
psql -c "DROP TABLE IF EXISTS scratch.neighborhood_cycwys_osm_way_tags;"
psql -c "DROP TABLE IF EXISTS scratch.neighborhood_cycwys_osm_way_types;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_osm_full_line;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_osm_full_point;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_osm_full_polygon;"
psql -c "DROP TABLE IF EXISTS received.neighborhood_osm_full_roads;"
