/*
Description: This do-file create ESS dataset with relevant variables 
for later merge with predicted-greenness variables matching temporaly and 
spatially. 
Used survey: ESS wave 3
*/

clear all
set more off

global path "C:\Users\Albert\Documents\Polit\Speciale_local\Data\ESS\ESS3"


** Area unit conversion **
clear all
use "$path\ET_local_area_unit_conversion"

rename zone zone_code
rename woreda woreda_code

save "$path\Relevant data\local_area_conversion.dta", replace

** Area names ** 
clear all
use "$path\ET_local_area_unit_conversion"

rename zone zone_code
rename woreda woreda_code

drop local_unit conversion

sort region zone_code woreda_code
quietly by region zone_code woreda_code: gen dup = cond(_N==1,0,_n)

drop if dup>1
drop dup


save "$path\Relevant data\local_area_names.dta", replace

** Household geovariables **
clear all
use "$path\ETH_HouseholdGeovars_y3.dta"

keep household_id2 ea_id2 sq7 fsrad3_agpct fsrad3_lcmaj ///
lat_dd_mod lon_dd_mod

rename fsrad3_agpct share_agr_km
rename fsrad3_lcmaj land_class
rename sq7 workability_constraints

save "$path\Relevant data\hh_geovariables.dta", replace

** ETH_PlotGeovariables **
clear all
use "$path\ETH_PlotGeovariables_Y3.dta"

keep household_id household_id2 parcel_id field_id dist_household plot_twi

*Create household averages*

bysort household_id2: egen avg_dist_household = mean(dist_household)
bysort household_id2: egen avg_plot_twi = mean(plot_twi)

label var avg_dist_household "average distance (KM) to plot(s)"
label var avg_plot_twi "average plot potential wetness index"

keep household_id2 avg_dist_household avg_plot_twi

by household_id2: gen dup=_n
keep if dup==1
drop dup

save "$path\Relevant data\plot_geovariables.dta", replace

** sect_cover_hh **
clear all
use "$path\sect_cover_hh_w3.dta"

keep household_id2 rural pw saq01 saq02 saq03 saq06 saq07 hh_saq13_a hh_saq13_b ///
hh_saq13_c

rename saq01 region
rename saq02 zone_code
rename saq03 woreda_code
rename saq06 kebele_code
rename saq07 ea_in_kebele_code

/* conversion of time
in Ethiopian calendar, 1 May 2008 is 10 Jan 2016, and 23 May 2008 is 1 Feb 2016
in the Gregorian calendar. Link to converter.
https://www.funaba.org/cc */

gen year_greg = 2016
replace year_greg = 2015 if hh_saq13_a<22 & hh_saq13_b<5 & hh_saq13_c==2008

gen month_greg = 1
replace month_greg = 2 if hh_saq13_a>22 & hh_saq13_b==5
replace month_greg = 2 if hh_saq13_a<=21 & hh_saq13_b==6

replace month_greg = 3 if hh_saq13_a>21 & hh_saq13_b==6
replace month_greg = 3 if hh_saq13_a<=22 & hh_saq13_b==7

replace month_greg = 4 if hh_saq13_a>22 & hh_saq13_b==7
replace month_greg = 4 if hh_saq13_a<=22 & hh_saq13_b==8

replace month_greg = 5 if hh_saq13_a>22 & hh_saq13_b==8
replace month_greg = 5 if hh_saq13_a<=23 & hh_saq13_b==9

replace month_greg = 6 if hh_saq13_a>23 & hh_saq13_b==9
replace month_greg = 6 if hh_saq13_a<=23 & hh_saq13_b==10

replace month_greg = 7 if hh_saq13_a>23 & hh_saq13_b==10
replace month_greg = 7 if hh_saq13_a<=24 & hh_saq13_b==11

replace month_greg = 8 if hh_saq13_a>24 & hh_saq13_b==11
replace month_greg = 8 if hh_saq13_a<=25 & hh_saq13_b==12

replace month_greg = 9 if hh_saq13_a>25 & hh_saq13_b==12
replace month_greg = 9 if hh_saq13_a<=20 & hh_saq13_b==1

replace month_greg = 10 if hh_saq13_a>20 & hh_saq13_b==1
replace month_greg = 10 if hh_saq13_a<=21 & hh_saq13_b==2

replace month_greg = 11 if hh_saq13_a>21 & hh_saq13_b==2
replace month_greg = 11 if hh_saq13_a<=21 & hh_saq13_b==3

replace month_greg = 12 if hh_saq13_a>21 & hh_saq13_b==3
replace month_greg = 12 if hh_saq13_a<=22 & hh_saq13_b==4

drop hh_saq13_a hh_saq13_b hh_saq13_c

rename year_greg year
rename month_greg month

save "$path\Relevant data\sect_cover_hh_w3.dta", replace



** sect01b_com_w3
clear all
use "$path\sect01b_com_w3.dta"

keep ea_id ea_id2 cs2aq01 cs2aq02 cs2aq03 cs2aq04 cs2aq08

rename cs2aq01 child_neat_cloth
rename cs2aq02 child_shoes
rename cs2aq03 adult_neat_cloth
rename cs2aq04 adult_shoes
rename cs2aq08 woreda_office

keep if !missing(child_neat_cloth)
keep if !missing(child_shoes)
keep if !missing(adult_neat_cloth)
keep if !missing(adult_neat_cloth)

replace child_neat_cloth = 0 if child_neat_cloth==2
replace child_shoes = 0 if child_shoes ==2
replace adult_neat_cloth = 0 if adult_neat_cloth==2
replace adult_shoes = 0 if adult_shoes==2

sa "$path\Relevant data\sect01b_com_w3.dta", replace


** sect1_hh_w3 **
clear all
use "$path\sect1_hh_w3.dta" 

keep individual_id ea_id household_id household_id2 hh_s1q02 hh_s1q03 hh_s1q04a

gen head_female = 0
replace head_female =1 if hh_s1q02==1 & hh_s1q03==2
gen head = 0
replace head=1 if hh_s1q02==1
gen head_age = .
replace head_age = hh_s1q04a if hh_s1q02==1

bysort ea_id: egen tot_head_female = total(head_female)
bysort ea_id: egen tot_heads = total(head)
bysort ea_id: egen avg_head_age = mean(head_age)
bysort ea_id: gen share_female = tot_head_female / tot_heads

bysort household_id2: gen dup = _n
drop if dup>1
keep household_id household_id2 ea_id avg_head_age share_female

sa "$path\Relevant data\sect1_hh_w3.dta", replace

** sect2_hh_w3 **

clear all
use "$path\sect2_hh_w3.dta"

keep individual_id2 household_id household_id2 hh_s2q05

keep if !missing(hh_s2q05)

gen education=0
replace education=1 if hh_s2q05>6 & hh_s2q05<36

egen high_education = total(education), by(household_id2)

keep household_id household_id2 high_education

bysort household_id2: gen dup=_n
keep if dup==1
drop dup

label var high_education "member in HH have completed grade 7 or above"
replace high_education=1 if high_education>0

sa "$path\Relevant data\sect2_hh_w3.dta", replace

**  sect03_com_w3 **
clear all
use "$path\sect03_com_w3.dta"

keep ea_id ea_id2 cs3q03 cs3q07 cs3q10 scsq11 cs3q09

rename cs3q03 nr_households_kebele
rename cs3q07 common_land_use
rename cs3q09 share_bush
rename cs3q10 share_large_farms
rename scsq11 share_forest

sa "$path\Relevant data\sect03_com_w3.dta", replace

** sec3_pp_w3 **
clear all
use "$path\sect3_pp_w3.dta"

keep household_id household_id2 saq01 saq02 saq03 parcel_id field_id pp_s3q02_c pp_s3q02_a ///
pp_s3q14 pp_s3q11 pp_s3q12 pp_s3q32

rename saq01 region
rename saq02 zone_code
rename saq03 woreda_code
rename pp_s3q02_c local_unit

merge m:1 region zone_code woreda_code local_unit using ///
"$path\Relevant data\local_area_conversion.dta", nogen

/* I remove fields that have been measured twice with different units */

sort household_id2 parcel_id field_id
quietly by household_id2 parcel_id field_id: gen dup = cond(_N==1,0,_n)
drop if missing(household_id2)
drop if dup>0 
drop dup

** Create averages for areas with missing "units" **

egen avg_boy = mean(conversion) if local_unit==4
replace avg_boy =. if local_unit==4 & ! missing(conversion)

egen avg_senga = mean(conversion) if local_unit==5
replace avg_senga =. if local_unit==5 & ! missing(conversion)

egen avg_Kert = mean(conversion) if local_unit==6
replace avg_Kert =. if local_unit==6 & ! missing(conversion)

** Create unit for Hectar and sq meters **

replace conversion=10000 if local_unit==1
replace conversion=1 if local_unit==2

** create conversion_modified and calculate total land areas by household**

replace avg_boy = 0 if missing(avg_boy)
replace avg_senga = 0 if missing(avg_senga)
replace avg_Kert = 0 if missing(avg_Kert)
replace conversion = 0 if missing(conversion)

gen conversion_mod = conversion + avg_boy + avg_senga + avg_Kert

gen tot_land_area = pp_s3q02_a * conversion_mod
label var tot_land_area "Total land area (sq m)"

egen tot_hh_land = total(tot_land_area), by(household_id2)

/* The creation of conversion_mod is done to get more observations. Without 
these averages, the average household plot size is 22.363 sqm (2.2 Hectar). 
With averages, the aveage household plot size is 23.717 sqm. Thus, relying on 
extrapolation using averages creates a small upward bias. This is however
assumed to be randomly distributed across all kebeles */

gen extension_program = tot_land_area if pp_s3q11==1
replace extension_program=0 if pp_s3q11==2

gen irrigated = tot_land_area if pp_s3q12==1
replace irrigated = 0 if pp_s3q12==2

gen fertilizer_used = tot_land_area if pp_s3q14==1
replace fertilizer_used = 0 if pp_s3q14==2

by household_id2: gen nr_plots = 1
egen total_hh_plots = total(nr_plots), by(household_id2)
drop nr_plots

egen hh_extension_prog = total(extension_program), by(household_id2)
egen hh_irrigation = total(irrigated), by(household_id2)
egen hh_fertilizer_use = total(fertilizer_used), by(household_id2)

sa "$path\Relevant data\sect3_pp_w3.dta", replace

** only keeping relevant variables, summarized by household **
keep household_id household_id2 total_hh_plots tot_hh_land hh_extension hh_irrigation hh_fertilizer_use

by household_id2: gen dup=_n
keep if dup==1
drop dup
drop if missing(household_id2)

sa "$path\Relevant data\sect3_pp_w3_scraped.dta", replace

** sect4_hh_w3 **
clear all
use "$path\sect4_hh_w3.dta"

keep individual_id individual_id2 household_id household_id2 hh_s4q31 hh_s4q32 hh_s4q33

replace hh_s4q31=0 if hh_s4q31 !=1
keep if !missing(hh_s4q31)

egen PSNP_last_year = total(hh_s4q31), by(household_id2)
label var PSNP_last_year "Individuals in HH worked in PSNP within last 12 months"

egen days_PSNP = total(hh_s4q32), by(household_id2)
label var days_PSNP "Number of days worked in PSNP programme within last 12 months"

egen payment_PSNP = total(hh_s4q33), by(household_id2)
label var payment_PSNP "Income for days worked at PSNP within last 12 months"

keep household_id household_id2 PSNP_last_year days_PSNP payment_PSNP
bysort household_id2: gen dup=_n
keep if dup==1
drop dup

sa "$path\Relevant data\sect4_hh_w3.dta", replace

** sect04_com_w3 **
clear all
use "$path\sect04_com_w3.dta"

keep ea_id ea_id2 cs4q11 cs4q12_a cs4q12_b1 cs4q16

rename cs4q11 urban_center
rename cs4q12_a name_center
rename cs4q12_b1 dist_center
rename cs4q16 phone_access

replace urban_center=0 if urban_center==2
replace phone_access=0 if phone_access==2

sa "$path\Relevant data\sect04_com_w3.dta", replace

** sect4_pp_w3 ** 
clear all
use "$path\sect4_pp_w3.dta"

keep household_id household_id2 pp_s4q09
keep if pp_s4q09==2
gen too_little_rain=1
drop pp_s4q09

label var too_little_rain "HH reported crop damage due to lack of rain"

bysort household_id2: gen dup=_n
keep if dup==1
drop dup

sa "$path\Relevant data\sect4_pp_w3", replace

** sect5_pp_w3 ** 
clear all
use "$path\sect5_pp_w3.dta"

keep household_id household_id2 pp_s5q19_a

egen seed_used = total(pp_s5q19_a), by(household_id2)
label var seed_used "Kilo of seeds used in planting season"

keep household_id household_id2 seed_used

bysort household_id2: gen dup=_n
keep if dup==1
drop dup

sa "$path\Relevant data\sect5_pp_w3", replace


** sect06_com_w2 **

clear all
use "$path\sect06_com_w3.dta"

keep ea_id ea_id2 cs6q03_a cs6q03_b cs6q03_c cs6q04_a cs6q04_b cs6q04_c cs6q08

rename cs6q03_a first_planting_month
rename cs6q03_b second_planting_month
rename cs6q03_c third_planting_month
rename cs6q04_a first_harvest_month
rename cs6q04_b second_harvest_month
rename cs6q04_c third_harvest_month
rename cs6q08 agr_dev_agent

replace agr_dev_agent=0 if agr_dev_agent==2

/* first of September (Ethiopia) is 9 May (Gregorian), meaning that planting month
septempber-november (Ethiopia) is May-Juli (Gregorian). However, since there is
also an overlap of days, I will assume a 4-month season in the analysis, so that
Sep-Nov (ethiopia) may correspond to May-August (Gregorian). */

gen plant_month_1 = first_planting_month + 8
replace plant_month_1 = first_planting_month - 4 if first_planting_month>4 
drop first_planting_month

gen plant_month_2 = second_planting_month + 8
replace plant_month_2 = second_planting_month - 4 if second_planting_month >4 
drop second_planting_month

gen plant_month_3 = third_planting_month + 8
replace plant_month_3= third_planting_month - 4 if third_planting_month >4 
drop third_planting_month 

gen harvest_month_1 = first_harvest_month + 8
replace harvest_month_1 = first_harvest_month - 4 if first_harvest_month >4 
drop first_harvest_month 

gen harvest_month_2 = second_harvest_month + 8
replace harvest_month_2 = second_harvest_month - 4 if second_harvest_month >4 
drop second_harvest_month 

gen harvest_month_3 = third_harvest_month + 8
replace harvest_month_3 = third_harvest_month - 4 if third_harvest_month >4 
drop third_harvest_month 

label var plant_month_1 "major planting/growing month of major crop (1st)"
label var plant_month_2 "major planting/growing month of major crop (2nd)"
label var plant_month_3 "major planting/growing month of major crop (3rd)"

label var harvest_month_1 "major harvest month of major crop (1st)"
label var harvest_month_2 "major harvest month of major crop (2nd)"
label var harvest_month_3 "major harvest month of major crop (3rd)"

sa "$path\Relevant data\sect06_com_w3", replace

** sect7_com_w3 **
clear all
use "$path\sect07_com_w3.dta"

keep ea_id ea_id2 cs7q01_a cs7q02 cs7q03

gen reported_drought = 1 if cs7q01_a == "Drought"
gen affected_drought = cs7q03 if cs7q01_a == "Drought"

gen reported_PSNP = 1 if cs7q01_a == "PSNP"
gen affected_PSNP= cs7q03 if cs7q01_a == "PSNP"

gen reported_dev_project = 1 if cs7q01_a == "Development Project"
gen affected_dev_project = cs7q03 if cs7q01_a == "Development Project"

gen reported_disease = 1 if cs7q01_a == "Human Epidemic Disease"
gen affected_disease = cs7q03 if cs7q01_a == "Human Epidemic Disease"

keep if cs7q01_a == "Drought" | cs7q01_a == "Development Project" | cs7q01_a == "PSNP" | cs7q01_a == "Human Epidemic Disease"

drop cs7q01_a cs7q03
rename cs7q02 year_of_change

collapse (sum) reported_drought affected_drought reported_PSNP affected_PSNP ///
reported_dev_project affected_dev_project reported_disease affected_disease, ///
by(ea_id ea_id2 year_of_change)

gen year = year_of_change + 8
drop year_of_change

/* Note: here only the year (and not month) is reported, so we don't know for sure
whether they are 7 or 8 years behind (since this changes in mid-september). Since the
largest overlap between calendars is for 8 years, I assume 8 years */

sa "$path\Relevant data\sect07_com_w3", replace

** sect7_hh_w3 **
clear all
use "$path\sect7_hh_w3"


keep household_id household_id2 ea_id ea_id2 hh_s7q01 hh_s7q06 hh_s7q07_a hh_s7q07_b hh_s7q07_c hh_s7q07_d hh_s7q07_e hh_s7q07_f hh_s7q07_g hh_s7q07_h hh_s7q07_i hh_s7q07_j hh_s7q07_k hh_s7q07_l

foreach y in a b c d e f g h i j k l {
replace hh_s7q07_`y' = "1" if hh_s7q07_`y'=="X"
destring hh_s7q07_`y', replace
replace hh_s7q07_`y' = 0 if hh_s7q07_`y'!=1
}

gen sum_months = hh_s7q07_a + hh_s7q07_b +  hh_s7q07_c + hh_s7q07_d + hh_s7q07_e + hh_s7q07_f + hh_s7q07_g + hh_s7q07_h + hh_s7q07_i ///
+ hh_s7q07_j + hh_s7q07_k + hh_s7q07_l

rename hh_s7q01 food_insecure_7d 
rename hh_s7q06 food_insecure_year
bysort ea_id2: egen insec_months = mean(sum_months)
label var insec_months "average amount of months food insecure last 12 months for households in kebele"

keep household_id household_id2 insec_months sum_months food_insecure_year food_insecure_7d

replace food_insecure_7d=0 if food_insecure_7d==2
replace food_insecure_year=0 if food_insecure_year==2

sa "$path\Relevant data\sect7_hh_w3.dta", replace

** sect09_com_w3 **
clear all
use "$path\sect09_com_w3.dta"

keep ea_id ea_id2 cs9q01 cs9q13

rename cs9q01 PSNP_operated
replace PSNP_operated=0 if PSNP_operated==2

rename cs9q13 HH_graduated_PSNP

sa "$path\Relevant data\sect09_com_w3.dta", replace

** sect9_ph_w3 **
clear all
use "$path\sect9_ph_w3.dta"

/* I remove observations where field_ID is divided into different crops on the same
field, in order to merge with data about the size of field. This will create a small
upward bias in size of field destroyed due to lack of rain. However, the number of 
these observations are small - and the bias is likely such. Secondly, it is
only used for descriptive observation and is not a part of core analysis */ 

sort household_id2 parcel_id field_id
quietly by household_id2 parcel_id field_id: gen dup = cond(_N==1,0,_n)

keep household_id household_id2 parcel_id field_id ph_s9q12 ph_s9q13 dup
keep if ph_s9q12==2
drop if dup>0

merge 1:1 household_id2 field_id parcel_id using "$path\Relevant data\sect3_pp_w3.dta", nogen
keep household_id household_id2 parcel_id field_id ph_s9q12 ph_s9q13 tot_land_area tot_hh_land

keep if ph_s9q12==2

gen land_damaged_drought = tot_land_area * (ph_s9q13 / 100)
egen hh_land_dmg_drought = total(land_damaged_drought), by(household_id2)

bysort household_id2: gen dup=_n
keep if dup==1
drop dup

keep household_id household_id2 ph_s9q12 hh_land_dmg_drought
replace hh_land_dmg_drought=. if hh_land_dmg_drought==0
label var hh_land_dmg_drought "land (sq m) damaged from drought recent harvest"

drop ph_s9q12

sa "$path\Relevant data\sect9_ph_w3.dta", replace


** sect13_hh_w3 **
clear all
use "$path\sect13_hh_w3.dta"

keep household_id household_id2 hh_s13q0a hh_s13q01

gen recieved_PSNP = 1 if hh_s13q0a == "PSNP" & hh_s13q01==1
gen recieved_other_assistance = 1 if hh_s13q0a == "Illness of household member" & hh_s13q01 == 1 | hh_s13q0a == "Food-for-work programme or sach-for-work prog"  & hh_s13q01 == 1 | hh_s13q0a == "Inputs-for-work programme"  & hh_s13q01 == 1 | hh_s13q0a == "Other (Specify)" ///
& hh_s13q01 == 1

egen rec_PSNP = total(recieved_PSNP), by(household_id2)

egen rec_other_assist = total(recieved_other_assistance), by(household_id2)
label var rec_PSNP "HH recieved PSNP payments within last year"
label var rec_other_assist "HH recieved assistance other than PSNP within last year"

bysort household_id2: gen dup=_n
keep if dup==1
drop dup

keep household_id household_id2 rec_PSNP rec_other_assist

replace rec_other_assist=1 if rec_other_assist>1 & ! missing(rec_other_assist)

sa "$path\Relevant data\sect13_hh_w3.dta", replace


** sect8_hh_w3 **
clear all
use "$path\sect8_hh_w3.dta"


gen other_shock=0
foreach t in 105 106 107 108 112 113 115 116 117 118 {
replace other_shock=1 if hh_s8q00==`t' & hh_s8q01==1
}

bysort household_id2: egen hh_other_shock = total(other_shock)
bysort household_id2: replace hh_other_shock=1 if hh_other_shock>1

label var hh_other_shock "HH experienced other aggregate shock than drought during past 12 months"

keep household_id household_id2 ea_id ea_id2 hh_other_shock
bysort household_id2: gen dup = _n
drop if dup>1
drop dup

sa "$path\Relevant data\sect8_hh_w3.dta", replace

** sect7_pp_w2 ******************************************************************************************
clear all 
use "$path\sect7_pp_w3.dta"

bysort household_id2: gen dup = _n
drop if dup>1
drop dup

keep household_id2 pp_s7q08
rename pp_s7q08 advisory_service
replace advisory_service=0 if advisory_service==2
sa "$path\Relevant data\sect7_pp_w3.dta", replace






** cons_agg_w3 **
clear all
use "$path\cons_agg_w3.dta"

keep household_id household_id2 hh_size adulteq food_cons_ann nonfood_cons_ann educ_cons_ann ///
total_cons_ann price_index_hce nom_totcons_aeq cons_quint

gen food_cons_aeq = (food_cons_ann / adulteq) / price_index_hce
label var food_cons_aeq "Real food consumption pr. adult eq."

gen nonfood_cons_aeq = (nonfood_cons_ann / adulteq) / price_index_hce
label var nonfood_cons_aeq "Real exp on selected nonfood items pr adult eq."

gen educ_cons_aeq = (educ_cons_ann / adulteq) / price_index_hce
label var educ_cons_aeq "Real exp on education pr adult eq."

sa "$path\Relevant data\cons_agg_w3.dta", replace


*** merge ***
clear all
use "$path\Relevant data\sect_cover_hh_w3.dta"

merge m:1 region zone_code woreda_code using "$path\Relevant data\local_area_names.dta", nogen
drop if missing(household_id2)

merge 1:1 household_id2 using "$path\Relevant data\hh_geovariables.dta", nogen
merge 1:m household_id2 using "$path\Relevant data\plot_geovariables.dta", nogen
merge m:1 ea_id2 using "$path\Relevant data\sect01b_com_w3.dta", nogen
merge m:1 ea_id2 using "$path\Relevant data\sect03_com_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect3_pp_w3_scraped.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect4_hh_w3.dta", nogen
merge m:1 ea_id2 using "$path\Relevant data\sect04_com_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect4_pp_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect5_pp_w3.dta", nogen
merge m:1 ea_id2 using "$path\Relevant data\sect06_com_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect7_hh_w3.dta", nogen
merge m:1 ea_id2 using "$path\Relevant data\sect09_com_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect9_ph_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect13_hh_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\cons_agg_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect2_hh_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect7_pp_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect8_hh_w3.dta", nogen
merge 1:1 household_id2 using "$path\Relevant data\sect1_hh_w3.dta", nogen

drop if missing(ea_id2) & missing(ea_id)
gen ea_idnew = ea_id2 if missing(ea_id)
egen ea_idnew2 = concat(ea_id ea_idnew)

drop ea_id ea_idnew
rename ea_idnew2 ea_id
sa "$path\Relevant data\ESS3.dta", replace

** append ESS2 & ESS1 **
use "$path\Relevant data\ESS3.dta"
append using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\ESS\ESS1\Relevant data\ess1.dta"
append using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\ESS\ESS2\Relevant data\ess2.dta"

replace too_little_rain=0 if missing(too_little_rain)
replace hh_land_dmg_drought=0 if missing(hh_land_dmg_drought)
drop if missing(household_id) & missing(household_id2)

order household_id household_id2 ea_id ea_id2 year month pw pw2 pw_w3
sort year month household_id2 household_id
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\ESS\ESS_allrounds.dta", replace


