** Do-file for making scatter plots from sample dataset
** Author: Albert Nygård

clear all
set more off

global path "C:\Users\Albert\Documents\Polit\Speciale_local\Data"
 
use "$path\Stata_in\Predicted_greenness_final.dta"

/* create dataset of 2% sample */
sample 2

/* scatter NDVI-anomalies on predicted NDVI-anomalies */
twoway scatter ndvi_an ndvi_hat_an, msize(vtiny) || lfit ndvi_an ndvi_hat_an, ///
color(gs1)

/* scatter NDVI-anomalies on predicted NDVI-anomalies, w. climate_zone dummies */
twoway scatter ndvi_an ndvi_hat_cz, msize(vtiny) || lfit ndvi_an ndvi_hat_cz, /// 
color(gs1) 


/* scatter NDVI-anomalies on predicted NDVI-anomalies, RF */
twoway scatter ndvi_an ndvi_hat_an_rf, msize(vtiny) || lfit ndvi_an ndvi_hat_an_rf, ///
color(gs1)

