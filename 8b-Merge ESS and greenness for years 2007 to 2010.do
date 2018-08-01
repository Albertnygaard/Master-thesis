********************************************************************************
* Merges ESS-data at EA-level and then estimates monthly weather indicators    *
* as the inverse-distance weighted avg. of the 4 surrounding satellite         *
* observations using a 0.05 degree grid.                                       *
* Albert Nygård, May 2018                                                      *
********************************************************************************

/* First create scraped dataset with only relevant variables to overcome
computing constraints */

clear all 
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"

use "predicted_greenness_final.dta"

/* dropping unnecessary variables due to STATA constraints */

keep if year>2007
keep if year<2011

keep id lon lat time year month ndvi_an ///
ndvi_hat_an_rf

egen t2 = concat(year month), punct("_")
drop year month time

reshape wide ndvi_an ndvi_hat_an_rf, i(id lon lat) j(t2) string

sa "predicted_greenness_wide20072010.dta", replace


clear all
use predicted_greenness_wide20072010.dta

* 1. generate four datasets (one for each corner of the world):

egen nw = concat(lat lon), punct("_")

foreach var of varlist ndvi* {
rename `var' nw_`var'
}

sa eth_nw20072010, replace

rename nw* ne*
sa eth_ne20072010, replace

rename ne* sw*
sa eth_sw20072010, replace

rename sw* se*
sa eth_se20072010, replace


* 2. Open survey data with GPS coordinates:

u "ESS_cleaned.dta", clear

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

* 7. join in the climate data in each of the four nearest bounding box corners

joinby nw using eth_nw20072010, unmatched(master)
drop _merge
joinby ne using eth_ne20072010, unmatched(master)
drop _merge
joinby sw using eth_sw20072010, unmatched(master)
drop _merge
joinby se using eth_se20072010, unmatched(master)
drop _merge

/* 8. make sure to disregard observations that fall outside ethiopia
(since there is no weather variables for this). In practice, this mean that
it will only take the average of the 3 surrounding pixels instead of the four
in these few examples */

foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach n in nw_ ne_ sw_ se_ {
replace `n'ndvi_an`y'_`m' = 0 if missing(`n'ndvi_an`y'_`m')
replace `n'ndvi_hat_an_rf`y'_`m' = 0 if missing(`n'ndvi_hat_an_rf`y'_`m')
}
}
}

* 8. calculate the weighted average of each of the weather variables for each of the gps coordinates of the survey:

foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
capture g `x'`y'_`m' = (nw_`x'`y'_`m'*1/nw_dis + ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/nw_dis + 1/ne_dis + 1/sw_dis + 1/se_dis)
}
}
}

/* for missing NW*/
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/ne_dis + 1/sw_dis + 1/se_dis) if nw_`x'`y'_`m'==0
}
}
}

/* for missing NE*/
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/nw_dis + 1/sw_dis + 1/se_dis) if ne_`x'`y'_`m'==0
}
}
}

/* for missing SW*/
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/nw_dis + 1/ne_dis + 1/se_dis) if sw_`x'`y'_`m'==0
}
}
}

/* for missing SE*/
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/nw_dis + 1/ne_dis + 1/sw_dis) if se_`x'`y'_`m'==0
}
}
}

/* for missing NE and NW */
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/se_dis + 1/sw_dis) if ne_`x'`y'_`m'==0 & nw_`x'`y'_`m'==0
}
}
}

/* for missing NE and SE */
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/nw_dis + 1/sw_dis) if ne_`x'`y'_`m'==0 & se_`x'`y'_`m'==0
}
}
}

/* for missing NE and SW */
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/nw_dis + 1/se_dis) if ne_`x'`y'_`m'==0 & sw_`x'`y'_`m'==0
}
}
}

/* for missing NW and SE */
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/ne_dis + 1/sw_dis) if nw_`x'`y'_`m'==0 & se_`x'`y'_`m'==0
}
}
}

/* for missing NW and SW */
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/ne_dis + 1/se_dis) if nw_`x'`y'_`m'==0 & sw_`x'`y'_`m'==0
}
}
}

/* for missing SE and SW */
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/ne_dis + 1/nw_dis) if se_`x'`y'_`m'==0 & sw_`x'`y'_`m'==0
}
}
}

/* for missing SE and SW and NW*/
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/ne_dis) if se_`x'`y'_`m'==0 & sw_`x'`y'_`m'==0 & nw_`x'`y'_`m'==0
}
}
}

/* for missing SE and SW and NE*/
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/nw_dis) if se_`x'`y'_`m'==0 & sw_`x'`y'_`m'==0 & ne_`x'`y'_`m'==0
}
}
}

/* for missing SE and NW and NE*/
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/sw_dis) if se_`x'`y'_`m'==0 & nw_`x'`y'_`m'==0 & ne_`x'`y'_`m'==0
}
}
}

/* for missing SW and NW and NE*/
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
foreach x in ndvi_an ndvi_hat_an_rf{
replace `x'`y'_`m' = (ne_`x'`y'_`m'*1/ne_dis + sw_`x'`y'_`m'*1/sw_dis + se_`x'`y'_`m'*1/se_dis)/(1/se_dis) if sw_`x'`y'_`m'==0 & nw_`x'`y'_`m'==0 & ne_`x'`y'_`m'==0
}
}
}

/* re-generate missing values */
foreach y in 2008 2009 2010 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
replace ndvi_an`y'_`m' = . if ndvi_an`y'_`m'==0
replace ndvi_hat_an_rf`y'_`m' = . if ndvi_hat_an_rf`y'_`m'==0
}
}


* 9. Drop unwanted variables here (you may want to add the lat and lon to the list):

drop nw* ne* sw* se* north south east west


* 10. Save the outcome:

sa ESS_gps_weather20072010, replace

