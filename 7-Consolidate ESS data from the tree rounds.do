********************************************************************************
* Merges ESS-data at EA-level and then estimates monthly weather indicators    *
* as the inverse-distance weighted avg. of the 4 surrounding satellite         *
* observations using a 0.05 degree grid.                                       *
* Albert Nygård, May 2018                                                      *
********************************************************************************

/* First I merge ESS-data on EA-level */

clear all
set more off

global path "C:\Users\Albert\Documents\Polit\Speciale_local\Data\"
use "$path\ESS\ESS_allrounds.dta"


replace year = 2014 if year==2015

order ea_id year month
sort ea_id year month

/* Define land classes. Reference: Sparse vegetation and bare areas */
by ea_id year: gen d_cropland_hh = 0
by ea_id year: replace d_cropland_hh = 1 if land_class == 14 | land_class==20
by ea_id year: egen d_cropland = total(d_cropland_hh)

by ea_id year: gen d_mosaic_vegetation_hh = 0
by ea_id year: replace d_mosaic_vegetation_hh = 1 if land_class == 30
by ea_id year: egen d_mosaic_vegetation = total(d_mosaic_vegetation_hh)


by ea_id year: gen d_high_forest_hh = 0
by ea_id year: replace d_high_forest_hh = 1 if land_class == 40 | land_class == 50 | land_class == 60 | land_class == 90
by ea_id year: egen d_high_forest = total(d_high_forest_hh)


by ea_id year: gen d_shrub_grassland_hh = 0
by ea_id year: replace d_shrub_grassland_hh = 1 if land_class == 110 | land_class == 120 | land_class == 130 | land_class == 140
by ea_id year: egen d_shrub_grassland= total(d_shrub_grassland_hh)

by ea_id year: gen d_wetlands_hh = 0
by ea_id year: replace d_wetlands_hh = 1 if land_class == 160 | land_class == 180
by ea_id year: egen d_wetlands = total(d_wetlands_hh)

by ea_id year: gen d_artificial_hh = 0
by ea_id year: replace d_artificial_hh = 1 if land_class == 190
by ea_id year: egen d_artificial = total(d_artificial_hh)


/* MAKE A EA CONSOLIDATED MEASURE OF MONTHS FOOD INSECURE */

drop d_cropland_hh
drop d_mosaic_vegetation_hh
drop d_high_forest_hh
drop d_shrub_grassland_hh
drop d_wetlands_hh
drop d_artificial_hh

/* creating EA_dummy variable if category is identified by more than four 
households (arbitrarily picked) */

by ea_id year: replace d_cropland = 0 if d_cropland < 3
by ea_id year: replace d_cropland = 1 if d_cropland > 3

by ea_id year: replace d_mosaic_vegetation = 0 if d_mosaic_vegetation < 3
by ea_id year: replace d_mosaic_vegetation = 1 if d_mosaic_vegetation > 3

by ea_id year: replace d_high_forest = 0 if d_high_forest < 3
by ea_id year: replace d_high_forest = 1 if d_high_forest > 3

by ea_id year: replace d_shrub_grassland = 0 if d_shrub_grassland < 3
by ea_id year: replace d_shrub_grassland = 1 if d_shrub_grassland > 3

by ea_id year: replace d_wetlands = 0 if d_wetlands < 3
by ea_id year: replace d_wetlands = 1 if d_wetlands > 3

by ea_id year: replace d_artificial = 0 if d_artificial < 3
by ea_id year: replace d_artificial = 1 if d_artificial > 3

/* replace woreda_dummy with correct value */
by ea_id year: replace woreda_office = 0 if woreda_office ==2

/* create dummy for workability constraints */
by ea_id year: replace workability_constraints = 0 if workability_constraints < 3
by ea_id year: replace workability_constraints=1 if workability_constraints > 2

/* creating kebele dummy taking the value of 1 if 4 or more households
reported severe constraints towards field management */
by ea_id year: egen hh_workability_constraints = total(workability_constraints)
by ea_id year: replace hh_workability_constraints = 0 if hh_workability_constraints < 4
by ea_id year: replace hh_workability_constraints = 1 if hh_workability_constraints > 3

drop workability_constraints
rename hh_workability_constraints field_mgmt_constraints
label var field_mgmt_constraints "HH's in kebele reported severe or very severe constraints for field management"

/*
replace */

/* Aggregate at EA-level */

by ea_id year: egen advisory = total(advisory_service)
label var advisory "share of kebeles that had agricultural advisory service"

by ea_id year: egen other_shock = total(hh_other_shock)

by ea_id year: egen total_plots = total(total_hh_plots)
label var total_plots "total number of plots among surveyed HH's"

by ea_id year: egen avg_share_agr = mean(share_agr_km)
label var avg_share_agr "average percent agriculture in ea"

by ea_id year: egen avg_dist_plot = mean(avg_dist_household)
label var avg_dist_plot "average km distance to hh plot(s) in ea"

by ea_id year: egen  sqm_land = total(tot_hh_land)
label var sqm_land "total sqm land among surveyed HH's in ea"

by ea_id year: egen sqm_ext_prog = total(hh_extension_prog)
label var sqm_ext_prog "total sqm land in extension program among surveyed hh in ea"

by ea_id year: egen sqm_irrigation = total(hh_irrigation)
label var sqm_irrigation "total sqm land irrigated among surveyed hh in ea"

by ea_id year: gen share_irrigated = sqm_irrigation / sqm_land

by ea_id year: egen sqm_fertilizer = total(hh_fertilizer_use)
label var hh_fertilizer_use "total sqm land fertilized among surveyed hh in ea"

by ea_id year: gen share_fertilized = sqm_fertilizer / sqm_land

by ea_id year: egen PSNP_participants = total(PSNP_last_year)
label var PSNP_participants "number PSNP participants in ea within last year"

by ea_id year: egen PSNP_days = total(days_PSNP)
label var PSNP_days "number of days worked in PSNP in ea within last year"

by ea_id year: egen PSNP_payment = total(payment_PSNP)
label var payment_PSNP "total payment for PSNP in ea within last year"

by ea_id year: egen little_rain = total(too_little_rain)
label var little_rain "number of HH reported damage due to too little rain in last harvest within ea"

by ea_id year: egen seed_total = total(seed_used)
label var seed_total "Total KG seed used last planting season"

by ea_id year: gen seed_kg_sqm = seed_total / sqm_land

by ea_id year: egen food_insecure_week = total(food_insecure_7d)
label var food_insecure_week "nr hh reported food insecurity within last week within ea"

by ea_id year: egen food_insecure_yr = total(food_insecure_year)
label var food_insecure_yr "nr hh reported food insecurity within last year within ea"

by ea_id year: egen land_dmg_drought = total(hh_land_dmg_drought)
label var land_dmg_drought "sqm land reported damaged due to drought last year"

by ea_id year: gen share_land_dmg_drought = land_dmg_drought / sqm_land

drop rec_PSNP

by ea_id year: egen other_assistance = total(rec_other_assist)
label var other_assistance "nr hh reported recieving other assistance than PSNP within last year"

by ea_id year: egen adult_eq = total(adulteq)
label var adult_eq "total adult equivalant amoun surveyed hh in ea"

by ea_id year: egen hhsize = total(hh_size)
label var hhsize  "total hh size among surveyed hh's"

by ea_id year: egen food_consumption_aeq = mean(food_cons_aeq)
label var food_consumption "Real annual value of food consumption (selected) per adult eq"

by ea_id year: egen nonfood_consumption_aeq = mean(nonfood_cons_aeq)
label var food_consumption "Real annual value of nonfood consumption per adult eq"

by ea_id year: egen educ_consumption_aeq = mean(educ_cons_aeq)
label var food_consumption "Real annual value of consumption on education per adult eq"

by ea_id year: egen cons_quintile = mean(cons_quint)
label var cons_quintile "average consumption quintile among hh adult eq in surveyed hh's"

by ea_id year: egen educated = total(high_education)
label var educated "number of respondents in ea who has completed 7'th grade or above"

drop share_agr_km avg_dist_household tot_hh_land hh_extension_prog hh_irrigation ///
hh_fertilizer_use PSNP_last_year days_PSNP payment_PSNP too_little_rain seed_used ///
food_insecure_7d food_insecure_year hh_land_dmg_drought rec_other_assist adulteq hh_size ///
food_cons_ann nonfood_cons_ann educ_cons_ann total_cons_ann nom_totcons_aeq cons_quint high_education ///
child_neat_cloth adult_neat_cloth avg_dist_plot total_hh_plots hh_other_shock advisory_service

/* dropping surplus and missing observations */
quietly by ea_id year: gen dup = cond(_N==1,0,_n)
by ea_id year: egen hh_respondents = max(dup)
replace hh_respondents=1 if hh_respondents==0
drop if dup > 1
drop dup
label var hh_respondents "number of households surveyed"

bysort ea_id year: gen share_hh_educated = educated/hh_respondents
label var share_hh_educated "share of households with at least 1 member who finished 7th grade or above"

bysort ea_id year: gen share_little_rain = little_rain/hh_respondents
bysort ea_id year: gen share_food_insecure_yr = food_insecure_yr / hh_respondents
bysort ea_id year: gen share_other_assistance = other_assistance / hh_respondents
bysort ea_id year: gen share_advisory = advisory / hh_respondents
bysort ea_id year: gen share_other_shock = other_shock / hh_respondents
bysort ea_id year: gen avg_plotsize = sqm_land / total_plots
label var avg_plotsize "average plot size (sqm)"

drop household_id household_id2 ea_id2
drop if missing(ea_id)
drop if missing(pw) & missing(pw2) & missing(pw_w3)

/* dropping non-rural households */
drop if rural >2

sa "$path\Stata_in\ESS_cleaned.dta", replace
