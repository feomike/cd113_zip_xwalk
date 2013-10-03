-- Table: analysis.zip5

DROP TABLE if exists analysis.zip5;

CREATE TABLE analysis.zip5
(
  zip5 character varying(5),
  city character varying(50),
  state character varying(2),
  latitude numeric,
  longitude numeric,
  county character varying(50)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE analysis.zip5
  OWNER TO postgres;

copy analysis.zip5 from 
  '/users/feomike/downloads/zip5.csv'
  csv delimiter ',';

update analysis.zip5
  set longitude = longitude * -1;
 
SELECT AddGeometryColumn ('analysis', 'zip5','geom', 4326, 'POINT',2); 

update analysis.zip5
  set geom = ST_SetSRID(ST_MakePoint("longitude", "latitude"), 4326)
