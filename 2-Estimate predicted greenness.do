** Do-file for estimating predicted greenness from panel-data set
** Author: Albert Nygård
** Last modified: Wed. 07/06/2018

clear all
set more off

global path "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"
 
use "$path\weather_data_panel.dta"

drop if missing(ndvi)

/* Scaling/units:
NDVI: 0.001 NDVI
Rain: 0.1 mm/hour (so an increase of one corresponds to about 740 mm/month)
LST: 1 Kelvin
Latitude: 1 Meter
GHI: Kwh/m2
Climate_zones: Köppen-Geiger climate zones
CHIRPS: total mm/month
*/

** set panel **
xtset id time

*******************************************************************************
********************************* TABLE 1 *************************************

/* Generate lagged variables */

* rain_trmm *
foreach y in 1 2 3 4 5 6 {
gen rain_trmm_lag`y' = l`y'.rain_trmm
}

* lst_day *
foreach y in 1 2 3 4 5 6 {
gen lst_day_lag`y' = l`y'.lst_day
}

* lst_night *
foreach y in 1 2 3 4 5 6 {
gen lst_night_lag`y' = l`y'.lst_night
}

/* generate monthly interaction term */
gen rain_trmm_month = month#c.rain_trmm
foreach y in 1 2 3 4 5 6 {
gen rain_trmm_month_lag`y' = month#c.rain_trmm_lag`y'
}

gen lst_day_month = month#c.lst_day
foreach y in 1 2 3 4 5 6 {
gen lst_day_month_lag`y' = month#c.lst_day_lag`y'
}

gen lst_night_month = month#c.lst_night
foreach y in 1 2 3 4 5 6 {
gen lst_night_month_lag`y' = month#c.lst_night_lag`y'
}

/* generate climate-zone interaction terms */
gen rain_trmm_cz = climate_zones#c.rain_trmm
foreach y in 1 2 3 4 5 6 {
gen rain_trmm_cz_lag`y' = climate_zones#c.rain_trmm_lag`y'
}

gen lst_day_cz = climate_zones#c.lst_day
foreach y in 1 2 3 4 5 6 {
gen lst_day_cz_lag`y' = climate_zones#c.lst_day_lag`y'
}

gen lst_night_cz = climate_zones#c.lst_night
foreach y in 1 2 3 4 5 6 {
gen lst_night_cz_lag`y' = climate_zones#c.lst_night_lag`y'
}


/* generate climate-zone and monthly interaction terms */
gen rain_trmm_m_cz = month#climate_zones#c.rain_trmm
foreach y in 1 2 3 4 5 6 {
gen rain_trmm_m_cz_lag`y' = month#climate_zones#c.rain_trmm_lag`y'
}

gen lst_day_m_cz = month#climate_zones#c.lst_day
foreach y in 1 2 3 4 5 6 {
gen lst_day_m_cz_lag`y' = month#climate_zones#c.lst_day_lag`y'
}

gen lst_night_m_cz = month#climate_zones#c.lst_night
foreach y in 1 2 3 4 5 6 {
gen lst_night_m_cz_lag`y' = month#climate_zones#c.lst_night_lag`y'
}




/* Label variables */

global rain_trmm rain_trmm rain_trmm_lag1 rain_trmm_lag2 rain_trmm_lag3 rain_trmm_lag4 rain_trmm_lag5 rain_trmm_lag6 
global rain_trmm_month rain_trmm_month rain_trmm_month_lag1 rain_trmm_month_lag2 rain_trmm_month_lag3 rain_trmm_month_lag4 rain_trmm_month_lag5 rain_trmm_month_lag6
global rain_trmm_cz rain_trmm_cz rain_trmm_cz_lag1 rain_trmm_cz_lag2 rain_trmm_cz_lag3 rain_trmm_cz_lag4 rain_trmm_cz_lag5 rain_trmm_cz_lag6
global rain_trmm_m_cz rain_trmm_m_cz rain_trmm_m_cz_lag1 rain_trmm_m_cz_lag2 rain_trmm_m_cz_lag3 rain_trmm_m_cz_lag4 rain_trmm_m_cz_lag5 rain_trmm_m_cz_lag6

global lst_day lst_day lst_day_lag1 lst_day_lag2 lst_day_lag3 lst_day_lag4 lst_day_lag5 lst_day_lag6 
global lst_day_month lst_day_month lst_day_month_lag1 lst_day_month_lag2 lst_day_month_lag3 lst_day_month_lag4 lst_day_month_lag5 lst_day_month_lag6
global lst_day_cz lst_day_cz lst_day_cz_lag1 lst_day_cz_lag2 lst_day_cz_lag3 lst_day_cz_lag4 lst_day_cz_lag5 lst_day_cz_lag6
global lst_day_m_cz lst_day_m_cz lst_day_m_cz_lag1 lst_day_m_cz_lag2 lst_day_m_cz_lag3 lst_day_m_cz_lag4 lst_day_m_cz_lag5 lst_day_m_cz_lag6

global lst_night lst_night lst_night_lag1 lst_night_lag2 lst_night_lag3 lst_night_lag4 lst_night_lag5 lst_night_lag6
global lst_night_month lst_night_month_lag1 lst_night_month_lag2 lst_night_month_lag3 lst_night_month_lag4 lst_night_month_lag5 lst_night_month_lag6
global lst_night_cz lst_night_cz lst_night_cz_lag1 lst_night_cz_lag2 lst_night_cz_lag3 lst_night_cz_lag4 lst_night_cz_lag5 lst_night_cz_lag6
global lst_night_m_cz lst_night_m_cz lst_night_m_cz_lag1 lst_night_m_cz_lag2 lst_night_m_cz_lag3 lst_night_m_cz_lag4 lst_night_m_cz_lag5 lst_night_m_cz_lag6 

/* OLS regression with year-dummies, monthly interactions but without climate-dummies */
 
eststo: reg ndvi $rain_trmm $lst_day $lst_night ghi elevation $rain_trmm_month $lst_day_month $lst_night_month i.year
 
/* OLS regression with year-dummies, monthly interaction-terms and climate-dummies */

eststo: reg ndvi $rain_trmm $lst_day $lst_night ghi elevation $rain_trmm_month $lst_day_month $lst_night_month $rain_trmm_cz $lst_day_cz $lst_night_cz $rain_trmm_m_cz $lst_day_m_cz $lst_night_m_cz i.year

 /* produce table */
 
	 esttab est1 est2 using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\out\table1.rtf", se(4) b(3) wide ///
	 replace
	 
 ******************************************************************************
 ***************************** TABLE 2 ****************************************
 
/* generate monthly means */

bysort month id: egen ndvi_mean=mean(ndvi)
bysort month id: egen lst_day_mean=mean(lst_day)
bysort month id: egen lst_night_mean=mean(lst_night)
bysort month id: egen rain_trmm_mean=mean(rain_trmm)

/* sort back */
sort id time

/* generate anomaly variables */

gen ndvi_an = ndvi-ndvi_mean
gen rain_trmm_an = rain_trmm-rain_trmm_mean
gen lst_day_an = lst_day-lst_day_mean
gen lst_night_an = lst_night-lst_night_mean

/* Generate lagged anomaly variables */

foreach y in 1 2 3 4 5 6 {
gen rain_trmm_an_lag`y' = l`y'.rain_trmm_an
}

foreach y in 1 2 3 4 5 6 {
gen lst_day_an_lag`y' = l`y'.lst_day_an
}

foreach y in 1 2 3 4 5 6 {
gen lst_night_an_lag`y' = l`y'.lst_night_an
}

/* generate monthly dummies */
gen rain_trmm_an_m = month#c.rain_trmm_an
foreach y in 1 2 3 4 5 6 {
gen rain_trmm_an_m_lag`y' = month#c.rain_trmm_an_lag`y'
}

gen lst_day_an_m = month#c.lst_day_an
foreach y in 1 2 3 4 5 6 {
gen lst_day_an_m_lag`y' = month#c.lst_day_an_lag`y'
}

gen lst_night_an_m = month#c.lst_night_an
foreach y in 1 2 3 4 5 6 {
gen lst_night_an_m_lag`y' = month#c.lst_night_an_lag`y'
}



/* Label variables */

global rain_trmm_an rain_trmm_an rain_trmm_an_lag1 rain_trmm_an_lag2 rain_trmm_an_lag3 rain_trmm_an_lag4 rain_trmm_an_lag5 rain_trmm_an_lag6
global rain_trmm_an_m rain_trmm_an_m rain_trmm_an_m_lag1 rain_trmm_an_m_lag2 rain_trmm_an_m_lag3 rain_trmm_an_m_lag4 rain_trmm_an_m_lag5 rain_trmm_an_m_lag6
 
global lst_day_an lst_day_an lst_day_an_lag1 lst_day_an_lag2 lst_day_an_lag3 lst_day_an_lag4 lst_day_an_lag5 lst_day_an_lag6 
global lst_day_an_m lst_day_an_m lst_day_an_m_lag1 lst_day_an_m_lag2 lst_day_an_m_lag3 lst_day_an_m_lag4 lst_day_an_m_lag5 lst_day_an_m_lag6 

global lst_night_an lst_night_an lst_night_an_lag1 lst_night_an_lag2 lst_night_an_lag3 lst_night_an_lag4 lst_night_an_lag5 lst_night_an_lag6
global lst_night_an_m lst_night_an_m lst_night_an_m_lag1 lst_night_an_m_lag2 lst_night_an_m_lag3 lst_night_an_m_lag4 lst_night_an_m_lag5 lst_night_an_m_lag6
 
 
/* Regress anomalies with year-dummies but without climate zone-dummies*/
 
eststo: reg ndvi_an $rain_trmm_an $lst_day_an $lst_night_an $rain_trmm_an_m $lst_day_an_m $lst_night_an_m i.year 
predict ndvi_hat_an

/* create climate zone interaction-terms */

gen rain_trmm_an_cz = climate_zones#c.rain_trmm_an
foreach y in 1 2 3 4 5 6 {
gen rain_trmm_an_cz_lag`y' = climate_zones#c.rain_trmm_an_lag`y'
}

gen lst_day_an_cz = climate_zones#c.lst_day_an
foreach y in 1 2 3 4 5 6 {
gen lst_day_an_cz_lag`y' = climate_zones#c.lst_day_an_lag`y'
} 

gen lst_night_an_cz = climate_zones#c.lst_night_an
foreach y in 1 2 3 4 5 6 {
gen lst_night_an_cz_lag`y' = climate_zones#c.lst_night_an_lag`y'
} 

/* generate season, climate_zone interaction */
gen rain_trmm_an_m_cz = month#climate_zones#c.rain_trmm_an
foreach y in 1 2 3 4 5 6 {
gen rain_trmm_an_m_cz_lag`y' = month#climate_zones#c.rain_trmm_an_lag`y'
}

gen lst_day_an_m_cz = month#climate_zones#c.lst_day_an
foreach y in 1 2 3 4 5 6 {
gen lst_day_an_m_cz_lag`y' = month#climate_zones#c.lst_day_an_lag`y'
} 

gen lst_night_an_m_cz = month#climate_zones#c.lst_night_an
foreach y in 1 2 3 4 5 6 {
gen lst_night_an_m_cz_lag`y' = month#climate_zones#c.lst_night_an_lag`y'
} 


/* Label variables */

global rain_trmm_an_cz rain_trmm_an_cz rain_trmm_an_cz_lag1 rain_trmm_an_cz_lag2 rain_trmm_an_cz_lag3 rain_trmm_an_cz_lag4 rain_trmm_an_cz_lag5 rain_trmm_an_cz_lag6
global rain_trmm_an_m_cz rain_trmm_an_m_cz rain_trmm_an_m_cz_lag1 rain_trmm_an_m_cz_lag2 rain_trmm_an_m_cz_lag3 rain_trmm_an_m_cz_lag4 rain_trmm_an_m_cz_lag5 rain_trmm_an_m_cz_lag6

global lst_day_an_cz lst_day_an_cz lst_day_an_cz_lag1 lst_day_an_cz_lag2 lst_day_an_cz_lag3 lst_day_an_cz_lag4 lst_day_an_cz_lag5 lst_day_an_cz_lag6
global lst_day_an_m_cz lst_day_an_m_cz lst_day_an_m_cz_lag1 lst_day_an_m_cz_lag2 lst_day_an_m_cz_lag3 lst_day_an_m_cz_lag4 lst_day_an_m_cz_lag5 lst_day_an_m_cz_lag6

global lst_night_an_cz lst_night_an_cz lst_night_an_cz_lag1 lst_night_an_cz_lag2 lst_night_an_cz_lag3 lst_night_an_cz_lag4 lst_night_an_cz_lag5 lst_night_an_cz_lag6
global lst_night_an_m_cz lst_night_an_m_cz lst_night_an_m_cz_lag1 lst_night_an_m_cz_lag2 lst_night_an_m_cz_lag3 lst_night_an_m_cz_lag4 lst_night_an_m_cz_lag5 lst_night_an_m_cz_lag6


/* Regress anomalies with year and climate dummies */
eststo: reg ndvi_an $rain_trmm_an $lst_day_an $lst_night_an $rain_trmm_an_m $lst_day_an_m $lst_night_an_m i.year ///
$rain_trmm_an_cz $lst_day_an_cz $lst_night_an_cz $rain_trmm_an_m_cz $lst_day_an_m_cz $lst_night_an_m_cz
predict ndvi_hat_cz

/* creating table 2*/
 esttab est3 est4 using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\out\table2.rtf", se(4) b(3) wide ///
 replace

/* drop missing variables */

foreach v in ndvi_an $rain_trmm_an_cz $lst_day_an_cz $lst_night_an_cz $rain_trmm_an $lst_day_an $lst_night_an $rain_trmm ndvi_an $lst_day $lst_night {
drop if missing(`v')
}

 
 drop _est_est1 _est_est2

 
 sa "$path\predicted_greenness.dta", replace

*******************************************************************************
* This section makes dataset compatible with RF, converts to .csv
* and then converts back to .dta after RF esimation in Azure 


clear all
set more off
 
use "$path\Stata_in\Predicted_greenness.dta"

/* restriction to only those variable to be used in the RF estimation */
drop id x y lon lat month ndvi time climate_zones ghi elevation chirps* *_mean

/* drop all missing variables */

/* normal */
global rain_trmm rain_trmm rain_trmm_lag1 rain_trmm_lag2 rain_trmm_lag3 rain_trmm_lag4 rain_trmm_lag5 rain_trmm_lag6 
global lst_day lst_day lst_day_lag1 lst_day_lag2 lst_day_lag3 lst_day_lag4 lst_day_lag5 lst_day_lag6 
global lst_night lst_night lst_night_lag1 lst_night_lag2 lst_night_lag3 lst_night_lag4 lst_night_lag5 lst_night_lag6
 
/* anomalies */
global rain_trmm_an rain_trmm_an rain_trmm_an_lag1 rain_trmm_an_lag2 rain_trmm_an_lag3 rain_trmm_an_lag4 rain_trmm_an_lag5 rain_trmm_an_lag6
global lst_day_an lst_day_an lst_day_an_lag1 lst_day_an_lag2 lst_day_an_lag3 lst_day_an_lag4 lst_day_an_lag5 lst_day_an_lag6 
global lst_night_an lst_night_an lst_night_an_lag1 lst_night_an_lag2 lst_night_an_lag3 lst_night_an_lag4 lst_night_an_lag5 lst_night_an_lag6

/* normal w. interaction */
global rain_trmm_cz rain_trmm_cz rain_trmm_cz_lag1 rain_trmm_cz_lag2 rain_trmm_cz_lag3 rain_trmm_cz_lag4 rain_trmm_cz_lag5 rain_trmm_cz_lag6
global lst_day_cz lst_day_cz lst_day_cz_lag1 lst_day_cz_lag2 lst_day_cz_lag3 lst_day_cz_lag4 lst_day_cz_lag5 lst_day_cz_lag6
global lst_night_cz lst_night_cz lst_night_cz_lag1 lst_night_cz_lag2 lst_night_cz_lag3 lst_night_cz_lag4 lst_night_cz_lag5 lst_night_cz_lag6

/*anomaly w. interaction*/
global rain_trmm_an_cz rain_trmm_an_cz rain_trmm_an_cz_lag1 rain_trmm_an_cz_lag2 rain_trmm_an_cz_lag3 rain_trmm_an_cz_lag4 rain_trmm_an_cz_lag5 rain_trmm_an_cz_lag6
global lst_day_an_cz lst_day_an_cz lst_day_an_cz_lag1 lst_day_an_cz_lag2 lst_day_an_cz_lag3 lst_day_an_cz_lag4 lst_day_an_cz_lag5 lst_day_an_cz_lag6
global lst_night_an_cz lst_night_an_cz lst_night_an_cz_lag1 lst_night_an_cz_lag2 lst_night_an_cz_lag3 lst_night_an_cz_lag4 lst_night_an_cz_lag5 lst_night_an_cz_lag6

 /* monthly interactions */
global rain_trmm_month rain_trmm_month rain_trmm_month_lag1 rain_trmm_month_lag2 rain_trmm_month_lag3 rain_trmm_month_lag4 rain_trmm_month_lag5 rain_trmm_month_lag6
global lst_day_month lst_day_month lst_day_month_lag1 lst_day_month_lag2 lst_day_month_lag3 lst_day_month_lag4 lst_day_month_lag5 lst_day_month_lag6
global lst_night_month lst_night_month lst_night_month_lag1 lst_night_month_lag2 lst_night_month_lag3 lst_night_month_lag4 lst_night_month_lag5 lst_night_month_lag6
 
global rain_trmm_m_cz rain_trmm_m_cz rain_trmm_m_cz_lag1 rain_trmm_m_cz_lag2 rain_trmm_m_cz_lag3 rain_trmm_m_cz_lag4 rain_trmm_m_cz_lag5 rain_trmm_m_cz_lag6
global lst_day_m_cz lst_day_m_cz lst_day_m_cz_lag1 lst_day_m_cz_lag2 lst_day_m_cz_lag3 lst_day_m_cz_lag4 lst_day_m_cz_lag5 lst_day_m_cz_lag6
global lst_night_m_cz lst_night_m_cz lst_night_m_cz_lag1 lst_night_m_cz_lag2 lst_night_m_cz_lag3 lst_night_m_cz_lag4 lst_night_m_cz_lag5 lst_night_m_cz_lag6
 
global rain_trmm_an_m rain_trmm_an_m rain_trmm_an_m_lag1 rain_trmm_an_m_lag2 rain_trmm_an_m_lag3 rain_trmm_an_m_lag4 rain_trmm_an_m_lag5 rain_trmm_an_m_lag6
global lst_day_an_m lst_day_an_m lst_day_an_m_lag1 lst_day_an_m_lag2 lst_day_an_m_lag3 lst_day_an_m_lag4 lst_day_an_m_lag5 lst_day_an_m_lag6
global lst_night_an_m lst_night_an_m lst_night_an_m_lag1 lst_night_an_m_lag2 lst_night_an_m_lag3 lst_night_an_m_lag4 lst_night_an_m_lag5 lst_night_an_m_lag6

global rain_trmm_an_m_cz rain_trmm_an_m_cz rain_trmm_an_m_cz_lag1 rain_trmm_an_m_cz_lag2 rain_trmm_an_m_cz_lag3 rain_trmm_an_m_cz_lag4 rain_trmm_an_m_cz_lag5 rain_trmm_an_m_cz_lag6
global lst_day_an_m_cz lst_day_an_m_cz lst_day_an_m_cz_lag1 lst_day_an_m_cz_lag2 lst_day_an_m_cz_lag3 lst_day_an_m_cz_lag4 lst_day_an_m_cz_lag5 lst_day_an_m_cz_lag6
global lst_night_an_m_cz lst_night_an_m_cz lst_night_an_m_cz_lag1 lst_night_an_m_cz_lag2 lst_night_an_m_cz_lag3 lst_night_an_m_cz_lag4 lst_night_an_m_cz_lag5 lst_night_an_m_cz_lag6
 
foreach v in ndvi_an $rain_trmm_an_cz $lst_day_an_cz $lst_night_an_cz $rain_trmm_an $lst_day_an $lst_night_an $rain_trmm ndvi_an $lst_day $lst_night {
drop if missing(`v')
}

/* check if still any missing variables */
mdesc
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Random_forest\RF_testdata.dta", replace

clear all
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Random_forest"
use RF_testdata.dta


/* normal */
global rain_trmm rain_trmm rain_trmm_lag1 rain_trmm_lag2 rain_trmm_lag3 rain_trmm_lag4 rain_trmm_lag5 rain_trmm_lag6 
global lst_day lst_day lst_day_lag1 lst_day_lag2 lst_day_lag3 lst_day_lag4 lst_day_lag5 lst_day_lag6 
global lst_night lst_night lst_night_lag1 lst_night_lag2 lst_night_lag3 lst_night_lag4 lst_night_lag5 lst_night_lag6
 
/* anomalies */
global rain_trmm_an rain_trmm_an rain_trmm_an_lag1 rain_trmm_an_lag2 rain_trmm_an_lag3 rain_trmm_an_lag4 rain_trmm_an_lag5 rain_trmm_an_lag6
global lst_day_an lst_day_an lst_day_an_lag1 lst_day_an_lag2 lst_day_an_lag3 lst_day_an_lag4 lst_day_an_lag5 lst_day_an_lag6 
global lst_night_an lst_night_an lst_night_an_lag1 lst_night_an_lag2 lst_night_an_lag3 lst_night_an_lag4 lst_night_an_lag5 lst_night_an_lag6

/*anomaly w. interaction*/
global rain_trmm_an_cz rain_trmm_an_cz rain_trmm_an_cz_lag1 rain_trmm_an_cz_lag2 rain_trmm_an_cz_lag3 rain_trmm_an_cz_lag4 rain_trmm_an_cz_lag5 rain_trmm_an_cz_lag6
global lst_day_an_cz lst_day_an_cz lst_day_an_cz_lag1 lst_day_an_cz_lag2 lst_day_an_cz_lag3 lst_day_an_cz_lag4 lst_day_an_cz_lag5 lst_day_an_cz_lag6
global lst_night_an_cz lst_night_an_cz lst_night_an_cz_lag1 lst_night_an_cz_lag2 lst_night_an_cz_lag3 lst_night_an_cz_lag4 lst_night_an_cz_lag5 lst_night_an_cz_lag6

global rain_trmm_an_m rain_trmm_an_m rain_trmm_an_m_lag1 rain_trmm_an_m_lag2 rain_trmm_an_m_lag3 rain_trmm_an_m_lag4 rain_trmm_an_m_lag5 rain_trmm_an_m_lag6
global lst_day_an_m lst_day_an_m lst_day_an_m_lag1 lst_day_an_m_lag2 lst_day_an_m_lag3 lst_day_an_m_lag4 lst_day_an_m_lag5 lst_day_an_m_lag6
global lst_night_an_m lst_night_an_m lst_night_an_m_lag1 lst_night_an_m_lag2 lst_night_an_m_lag3 lst_night_an_m_lag4 lst_night_an_m_lag5 lst_night_an_m_lag6

global rain_trmm_an_m_cz rain_trmm_an_m_cz 
global lst_day_an_m_cz lst_day_an_m_cz 
global lst_night_an_m_cz lst_night_an_m_cz 
 
mdesc
 

outsheet ndvi_an year rain_trmm_an_m lst_day_an_m lst_night_an_m rain_trmm_an_m_cz lst_day_an_m_cz lst_night_an_m_cz ///
using RF_dataset3_test.csv, comma
 
/* convert to .csv */
outsheet ndvi_an year $rain_trmm $lst_day $lst_night $rain_trmm_an $lst_day_an $lst_night_an $rain_trmm_an_cz $lst_day_an_cz $lst_night_an_cz ///
$rain_trmm_an_m $lst_day_an_m $lst_night_an_m $rain_trmm_an_m_cz $lst_day_an_m_cz $lst_night_an_m_cz ///
using RF_dataset3_sample.csv, comma

*******************************************************************************

/* convert back from CSV after RF estimation */
clear all 
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"

import delimited "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\predicted_greenness_rf3.csv"

/* make ready for match w. greenness */
rename scoredlabelmean ndvi_hat_an_rf
rename scoredlabelstandarddeviation ndvi_rf_std

gen match = _n

keep match ndvi_an ndvi_hat_an_rf ndvi_rf_std

sa "predicted_greenness_rf.dta", replace

 *******************************************************************************
 ************************Matching w original dataset ****************************
 
 /* drop if ndvi_an is missing */
clear all
use "$path\predicted_greenness.dta"

/* drop all missing variables in order to match w RF-data */

keep id lon lat climate_zones year month time ndvi_an ndvi ndvi_hat_cz ndvi_hat_an

/* gen match parameter */
gen match = _n

/* merge w. RF estimates */
merge 1:1 match using "$path\predicted_greenness_rf.dta", nogen
drop match

sa "$path\predicted_greenness_final.dta", replace


