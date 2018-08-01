********************************************************************************
* Identifies periods of drought and initial analysis 				       	   *
* Albert Nygård, May 2018                                                      *
********************************************************************************

clear all
set more off

cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"

use ESS_gps_weather.dta


/* fixing small error in survey */

replace ea_id="04080600802" if ea_id=="040806088800802"
replace ea_id="04060501004" if ea_id=="040605088801004"
replace ea_id= "04060100102" if ea_id=="040601020100102"

sa "ESS_gps_weather.dta", replace


*******************************************************************************
******************* merge w data on NDVI and from 2008 ************************
clear all
use "ESS_gps_weather_NDVIONLY.dta"
keep ea_id year ndvi2011_1-ndvi2017_12

replace ea_id="04080600802" if ea_id=="040806088800802"
replace ea_id="04060501004" if ea_id=="040605088801004"
replace ea_id= "04060100102" if ea_id=="040601020100102"
replace year=2014 if year==2015

sa "ESS_gps_weather_NDVIONLY.dta", replace

clear all 
use "ESS_gps_weather20072010.dta"

keep ea_id year ndvi_an2008_1-ndvi_hat_an_rf2010_12

replace ea_id="04080600802" if ea_id=="040806088800802"
replace ea_id="04060501004" if ea_id=="040605088801004"
replace ea_id= "04060100102" if ea_id=="040601020100102"
replace year=2014 if year==2015

sa "ESS_gps_weather20072010.dta", replace

use ESS_gps_weather.dta


merge 1:1 ea_id year using "ESS_gps_weather20072010.dta", nogen
merge 1:1 ea_id year using "ESS_gps_weather_NDVIONLY.dta", nogen


*******************************************************************************
************ Descriptive statistics *******************************************

/* define main harvest months */

label var plant_month_1 "Major planting month for major crop (1st)"
twoway hist plant_month_1, xsca(range(0 12)) ysca(range(0 .8))
label var plant_month_3 "Major planting month for major crop (3rd)"
twoway hist plant_month_3, xsca(range(0 12)) 

twoway hist harvest_month_1, xsca(range(0 12)) 
twoway hist harvest_month_3, xsca(range(0 12)) 

/* define greenness anomalies */

foreach t in 2012 2013 2014 2015 2016 2017 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
summarize ndvi_hat_an_rf`t'_`m' if year==2012
}
}

count if year==2012
count if year==2014
count if year==2016

count if year==2012 & PSNP_days>0
count if year==2014 & PSNP_days>0
count if year==2016 & PSNP_days>0

/* create wide-measure of treatment */
foreach y in 2012 2014 2016 {
gen t_PSNP_days_`y' = 0
replace t_PSNP_days_`y' = PSNP_days if year==`y'
bysort ea_id: egen PSNP_days_`y' = total(t_PSNP_days_`y')
drop t_PSNP_days_`y'
}



/* create treatment dummy if PSNP_days > 1 */

foreach m in 2012 2014 2016{
gen PSNP_part_`m' = 0
replace PSNP_part_`m' = 1 if PSNP_days>0 & year==`m'
}

order ea_id year PSNP_days PSNP_part_2012 PSNP_part_2014 PSNP_part_2016

/* generate acumulated treatment*/
bysort ea_id: egen PSNP_2012 = total(PSNP_part_2012)
bysort ea_id: egen PSNP_2014 = total(PSNP_part_2014)
bysort ea_id: egen PSNP_2016 = total(PSNP_part_2016)

gen PSNP_acc_2014 = PSNP_2012 + PSNP_2014
replace PSNP_acc_2014=1 if PSNP_acc_2014>0

gen PSNP_acc_2016 = PSNP_2012 + PSNP_2014 + PSNP_2016
replace PSNP_acc_2016=1 if PSNP_acc_2016>0

count if PSNP_acc_2014>0 & year==2014
count if PSNP_acc_2016>0 & year==2016

drop PSNP_part_2012
drop PSNP_part_2014
drop PSNP_part_2016

order ea_id year PSNP_days PSNP_2012 PSNP_acc_2014 PSNP_acc_2016

count if PSNP_acc_2014==1 & year==2014
count if PSNP_acc_2016==1 & year==2016



/* generate household size */

gen avg_hh_size = hhsize / hh_respondents

/* gen previous drought shocks during 2010-2011*/

foreach y in 2008 2009 2010 2011 {
gen drought`y' = 0
replace drought`y'=1 if ndvi_hat_an_rf`y'_8<-10 & ndvi_hat_an_rf`y'_9<-10
replace drought`y'=1 if ndvi_hat_an_rf`y'_8<-10 & ndvi_hat_an_rf`y'_10<-10
replace drought`y'=1 if ndvi_hat_an_rf`y'_9<-10 & ndvi_hat_an_rf`y'_10<-10
replace drought`y'=1 if ndvi_hat_an_rf`y'_8<-10 & ndvi_hat_an_rf`y'_9<-10 & ndvi_hat_an_rf`y'_10<-10 
}


gen avg_ndvi2011 = (ndvi2011_1 + ndvi2011_2 +ndvi2011_3 + ndvi2011_4 + ndvi2011_5 + ndvi2011_6 + ndvi2011_7 + ndvi2011_8 + ndvi2011_9 + ndvi2011_10 + ndvi2011_11 + ndvi2011_12)/12 


/* gen land use dummies */
gen d_squatter = 0
replace d_squatter = 1 if common_land_use==4
gen d_farming = 0
replace d_farming = 1 if common_land_use==2
gen d_other = 0
replace d_other = 1 if common_land_use==7
gen d_pasture = 0
replace d_pasture = 1 if common_land_use==1
gen d_plannedhousing = 0
replace d_plannedhousing = 1 if common_land_use==3
gen d_shops = 0
replace d_shops = 1 if common_land_use==6

/* gen region dummies */

gen d_tigray=0
replace d_tigray=1 if region==1
gen d_afar=0
replace d_afar=1 if region==2
gen d_amhara=0
replace d_amhara=1 if region==3
gen d_oromia=0
replace d_oromia=1 if region==4
gen d_somalie=0
replace d_somalie=1 if region==5
gen d_snnp=0
replace d_snnp=1 if region==7
gen d_harari=0
replace d_harari=1 if region==13
gen d_direwa=0
replace d_direwa=1 if region==15


/* summarize covariates between treated and control */
/* for the 2012 round */

gen avg_plotsize_ha = avg_plotsize/10000



bysort PSNP_2012: summarize nr_households_kebele if year==2012
bysort PSNP_2012: summarize PSNP_participants if year==2012
bysort PSNP_2012: summarize PSNP_days if year==2012
bysort PSNP_2012: summarize share_other_assistance if year==2012
bysort PSNP_2012: summarize dist_center if year==2012

bysort PSNP_2012: summarize ndvi2012_9 if year==2012

bysort PSNP_2012: summarize avg_plotsize if year==2012
bysort PSNP_2012: summarize share_advisory if year==2012
bysort PSNP_2012: summarize sqm_land if year==2012
bysort PSNP_2012: summarize avg_share_agr if year==2012
bysort PSNP_2012: summarize share_large_farms if year==2012
bysort PSNP_2012: summarize avg_plot_twi if year==2012

bysort PSNP_2012: summarize share_irrigated if year==2012
bysort PSNP_2012: summarize share_fertilized if year==2012
bysort PSNP_2012: summarize field_mgmt_constraints if year==2012
bysort PSNP_2012: summarize agr_dev_agent if year==2012
bysort PSNP_2012: summarize share_little_rain if year==2012

bysort PSNP_2012: summarize share_other_shock if year==2012
bysort PSNP_2012: summarize share_food_insecure_yr if year==2012
bysort PSNP_2012: summarize food_consumption_aeq if year==2012
bysort PSNP_2012: summarize nonfood_consumption_aeq if year==2012
bysort PSNP_2012: summarize share_hh_educated if year==2012

/* rename variables */

rename share_other_assistance sh_oass
rename share_food_insecure_yr sh_insec
rename food_consumption_aeq food_con
rename nonfood_consumption_aeq nonfood_con
rename field_mgmt_constraints field_const
rename share_land_dmg_drought dmg_drought


gen d_sparse = 0
replace d_sparse =1 if land_class==200 | land_class ==150

/* generate differences */
foreach t in 2012 2013 2014 2015 2016 2017 {
foreach m in 1 2 3 4 5 6 7 8 9 10 11 12 {
gen diff_an`t'_`m' = ndvi_an`t'_`m' - ndvi_hat_an_rf`t'_`m'
}
}

/* generate treatment variables */
egen mean_diff_2015 = rowmean(diff_an2015_8 diff_an2015_9 diff_an2015_10)
egen mean_diff_2016 = rowmean(diff_an2016_8 diff_an2016_9 diff_an2016_10)


/* gen zone dummies */
egen zone_dummy = concat(region zone_code), punct("_")
bysort zone_dummy: gen n = _n
bysort n: gen zone_id=_n
gen zone_id2 = zone_id if n==1
bysort zone_dummy: egen d_zone = mean(zone_id2)
drop zone_dummy n zone_id zone_id2

sa "ESS_gps_weather_analysis.dta", replace

/* creating spatial distance */

clear all 
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"

/* generate minimum distance and merge on dataset */
use "ESS_gps_weather_analysis.dta"

keep if year==2012

keep lat lon id

gen id2 = _n

/* lat */
forvalues n = 1/333 {
egen lat_`n' = total(lat) if id2==`n'


}
forvalues n = 1/333 {
egen lat`n' = total(lat_`n')
}

drop lat_1-lat_333

/* lon */
forvalues n = 1/333 {
egen lon_`n' = total(lon) if id2==`n'
}

forvalues n = 1/333 {
egen lon`n' = total(lon_`n')
}

drop lon_1-lon_333

forvalues n = 1/333 {
vincenty lat lon lat`n' lon`n', vin(distfrom_`n') inkm
}

forvalues n = 1/333 {
replace distfrom_`n' = 1000 if id2==`n'
}

drop lat1-lat333
drop lon1-lon333

egen mindistance = rowmin(distfrom_1-distfrom_333)

forvalues n = 1/333 {
gen v`n' = distfrom_`n'-mindistance
}

forvalues n = 1/333 {
replace v`n' = . if v`n' > 0.05
}

forvalues n = 1/333 {
replace v`n' = `n' if !missing(v`n')
}

egen id_neighbor = rowtotal(v1-v333)

drop v1-v333
drop distfrom_1 - distfrom_333

drop if missing(id)
sa "ESS_dist_2011.dta", replace

merge 1:m lat lon using ESS_gps_weather_analysis.dta, nogen

sort id2

sa ESS_gps_weather_analysis.dta, replace

clear all 
use ESS_gps_weather_analysis.dta
keep id2 PSNP_acc_2016
rename PSNP_acc_2016 is_neighbor_treated
rename id2 id_neighbor
bysort id_neighbor: gen dup = _n
drop if dup>1
drop dup

sa ESS_neighbortreat.dta, replace
merge 1:m id_neighbor using ESS_gps_weather_analysis.dta, nogen
drop if missing(lat)

sa "ESS_gps_weather_analysis.dta", replace

