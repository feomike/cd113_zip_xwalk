cd113_zip_xwalk
===============

cross walk of 113th congressional districts to zip codes

This describes the processing steps required to create the [xwalk.csv file](https://github.com/feomike/cd113_zip_xwalk/blob/master/xwalk.csv).

The file is the crosswalk of five digit ZIP Code centroids to Congressional Districts.  A single row in the file represents the single ZIP Code's Congressional District, where the centroid of that ZIP code falls within the Congressional District Boundary.  There is one row in the file for each ZIP Code.

Sources
-------

The data sources for this crosswalk are:

* ZIP5 - ZIP Code Centroids were downloaded from [this site](http://geocoder.ca/?freedata=1).  The file named [US ZIP Codes (41,755)](http://geocoder.ca/onetimedownload/zip5.csv.gz) was downloaded and unzipped resulting in a single csv file with 5 columns;

	- 5 digit ZIP Code
	- City
	- State
	- Latitude
	- Longitude
	- County

* 113 Congressional Districts - Congressional Districts were downloaded from [this site](https://github.com/jsongeo).  The file named [cd113](https://github.com/jsongeo/cd113) was downloaded and unzipped resulting in several files.  Only the .geojson file was used, which contained the following fields;

	- gid
	- statefp
	- cd113fp
	- geiod
	- namelsad
	- lsad   
	- cdsessn  
	- mtfcc
	- funcstat
	- aland
	- awater
	- intptlat
	- intptlon
	- geom
	
Processing Notes
----------------
In order to get the crosswalk file, the following steps were taken;

Convert Data to PostgGis tables:

cd113
-----

* use the command ogr2ogr -f "ESRI Shapefile" cd113.shp cd113.geojson; which converts the geoJson file to a shapefile

* use the OpenGeo shape2pgsl to convert the cd113.geojson file to a PostGis table 

* NOTE: Yes i could have used ogr2ogr to convert this to PostGis in one step, i just didn't do that

ZIP5
----

* use [this script](https://github.com/feomike/cd113_zip_xwalk/blob/master/load_zip5.sql) to load the ZIP5.csv into a postGis table and, make sure that the longitude field is in the western hemisphere (e.g. calculate to a negative - value), add and populate the geometry column	based on the latitude and longitude field.

Analysis
--------
Perform the analysis by using the ST_Contains function in postGis, which establishes that a geometry in one table is entirely and always within a geometry in another table.  In this case we want to make sure that the geometry of the ZIP5 centroid is always within the geometry of the Congressional District boundary.  I used [this script](https://github.com/feomike/cd113_zip_xwalk/blob/master/analysis.sql) to do that.
