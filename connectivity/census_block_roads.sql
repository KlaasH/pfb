----------------------------------------
-- INPUTS
-- location: neighborhood
-- :nb_boundary_buffer psql var must be set before running this script,
-- :nb_output_srid psql var must be set before running this script,
--      e.g. psql -v nb_boundary_buffer=11000 -v nb_output_srid=2249 -f census_block_roads.sql
----------------------------------------
DROP TABLE IF EXISTS generated.neighborhood_census_block_roads;

CREATE TABLE generated.neighborhood_census_block_roads (
    id SERIAL PRIMARY KEY,
    blockid10 VARCHAR(15),
    road_id INT
);

-- build a temporary table with buffered geoms to efficiently get
-- containing roads
CREATE TEMP TABLE tmp_block_buffers (
    id INTEGER PRIMARY KEY,
    blockid10 VARCHAR(15),
    geom geometry(multipolygon, :nb_output_srid)
);
INSERT INTO tmp_block_buffers
SELECT gid, blockid10, ST_Multi(ST_Buffer(geom,50)) FROM neighborhood_census_blocks;
CREATE INDEX tidx_neighborhood_blockgeoms ON tmp_block_buffers USING GIST (geom);
ANALYZE tmp_block_buffers;

-- insert blocks and roads
INSERT INTO generated.neighborhood_census_block_roads (
    blockid10,
    road_id
)
SELECT  blocks.blockid10,
        ways.road_id
FROM    tmp_block_buffers blocks,
        neighborhood_ways ways
WHERE   EXISTS (
            SELECT  1
            FROM neighborhood_boundary AS b
            WHERE ST_DWithin(blocks.geom, b.geom, :nb_boundary_buffer)
)
AND     ST_Intersects(blocks.geom,ways.geom)
AND     (
            ST_Contains(blocks.geom,ways.geom)
        OR  ST_Length(
                ST_Intersection(blocks.geom,ways.geom)
            ) > 100
        );

CREATE INDEX IF NOT EXISTS idx_neighborhood_censblkrds
ON generated.neighborhood_census_block_roads (blockid10,road_id);
ANALYZE generated.neighborhood_census_block_roads;
