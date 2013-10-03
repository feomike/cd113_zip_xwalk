copy (
select state, statefp, cd113fp, zip5
  from analysis.mydata, analysis.zip5
  where st_contains(mydata.geom, zip5.geom)
--    and state = 'RI'
  order by state, cd113fp
)
to '~/downloads/xwalk.csv'
header delimiter ',' csv;
