********************************************************************************
* Analysis - matching with discrete and continuous treatment                   *
* Albert Nygård, July 2018                                                     *
********************************************************************************

clear all
set more off

cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"
use "ESS_gps_weather_analysis.dta"


********************************************************************************
****************** T-tests *****************************************************



ttest mean_diff_2015==0 if PSNP_acc_2016==1 & year==2012
ttest mean_diff_2015==0 if PSNP_acc_2016==0 & year==2012
ttest mean_diff_2016==0 if PSNP_acc_2016==1 & year==2012
ttest mean_diff_2016==0 if PSNP_acc_2016==0 & year==2012

gen ndvi_avg_2016 = (ndvi2016_8 + ndvi2016_9 + ndvi2016_10)/3
summarize ndvi_avg_2016 if year==2012 & PSNP_acc_2016==1


********************************************************************************
****************** FE regressions *****************************************************


/* FE regressions */

global demographic nr_households_kebele avg_head_age
global socioeconomic sh_insec food_con nonfood_con share_hh_educated
global agricultural avg_share_agr field_const d_needs d_sparse
global geographical avg_ndvi2011
global drought drought2008 drought2009 drought2010
global land_use d_squatter d_farming d_pasture d_plannedhousing d_shops d_other
global region d_tigray d_afar d_amhara d_oromia d_somalie d_snnp d_harari d_direwa


reg mean_diff_2015 PSNP_acc_2016 i.d_zone if year==2012
reg mean_diff_2016 PSNP_acc_2016 i.d_zone if year==2012

/* propensity score matching */
clear all 
use "ESS_gps_weather_analysis.dta"
set seed 123

keep if year==2012

drop if mindistance < 15 & PSNP_acc_2016==0 & is_neighbor_treated==1

global demographic nr_households_kebele avg_head_age
global socioeconomic share_hh_educated
global agricultural avg_share_agr field_const d_needs d_sparse
global geographical avg_ndvi2011
global drought drought2008 drought2009 drought2010 share_other_shock
global land_use d_squatter d_farming d_pasture d_plannedhousing d_shops d_other
global region d_tigray d_afar d_amhara d_oromia d_somalie d_snnp d_harari d_direwa


bootstrap r(att), reps(100): psmatch2 PSNP_acc_2016 $demographic $socioeconomic $agricultural ///
$drought $geographical i.region if year==2012, kernel out(mean_diff_2016) common bwidth(0.06)



/* see logit model */
psmatch2 PSNP_acc_2016 $demographic $socioeconomic $agricultural ///
$drought $geographical i.region if year==2012, out(mean_diff_2015) kernel common

pstest $demographic $socioeconomic $agricultural ///
$drought $geographical i.region if year==2012, hist

/* graph */

* before
twoway (kdensity _pscore if _treated==1) (kdensity _pscore if _treated==0, ///
lpattern(dash)), legend( label( 1 "treated") label( 2 "control" ) ) ///
xtitle("propensity scores before kernel-matching") name(before, replace)

* after
twoway (kdensity _pscore if _treated==1 [aweight=_weight]) ///
(kdensity _pscore if _treated==0 [aweight=_weight] ///
, lpattern(dash)), legend( label( 1 "treated") label( 2 "control" )) ///
xtitle("propensity scores after kernel-matching") name(after, replace)

* combined
grc1leg before after, ycommon

twoway (kdensity _pscore if _treated==1 [aweight=_weight]) ///
(kdensity _pscore if _treated==0 [aweight=_weight] ///
, lpattern(dash)), legend( label( 1 "treated") label( 2 "control" )) ///
xtitle("propensity scores AFTER matching") name(after, replace)


label var region "region"
/* 2015 */

foreach h in 0.03 0.06 0.12 {
bootstrap r(att), reps(100): psmatch2 PSNP_acc_2016 $demographic $socioeconomic $agricultural ///
$drought $geographical i.region if year==2012, kernel out(mean_diff_2015) common bwidth(`h')
}

/* 2016 */
foreach h in 0.03 0.06 0.12 {
bootstrap r(att), reps(100): psmatch2 PSNP_acc_2016 $demographic $socioeconomic $agricultural ///
$drought $geographical i.region if year==2012, kernel out(mean_diff_2016) common bwidth(`h')
}

********************************************************************************
*****************/* dose response */********************************************

clear all 
use "ESS_gps_weather_analysis.dta"
set seed 123

global demographic nr_households_kebele avg_head_age
global socioeconomic share_hh_educated
global agricultural avg_share_agr field_const d_needs d_sparse
global geographical avg_ndvi2011
global drought drought2008 drought2009 drought2010 share_other_shock
global land_use d_squatter d_farming d_pasture d_plannedhousing d_shops d_other
global region d_tigray d_afar d_amhara d_oromia d_somalie d_snnp d_harari d_direwa


bysort ea_id: egen tot_PSNP_days = total(PSNP_days)

gen cut2=350
replace cut2 = 1000 if tot_PSNP_days>350
replace cut2= 4500 if tot_PSNP_days>1000

keep if  year==2012
keep if tot_PSNP_days>0


matrix define tp = (50\100\200\300\400\500\600\700\800\900\1000\1100\1200\1300\1400\1500\1600\1700\1800\1900\2000\2100\2200\2300\2400\2500\2600\2700\2800\2900\3000)


/* dose-response full model */
foreach `y' in 2015 2016 {
doseresponse $demographic $socioeconomic $agricultural $drought $geographical ///
$region, outcome(mean_diff_`y') t(tot_PSNP_days) gpscore(gps) predict(fitted) ///
sigma(ML_std) cutpoints(cut2) index(mean) nq_gps(5) dose_response(drmodel) ///
 delta(1) tpoints(tp) bootstrap(yes) boot_reps(100) reg_type_t(linear) ///
 reg_type_gps(linear) t_transf(ln) analysis(yes) graph("graph_output") detail
}
********************************************************************************
********************************************************************************
/* considering the timing */

clear all 
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"

use "ESS_gps_weather_analysis.dta"
set seed 123

global demographic nr_households_kebele avg_head_age
global socioeconomic share_hh_educated
global agricultural avg_share_agr field_const d_needs d_sparse
global geographical avg_ndvi2011
global drought drought2008 drought2009 drought2010 share_other_shock
global land_use d_squatter d_farming d_pasture d_plannedhousing d_shops d_other
global region d_tigray d_afar d_amhara d_oromia d_somalie d_snnp d_harari d_direwa

gen t_weight_2012 = 2
gen t_weight_2014 = 1
gen t_weight_2016 = 0.4

gen a_weight = 1
replace a_weight = 1.2 if PSNP_2012==1 & PSNP_2014==1 & PSNP_2016==1
replace a_weight = 0.2 if PSNP_2012==1 & PSNP_2014==0 & PSNP_2016==0
replace a_weight = 0.8 if PSNP_2012==0 & PSNP_2014==1 & PSNP_2016==0

keep if year==2012


gen tot_PSNP_days = PSNP_days_2012 + PSNP_days_2014 + PSNP_days_2016
gen PSNP_days_weighted = PSNP_days_2012*t_weight_2012 + PSNP_days_2014*t_weight_2014 + PSNP_days_2016*t_weight_2016

/* checking for heterogeneity of treatment effect */
sort tot_PSNP_days 
keep if tot_PSNP_days>0
gen quartile = 0
replace quartile = 0.25 if tot_PSNP_days> 211
replace quartile = 0.5 if tot_PSNP_days> 463
replace quartile = 0.75 if tot_PSNP_days> 990
drop if  tot_PSNP_days==0

sort PSNP_days_weighted
gen w_quartile = 0
replace w_quartile = 0.25 if PSNP_days_weighted > 242
replace w_quartile = 0.50 if PSNP_days_weighted > 654
replace w_quartile = 0.75 if PSNP_days_weighted > 1321

count if w_quartile != quartile

gen weighted_treatment = PSNP_days_weighted*a_weight

drop if weighted_treatment==0

gen cut2=400
replace cut2 = 1500 if weighted_treatment>400
replace cut2= 8000 if weighted_treatment>1500

matrix define tp = (50\100\200\300\400\500\600\700\800\900\1000\1100\1200\1300\1400\1500\1600\1700\1800\1900\2000\2100\2200\2300\2400\2500\2600\2700\2800\2900\3000\3100\3200\3300\3400\3500\3600\3700\3800\3900\4000)


/* dose-response full model */
foreach y in 2015 2016 {
doseresponse $demographic $socioeconomic $agricultural $drought $geographical ///
$region, outcome(mean_diff_`y') t(weighted_treatment) gpscore(gps) predict(fitted) ///
sigma(ML_std) cutpoints(cut2) index(mean) nq_gps(5) dose_response(drmodel) ///
 delta(1) tpoints(tp) bootstrap(yes) boot_reps(100) reg_type_t(quadratic) ///
 reg_type_gps(quadratic) t_transf(ln) analysis(yes) graph("graph_output") detail

}

********************************************************************************
********************** WEIGHTING BY PAYMENTS ***********************************
clear all 
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"

use "ESS_gps_weather_analysis.dta"
set seed 123

global demographic nr_households_kebele avg_head_age
global socioeconomic share_hh_educated
global agricultural avg_share_agr field_const d_needs d_sparse
global geographical avg_ndvi2011
global drought drought2008 drought2009 drought2010 share_other_shock
global land_use d_squatter d_farming d_pasture d_plannedhousing d_shops d_other
global region d_tigray d_afar d_amhara d_oromia d_somalie d_snnp d_harari d_direwa


gen avg_payment = PSNP_payment / PSNP_days
gen geoadjusted_payment = avg_payment / price_index_hce

gen cpi = 1
replace cpi = 1.54014 if year == 2012
replace cpi = 0.861331 if year == 2016

gen real_daily_wage = geoadjusted_payment*cpi

foreach y in 2012 2014 2016 { 
gen t_real_wage_`y' = 0
replace t_real_wage_`y' = real_daily_wage if year==`y'
bysort ea_id: egen real_wage_`y' = total(t_real_wage_`y')
drop t_real_wage_`y'
}

bysort ea_id: egen tot_PSNP_days = total(PSNP_days)
keep if year==2012
keep if tot_PSNP_days>0

count if real_wage_2012<10 | real_wage_2014<10 | real_wage_2016<10 

foreach y in 2012 2014 2016 {
gen weight_`y' = 1
replace weight_`y' = 0.3 if real_wage_`y'<10
}

gen weighted_treatment_wage = PSNP_days_2012*weight_2012 + PSNP_days_2014*weight_2014 + PSNP_days_2016*weight_2016

/* checking for heterogeneity */

sort tot_PSNP_days 
keep if tot_PSNP_days>0
gen quartile = 0
replace quartile = 0.25 if tot_PSNP_days> 211
replace quartile = 0.5 if tot_PSNP_days> 463
replace quartile = 0.75 if tot_PSNP_days> 990

sort weighted_treatment_wage
gen w_quartile = 0
replace w_quartile = 0.25 if weighted_treatment_wage > 205
replace w_quartile = 0.50 if weighted_treatment_wage > 420
replace w_quartile = 0.75 if weighted_treatment_wage > 877

count if w_quartile != quartile


gen cut2=400
replace cut2 = 1000 if weighted_treatment_wage>400
replace cut2= 3500 if weighted_treatment_wage>1000


matrix define tp = (50\100\200\300\400\500\600\700\800\900\1000\1100\1200\1300\1400\1500\1600\1700\1800\1900\2000\2100\2200\2300\2400\2500\2600\2700\2800\2900\3000)

/* dose-response full model */
foreach y in 2015 2016 {
doseresponse $demographic $socioeconomic $agricultural $drought $geographical ///
$region, outcome(mean_diff_`y') t(weighted_treatment_wage) gpscore(gps) predict(fitted) ///
sigma(ML_std) cutpoints(cut2) index(mean) nq_gps(5) dose_response(drmodel) ///
 delta(1) tpoints(tp) bootstrap(yes) boot_reps(100) reg_type_t(quadratic) ///
 reg_type_gps(quadratic) t_transf(ln) analysis(yes) graph("graph_output") detail
}
 
hist weighted_treatment_wage

matrix define tp = (50\500\1000\1500\2000\2500\3000)

gen diff = weighted_treatment_wage - tot_PSNP_days 
hist diff
********************************************************************************
********************************************************************************
/* Checking spatial effects */

clear all 
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"

use "ESS_gps_weather_analysis.dta"

keep if year==2012

/* checking within 5 kilometers */
count if mindistance < 4 & PSNP_acc_2016==0 & is_neighbor_treated==1

/* checking within 15 kilometers */
count if mindistance < 15 & PSNP_acc_2016==0 & is_neighbor_treated==1
