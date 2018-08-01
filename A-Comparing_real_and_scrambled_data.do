
********************************************************************************
* Compares real weather data with scrambled weather data for urban and rural   * 
* households in ESS2 after inverse-distance weighted matching                  *
* Albert Nygård, June 2018 *                                                   *
********************************************************************************

clear all

cd "C:\Users\Albert\Documents\Polit\Speciale_local\WB\Data\Real_coordinates\NDVI"

u ethiopia_wide_pred, clear

/* first we remove unwanted variables from the dataset */

foreach y in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 {
foreach m in 01 02 03 04 05 06 07 08 09 10 11 12 {
foreach x in lst_day lst_night chirps dm_ndvi_hat_ols z_ndvi_hat_ols{
drop `x'`y'`m'
}
}
}


* 1. generate four datasets (one for each corner of the world):

egen nw = concat(lat lon), punct("_")

foreach var of varlist ndvi* {
rename `var' nw_`var'
}
sa eth_nw, replace

rename nw* ne*
sa eth_ne, replace

rename ne* sw*
sa eth_sw, replace

rename sw* se*
sa eth_se, replace


* 2. Open survey data with GPS coordinates:

u "ESS2.dta", clear

* 3. Make sure latitude and longitude variables are called lat and lon:

rename lat_dd lat
rename lon_dd lon

* 4. Calculate the bounding box of each 0.05 degree latitude-longitude cell to which the coordinate belongs:

g north = ceil((lat+0.025)*20)/20-0.025
g south = floor((lat+0.025)*20)/20-0.025
g west = floor((lon+0.025)*20)/20-0.025
g east = ceil((lon+0.025)*20)/20-0.025

* 5. Name the four corners:

egen nw = concat(north west), p(_)
egen ne = concat(north east), p(_)
egen sw = concat(south west), p(_)
egen se = concat(south east), p(_)

* 6. Calculate the distance from each coordinate to the four nearest bounding box corners:

vincenty lat lon north west, vin(nw_dis) inkm
vincenty lat lon north east, vin(ne_dis) inkm
vincenty lat lon south west, vin(sw_dis) inkm
vincenty lat lon south east, vin(se_dis) inkm

* 7. join in the climate data in each of the four nearest bounding box corners:

joinby nw using eth_nw, unmatched(master)
drop _merge
joinby ne using eth_ne, unmatched(master)
drop _merge
joinby sw using eth_sw, unmatched(master)
drop _merge
joinby se using eth_se, unmatched(master)
drop _merge


* 8. calculate the weighted average of each of the weather variables for each of the gps coordinates of the survey:

foreach y in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 {
foreach m in 01 02 03 04 05 06 07 08 09 10 11 12 {
foreach x in ndvi {
capture g `x'`y'`m' = (nw_`x'`y'`m'*1/nw_dis + ne_`x'`y'`m'*1/ne_dis + sw_`x'`y'`m'*1/sw_dis + se_`x'`y'`m'*1/se_dis)/(1/nw_dis + 1/ne_dis + 1/sw_dis + 1/se_dis)
}
}
}

* 9. Drop unwanted variables here (you may want to add the lat and lon to the list):

drop nw* ne* sw* se* north south east west

foreach x of varlist ndvi200001-ndvi201612 {

 replace `x' = round(`x')
 
}

rename ndvi* an_ndvi*

* 10. Save the outcome:

sa ESS_gps_weather_ndvi_an, replace

* 11. Merge with real coordinates **
clear all
use ESS_gps_weather_r05232017

drop if missing(household_id2)

merge 1:1 household_id2 using ESS_gps_weather_ndvi_an, nogen

sa ESS_real_and_scrambled_ndvi, replace

********************************************************************************

/* Analyze differences */

clear all
use ESS_real_and_scrambled_ndvi

/* scaling to units of 1000, so 1 = 0.001 NDVI. Currently in units of 10,000 */

foreach y in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 {
foreach m in 01 02 03 04 05 06 07 08 09 10 11 12 {
replace ndvi`y'`m' =  ndvi`y'`m'*0.1
replace an_ndvi`y'`m' =  an_ndvi`y'`m'*0.1
}
}


/* create differences */

foreach y in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 {
foreach m in 01 02 03 04 05 06 07 08 09 10 11 12 {
gen diff_ndvi`y'`m' =  ndvi`y'`m' - an_ndvi`y'`m'
}
}

/* create urban indicator */
gen urban = 0
replace urban=1 if rural==3

/* keep relevant variables and append */

keep household_id2 urban rural diff_ndvi200001-diff_ndvi201612

reshape long diff_ndvi, i(household_id2) j(time)

bysort urban: ttest diff_ndvi==0
bysort rural: ttest diff_ndvi==0


sa diff_ndvi, replace

