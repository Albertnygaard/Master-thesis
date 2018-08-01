/* This dataset imports ASCII files, make appropriate data management 
operations if necessary and merge into a single dataset used for generating 
predicted greenness */

clear all
set more off, perm


******************************************************************************

/* First we import a dataset with coordinates */

* generate pixel center coordinates for 7200*3600 data:
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\NDVI"
ras2dta, files(eth_ndvi2000032) idc(id) genxcoord(x) genycoord(y) replace clear

/* I read from the ASC-file that the bottom (x;y) corner has the coordinates
(lon;lat) (32.95;3.4), with 301 columns and 230 rows. That means that the top
left corner from which the matrix start has the coordinates (32,95;14,90), and
the middle of the first 0.05 pixel has the corner (32,975;14,875). Thus, we 
define the lon and lat coordinates as: */

g lon = (x/7200)*360 + 32.925
g lat = (y*(-1)/3600)*180 + 14.925
drop eth_ndvi2000032
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\id_latlon.dta", replace


*ndvi:
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\NDVI"
foreach y in 2000032 2000061 2000092	2000122	2000153	2000183	2000214	2000245	2000275	2000306	2000336	2001001	2001032	2001060	2001091	2001121	2001152	2001182	2001213	2001244	2001274	2001305	2001335	2002001	2002032	2002060	2002091	2002121	2002152	2002182	2002213	2002244	2002274	2002305	2002335	2003001	2003032	2003060	2003091	2003121	2003152	2003182	2003213	2003244	2003274	2003305	2003335	2004001	2004032	2004061	2004092	2004122	2004153	2004183	2004214	2004245	2004275	2004306	2004336	2005001	2005032	2005060	2005091	2005121	2005152	2005182	2005213	2005244	2005274	2005305	2005335	2006001	2006032	2006060	2006091	2006121	2006152	2006182	2006213	2006244	2006274	2006305	2006335	2007001	2007032	2007060	2007091	2007121	2007152	2007182	2007213	2007244	2007274	2007305	2007335	2008001	2008032	2008061	2008092	2008122	2008153	2008183	2008214	2008245	2008275	2008306	2008336	2009001	2009032	2009060	2009091	2009121	2009152	2009182	2009213	2009244	2009274	2009305	2009335	2010001	2010032	2010060	2010091	2010121	2010152	2010182	2010213	2010244	2010274	2010305	2010335	2011001	2011032	2011060	2011091	2011121	2011152	2011182	2011213	2011244	2011274	2011305	2011335	2012001	2012032	2012061	2012092	2012122	2012153	2012183	2012214	2012245	2012275	2012306	2012336	2013001	2013032	2013060	2013091	2013121	2013152	2013182	2013213	2013244 2013274 2013305 2013335 2014001 2014032 2014060 2014091 2014121 2014152 2014182 2014213 2014244 2014274 2014305 2014335 2015001 2015032 2015060 2015091 2015121 2015152 2015182 2015213 2015244 2015274 2015305 2015335 2016001 2016032 2016061 2016092 2016122 2016153 2016183 2016214 2016245 2016275 2016306 2016336 2017001 2017032 2017060 2017091 2017121 2017152 2017182 2017213 2017244 2017274 2017305 2017335 2018001 {
ras2dta, files(eth_ndvi`y') idc(id) replace clear
}
u eth_ndvi2000032, clear
foreach y in 2000061 2000092	2000122	2000153	2000183	2000214	2000245	2000275	2000306	2000336	2001001	2001032	2001060	2001091	2001121	2001152	2001182	2001213	2001244	2001274	2001305	2001335	2002001	2002032	2002060	2002091	2002121	2002152	2002182	2002213	2002244	2002274	2002305	2002335	2003001	2003032	2003060	2003091	2003121	2003152	2003182	2003213	2003244	2003274	2003305	2003335	2004001	2004032	2004061	2004092	2004122	2004153	2004183	2004214	2004245	2004275	2004306	2004336	2005001	2005032	2005060	2005091	2005121	2005152	2005182	2005213	2005244	2005274	2005305	2005335	2006001	2006032	2006060	2006091	2006121	2006152	2006182	2006213	2006244	2006274	2006305	2006335	2007001	2007032	2007060	2007091	2007121	2007152	2007182	2007213	2007244	2007274	2007305	2007335	2008001	2008032	2008061	2008092	2008122	2008153	2008183	2008214	2008245	2008275	2008306	2008336	2009001	2009032	2009060	2009091	2009121	2009152	2009182	2009213	2009244	2009274	2009305	2009335	2010001	2010032	2010060	2010091	2010121	2010152	2010182	2010213	2010244	2010274	2010305	2010335	2011001	2011032	2011060	2011091	2011121	2011152	2011182	2011213	2011244	2011274	2011305	2011335	2012001	2012032	2012061	2012092	2012122	2012153	2012183	2012214	2012245	2012275	2012306	2012336	2013001	2013032	2013060	2013091	2013121	2013152	2013182	2013213	2013244 2013274 2013305 2013335 2014001 2014032 2014060 2014091 2014121 2014152 2014182 2014213 2014244 2014274 2014305 2014335 2015001 2015032 2015060 2015091 2015121 2015152 2015182 2015213 2015244 2015274 2015305 2015335 2016001 2016032 2016061 2016092 2016122 2016153 2016183 2016214 2016245 2016275 2016306 2016336 2017001 2017032 2017060 2017091 2017121 2017152 2017182 2017213 2017244 2017274 2017305 2017335 2018001 {
merge 1:1 id using eth_ndvi`y', nogen
}
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\ndvi.dta", replace

* Renaming variables *
clear all
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"
use ndvi.dta
rename eth_ndvi#001 ndvi#01

rename eth_ndvi#032 ndvi#02

rename eth_ndvi#060 ndvi#03
rename eth_ndvi#061 ndvi#03

rename eth_ndvi#091 ndvi#04
rename eth_ndvi#092 ndvi#04

rename eth_ndvi#121 ndvi#05
rename eth_ndvi#122 ndvi#05

rename eth_ndvi#152 ndvi#06
rename eth_ndvi#153 ndvi#06

rename eth_ndvi#182 ndvi#07
rename eth_ndvi#183 ndvi#07

rename eth_ndvi#213 ndvi#08
rename eth_ndvi#214 ndvi#08

rename eth_ndvi#244 ndvi#09
rename eth_ndvi#245 ndvi#09

rename eth_ndvi#274 ndvi#10
rename eth_ndvi#275 ndvi#10

rename eth_ndvi#305 ndvi#11
rename eth_ndvi#306 ndvi#11

rename eth_ndvi#335 ndvi#12
rename eth_ndvi#336 ndvi#12

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\ndvi.dta", replace

/* OBS: the current scale is 0.0001 (MODIS default) */

*****************************************************************************

*lst day:
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\LST_day"
foreach y in 2000032 2000061 2000092	2000122	2000153	2000183	2000214	2000245	2000275	2000306	2000336	2001001	2001032	2001060	2001091	2001121	2001152	2001182	2001213	2001244	2001274	2001305	2001335	2002001	2002032	2002060	2002091	2002121	2002152	2002182	2002213	2002244	2002274	2002305	2002335	2003001	2003032	2003060	2003091	2003121	2003152	2003182	2003213	2003244	2003274	2003305	2003335	2004001	2004032	2004061	2004092	2004122	2004153	2004183	2004214	2004245	2004275	2004306	2004336	2005001	2005032	2005060	2005091	2005121	2005152	2005182	2005213	2005244	2005274	2005305	2005335	2006001	2006032	2006060	2006091	2006121	2006152	2006182	2006213	2006244	2006274	2006305	2006335	2007001	2007032	2007060	2007091	2007121	2007152	2007182	2007213	2007244	2007274	2007305	2007335	2008001	2008032	2008061	2008092	2008122	2008153	2008183	2008214	2008245	2008275	2008306	2008336	2009001	2009032	2009060	2009091	2009121	2009152	2009182	2009213	2009244	2009274	2009305	2009335	2010001	2010032	2010060	2010091	2010121	2010152	2010182	2010213	2010244	2010274	2010305	2010335	2011001	2011032	2011060	2011091	2011121	2011152	2011182	2011213	2011244	2011274	2011305	2011335	2012001	2012032	2012061	2012092	2012122	2012153	2012183	2012214	2012245	2012275	2012306	2012336	2013001	2013032	2013060	2013091	2013121	2013152	2013182	2013213	2013244 2013274 2013305 2013335 2014001 2014032 2014060 2014091 2014121 2014152 2014182 2014213 2014244 2014274 2014305 2014335 2015001 2015032 2015060 2015091 2015121 2015152 2015182 2015213 2015244 2015274 2015305 2015335 2016001 2016032 2016061 2016092 2016122 2016153 2016183 2016214 2016245 2016275 2016306 2016336 2017001 2017032 2017060 2017091 2017121 2017152 2017182 2017213 2017244 2017274 2017305 2017335 2018001 {
ras2dta, files(eth_lst_day`y') idc(id) replace clear
}
u eth_lst_day2000032, clear
foreach y in 2000061 2000092	2000122	2000153	2000183	2000214	2000245	2000275	2000306	2000336	2001001	2001032	2001060	2001091	2001121	2001152	2001182	2001213	2001244	2001274	2001305	2001335	2002001	2002032	2002060	2002091	2002121	2002152	2002182	2002213	2002244	2002274	2002305	2002335	2003001	2003032	2003060	2003091	2003121	2003152	2003182	2003213	2003244	2003274	2003305	2003335	2004001	2004032	2004061	2004092	2004122	2004153	2004183	2004214	2004245	2004275	2004306	2004336	2005001	2005032	2005060	2005091	2005121	2005152	2005182	2005213	2005244	2005274	2005305	2005335	2006001	2006032	2006060	2006091	2006121	2006152	2006182	2006213	2006244	2006274	2006305	2006335	2007001	2007032	2007060	2007091	2007121	2007152	2007182	2007213	2007244	2007274	2007305	2007335	2008001	2008032	2008061	2008092	2008122	2008153	2008183	2008214	2008245	2008275	2008306	2008336	2009001	2009032	2009060	2009091	2009121	2009152	2009182	2009213	2009244	2009274	2009305	2009335	2010001	2010032	2010060	2010091	2010121	2010152	2010182	2010213	2010244	2010274	2010305	2010335	2011001	2011032	2011060	2011091	2011121	2011152	2011182	2011213	2011244	2011274	2011305	2011335	2012001	2012032	2012061	2012092	2012122	2012153	2012183	2012214	2012245	2012275	2012306	2012336	2013001	2013032	2013060	2013091	2013121	2013152	2013182	2013213	2013244 2013274 2013305 2013335 2014001 2014032 2014060 2014091 2014121 2014152 2014182 2014213 2014244 2014274 2014305 2014335 2015001 2015032 2015060 2015091 2015121 2015152 2015182 2015213 2015244 2015274 2015305 2015335 2016001 2016032 2016061 2016092 2016122 2016153 2016183 2016214 2016245 2016275 2016306 2016336 2017001 2017032 2017060 2017091 2017121 2017152 2017182 2017213 2017244 2017274 2017305 2017335 2018001 {
merge 1:1 id using eth_lst_day`y', nogen
}
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_day.dta", replace

* Renaming variables *
clear all
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"
use lst_day.dta

rename eth_lst_day#001 lst_day#01

rename eth_lst_day#032 lst_day#02

rename eth_lst_day#060 lst_day#03
rename eth_lst_day#061 lst_day#03

rename eth_lst_day#091 lst_day#04
rename eth_lst_day#092 lst_day#04

rename eth_lst_day#121 lst_day#05
rename eth_lst_day#122 lst_day#05

rename eth_lst_day#152 lst_day#06
rename eth_lst_day#153 lst_day#06

rename eth_lst_day#182 lst_day#07
rename eth_lst_day#183 lst_day#07

rename eth_lst_day#213 lst_day#08
rename eth_lst_day#214 lst_day#08

rename eth_lst_day#244 lst_day#09
rename eth_lst_day#245 lst_day#09

rename eth_lst_day#274 lst_day#10
rename eth_lst_day#275 lst_day#10

rename eth_lst_day#305 lst_day#11
rename eth_lst_day#306 lst_day#11

rename eth_lst_day#335 lst_day#12
rename eth_lst_day#336 lst_day#12

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_day.dta", replace

/* make scaling to 1 = degree celcius/kelvin, based on scaling factor from NASA */ 
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"
use lst_day.dta
foreach y in 200002	200003	200004	200005	200006	200007	200008	200009	200010	200011	200012	200101	200102	200103	200104	200105	200106	200107	200108	200109	200110	200111	200112	200201	200202	200203	200204	200205	200206	200207	200208	200209	200210	200211	200212	200301	200302	200303	200304	200305	200306	200307	200308	200309	200310	200311	200312	200401	200402	200403	200404	200405	200406	200407	200408	200409	200410	200411	200412	200501	200502	200503	200504	200505	200506	200507	200508	200509	200510	200511	200512	200601	200602	200603	200604	200605	200606	200607	200608	200609	200610	200611	200612	200701	200702	200703	200704	200705	200706	200707	200708	200709	200710	200711	200712	200801	200802	200803	200804	200805	200806	200807	200808	200809	200810	200811	200812	200901	200902	200903	200904	200905	200906	200907	200908	200909	200910	200911	200912	201001	201002	201003	201004	201005	201006	201007	201008	201009	201010	201011	201012	201101	201102	201103	201104	201105	201106	201107 201108	201109	201110	201111	201112	201201	201202	201203	201204	201205	201206	201207	201208	201209	201210	201211	201212 201301 201302 201303 201304 201305 201306 201307 201308 201309 201310 201311 201312 201401 201402 201403 201404 201405 201406 201407 201408 201409 201410 201411 201412 201501 201502 201503 201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201602 201603 201604 201605 201606 201607 201608 201609 201610 201611 201612 201701 201702 201703 201704 201705 201706 201707 201708 201709 201710  201711 201712 201801 {
gen lst_day`y'_normalized = lst_day`y' * 0.02
drop lst_day`y'
rename lst_day`y'_normalized lst_day`y'
}

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_day.dta", replace

*****************************************************************************

*lst night:
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\LST_night"
foreach y in 2000032 2000061 2000092	2000122	2000153	2000183	2000214	2000245	2000275	2000306	2000336	2001001	2001032	2001060	2001091	2001121	2001152	2001182	2001213	2001244	2001274	2001305	2001335	2002001	2002032	2002060	2002091	2002121	2002152	2002182	2002213	2002244	2002274	2002305	2002335	2003001	2003032	2003060	2003091	2003121	2003152	2003182	2003213	2003244	2003274	2003305	2003335	2004001	2004032	2004061	2004092	2004122	2004153	2004183	2004214	2004245	2004275	2004306	2004336	2005001	2005032	2005060	2005091	2005121	2005152	2005182	2005213	2005244	2005274	2005305	2005335	2006001	2006032	2006060	2006091	2006121	2006152	2006182	2006213	2006244	2006274	2006305	2006335	2007001	2007032	2007060	2007091	2007121	2007152	2007182	2007213	2007244	2007274	2007305	2007335	2008001	2008032	2008061	2008092	2008122	2008153	2008183	2008214	2008245	2008275	2008306	2008336	2009001	2009032	2009060	2009091	2009121	2009152	2009182	2009213	2009244	2009274	2009305	2009335	2010001	2010032	2010060	2010091	2010121	2010152	2010182	2010213	2010244	2010274	2010305	2010335	2011001	2011032	2011060	2011091	2011121	2011152	2011182	2011213	2011244	2011274	2011305	2011335	2012001	2012032	2012061	2012092	2012122	2012153	2012183	2012214	2012245	2012275	2012306	2012336	2013001	2013032	2013060	2013091	2013121	2013152	2013182	2013213	2013244 2013274 2013305 2013335 2014001 2014032 2014060 2014091 2014121 2014152 2014182 2014213 2014244 2014274 2014305 2014335 2015001 2015032 2015060 2015091 2015121 2015152 2015182 2015213 2015244 2015274 2015305 2015335 2016001 2016032 2016061 2016092 2016122 2016153 2016183 2016214 2016245 2016275 2016306 2016336 2017001 2017032 2017060 2017091 2017121 2017152 2017182 2017213 2017244 2017274 2017305 2017335 2018001 {
ras2dta, files(eth_lst_night`y') idc(id) replace clear
}
u eth_lst_night2000032, clear
foreach y in 2000061 2000092	2000122	2000153	2000183	2000214	2000245	2000275	2000306	2000336	2001001	2001032	2001060	2001091	2001121	2001152	2001182	2001213	2001244	2001274	2001305	2001335	2002001	2002032	2002060	2002091	2002121	2002152	2002182	2002213	2002244	2002274	2002305	2002335	2003001	2003032	2003060	2003091	2003121	2003152	2003182	2003213	2003244	2003274	2003305	2003335	2004001	2004032	2004061	2004092	2004122	2004153	2004183	2004214	2004245	2004275	2004306	2004336	2005001	2005032	2005060	2005091	2005121	2005152	2005182	2005213	2005244	2005274	2005305	2005335	2006001	2006032	2006060	2006091	2006121	2006152	2006182	2006213	2006244	2006274	2006305	2006335	2007001	2007032	2007060	2007091	2007121	2007152	2007182	2007213	2007244	2007274	2007305	2007335	2008001	2008032	2008061	2008092	2008122	2008153	2008183	2008214	2008245	2008275	2008306	2008336	2009001	2009032	2009060	2009091	2009121	2009152	2009182	2009213	2009244	2009274	2009305	2009335	2010001	2010032	2010060	2010091	2010121	2010152	2010182	2010213	2010244	2010274	2010305	2010335	2011001	2011032	2011060	2011091	2011121	2011152	2011182	2011213	2011244	2011274	2011305	2011335	2012001	2012032	2012061	2012092	2012122	2012153	2012183	2012214	2012245	2012275	2012306	2012336	2013001	2013032	2013060	2013091	2013121	2013152	2013182	2013213	2013244 2013274 2013305 2013335 2014001 2014032 2014060 2014091 2014121 2014152 2014182 2014213 2014244 2014274 2014305 2014335 2015001 2015032 2015060 2015091 2015121 2015152 2015182 2015213 2015244 2015274 2015305 2015335 2016001 2016032 2016061 2016092 2016122 2016153 2016183 2016214 2016245 2016275 2016306 2016336 2017001 2017032 2017060 2017091 2017121 2017152 2017182 2017213 2017244 2017274 2017305 2017335 2018001 {
merge 1:1 id using eth_lst_night`y', nogen
}
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_night.dta", replace

* Renaming variables *
clear all
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"
use lst_night.dta

rename eth_lst_night#001 lst_night#01

rename eth_lst_night#032 lst_night#02

rename eth_lst_night#060 lst_night#03
rename eth_lst_night#061 lst_night#03

rename eth_lst_night#091 lst_night#04
rename eth_lst_night#092 lst_night#04

rename eth_lst_night#121 lst_night#05
rename eth_lst_night#122 lst_night#05

rename eth_lst_night#152 lst_night#06
rename eth_lst_night#153 lst_night#06

rename eth_lst_night#182 lst_night#07
rename eth_lst_night#183 lst_night#07

rename eth_lst_night#213 lst_night#08
rename eth_lst_night#214 lst_night#08

rename eth_lst_night#244 lst_night#09
rename eth_lst_night#245 lst_night#09

rename eth_lst_night#274 lst_night#10
rename eth_lst_night#275 lst_night#10

rename eth_lst_night#305 lst_night#11
rename eth_lst_night#306 lst_night#11

rename eth_lst_night#335 lst_night#12
rename eth_lst_night#336 lst_night#12

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_night.dta", replace

/* make scaling to 1 = degree celcius/kelvin, based on scaling factor from NASA */ 
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"
use lst_night.dta
foreach y in 200002	200003	200004	200005	200006	200007	200008	200009	200010	200011	200012	200101	200102	200103	200104	200105	200106	200107	200108	200109	200110	200111	200112	200201	200202	200203	200204	200205	200206	200207	200208	200209	200210	200211	200212	200301	200302	200303	200304	200305	200306	200307	200308	200309	200310	200311	200312	200401	200402	200403	200404	200405	200406	200407	200408	200409	200410	200411	200412	200501	200502	200503	200504	200505	200506	200507	200508	200509	200510	200511	200512	200601	200602	200603	200604	200605	200606	200607	200608	200609	200610	200611	200612	200701	200702	200703	200704	200705	200706	200707	200708	200709	200710	200711	200712	200801	200802	200803	200804	200805	200806	200807	200808	200809	200810	200811	200812	200901	200902	200903	200904	200905	200906	200907	200908	200909	200910	200911	200912	201001	201002	201003	201004	201005	201006	201007	201008	201009	201010	201011	201012	201101	201102	201103	201104	201105	201106	201107 201108	201109	201110	201111	201112	201201	201202	201203	201204	201205	201206	201207	201208	201209	201210	201211	201212 201301 201302 201303 201304 201305 201306 201307 201308 201309 201310 201311 201312 201401 201402 201403 201404 201405 201406 201407 201408 201409 201410 201411 201412 201501 201502 201503 201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201602 201603 201604 201605 201606 201607 201608 201609 201610 201611 201612 201701 201702 201703 201704 201705 201706 201707 201708 201709 201710  201711 201712 201801 {
gen lst_night`y'_normalized = lst_night`y' * 0.02
drop lst_night`y'
rename lst_night`y'_normalized lst_night`y'
}

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_night.dta", replace

*****************************************************************************

*Rain_TRMM_bilinear:
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\TRMM72003600_BILINEAR"
foreach y in 	199801	199802	199803	199804	199805	199806	199807	199808	199809	199810	199811	199812	199901	199902	199903	199904	199905	199906	199907	199908	199909	199910	199911	199912	200001	200002	200003	200004	200005	200006	200007	200008	200009	200010	200011	200012	200101	200102	200103	200104	200105	200106	200107	200108	200109	200110	200111	200112	200201	200202	200203	200204	200205	200206	200207	200208	200209	200210	200211	200212	200301	200302	200303	200304	200305	200306	200307	200308	200309	200310	200311	200312	200401	200402	200403	200404	200405	200406	200407	200408	200409	200410	200411	200412	200501	200502	200503	200504	200505	200506	200507	200508	200509	200510	200511	200512	200601	200602	200603	200604	200605	200606	200607	200608	200609	200610	200611	200612	200701	200702	200703	200704	200705	200706	200707	200708	200709	200710	200711	200712	200801	200802	200803	200804	200805	200806	200807	200808	200809	200810	200811	200812	200901	200902	200903	200904	200905	200906	200907	200908	200909	200910	200911	200912	201001	201002	201003	201004	201005	201006	201007	201008	201009	201010	201011	201012	201101	201102	201103	201104	201105	201106	201107 201108	201109	201110	201111	201112	201201	201202	201203	201204	201205	201206	201207	201208	201209	201210	201211	201212 201301 201302 201303 201304 201305 201306 201307 201308 201309 201310 201311 201312 201401 201402 201403 201404 201405 201406 201407 201408 201409 201410 201411 201412 201501 201502 201503 201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201602 201603 201604 201605 201606 201607 201608 201609 201610 201611 201612 201701 201702 201703 201704 201705 201706 201707 201708 201709 201710  201711 201712 {
ras2dta, files(eth_rain_`y'0_bilinear) idc(id) replace clear
}

u eth_rain_1998010_bilinear, clear
foreach y in 	199802	199803	199804	199805	199806	199807	199808	199809	199810	199811	199812	199901	199902	199903	199904	199905	199906	199907	199908	199909	199910	199911	199912	200001	200002	200003	200004	200005	200006	200007	200008	200009	200010	200011	200012	200101	200102	200103	200104	200105	200106	200107	200108	200109	200110	200111	200112	200201	200202	200203	200204	200205	200206	200207	200208	200209	200210	200211	200212	200301	200302	200303	200304	200305	200306	200307	200308	200309	200310	200311	200312	200401	200402	200403	200404	200405	200406	200407	200408	200409	200410	200411	200412	200501	200502	200503	200504	200505	200506	200507	200508	200509	200510	200511	200512	200601	200602	200603	200604	200605	200606	200607	200608	200609	200610	200611	200612	200701	200702	200703	200704	200705	200706	200707	200708	200709	200710	200711	200712	200801	200802	200803	200804	200805	200806	200807	200808	200809	200810	200811	200812	200901	200902	200903	200904	200905	200906	200907	200908	200909	200910	200911	200912	201001	201002	201003	201004	201005	201006	201007	201008	201009	201010	201011	201012	201101	201102	201103	201104	201105	201106	201107 201108	201109	201110	201111	201112	201201	201202	201203	201204	201205	201206	201207	201208	201209	201210	201211	201212 201301 201302 201303 201304 201305 201306 201307 201308 201309 201310 201311 201312 201401 201402 201403 201404 201405 201406 201407 201408 201409 201410 201411 201412 201501 201502 201503 201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201602 201603 201604 201605 201606 201607 201608 201609 201610 201611 201612 201701 201702 201703 201704 201705 201706 201707 201708 201709 201710  201711 201712 {
merge 1:1 id using eth_rain_`y'0_bilinear, nogen
}
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\rain_trmm.dta", replace

* Renaming variables *
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"
use rain_trmm.dta
rename eth_rain_#_bilinear rain_bil#
rename rain_bil(######)0 rain_trmm(######)
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\rain_bil.dta", replace
*****************************************************************************


*Rain_CHIRPS:
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\CHIRPS"
foreach y in 	199906	199907	199908	199909	199910	199911	199912	200001	200002	200003	200004	200005	200006	200007	200008	200009	200010	200011	200012	200101	200102	200103	200104	200105	200106	200107	200108	200109	200110	200111	200112	200201	200202	200203	200204	200205	200206	200207	200208	200209	200210	200211	200212	200301	200302	200303	200304	200305	200306	200307	200308	200309	200310	200311	200312	200401	200402	200403	200404	200405	200406	200407	200408	200409	200410	200411	200412	200501	200502	200503	200504	200505	200506	200507	200508	200509	200510	200511	200512	200601	200602	200603	200604	200605	200606	200607	200608	200609	200610	200611	200612	200701	200702	200703	200704	200705	200706	200707	200708	200709	200710	200711	200712	200801	200802	200803	200804	200805	200806	200807	200808	200809	200810	200811	200812	200901	200902	200903	200904	200905	200906	200907	200908	200909	200910	200911	200912	201001	201002	201003	201004	201005	201006	201007	201008	201009	201010	201011	201012	201101	201102	201103	201104	201105	201106	201107 201108	201109	201110	201111	201112	201201	201202	201203	201204	201205	201206	201207	201208	201209	201210	201211	201212 201301 201302 201303 201304 201305 201306 201307 201308 201309 201310 201311 201312 201401 201402 201403 201404 201405 201406 201407 201408 201409 201410 201411 201412 201501 201502 201503 201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201602 201603 201604 201605 201606 201607 201608 201609 201610 201611 201612 201701 201702 201703 201704 201705 201706 201707 201708 201709 201710  201711 201712 {
ras2dta, files(chirps`y') idc(id) replace clear
}

u chirps199906, clear
foreach y in 	199907	199908	199909	199910	199911	199912	200001	200002	200003	200004	200005	200006	200007	200008	200009	200010	200011	200012	200101	200102	200103	200104	200105	200106	200107	200108	200109	200110	200111	200112	200201	200202	200203	200204	200205	200206	200207	200208	200209	200210	200211	200212	200301	200302	200303	200304	200305	200306	200307	200308	200309	200310	200311	200312	200401	200402	200403	200404	200405	200406	200407	200408	200409	200410	200411	200412	200501	200502	200503	200504	200505	200506	200507	200508	200509	200510	200511	200512	200601	200602	200603	200604	200605	200606	200607	200608	200609	200610	200611	200612	200701	200702	200703	200704	200705	200706	200707	200708	200709	200710	200711	200712	200801	200802	200803	200804	200805	200806	200807	200808	200809	200810	200811	200812	200901	200902	200903	200904	200905	200906	200907	200908	200909	200910	200911	200912	201001	201002	201003	201004	201005	201006	201007	201008	201009	201010	201011	201012	201101	201102	201103	201104	201105	201106	201107 201108	201109	201110	201111	201112	201201	201202	201203	201204	201205	201206	201207	201208	201209	201210	201211	201212 201301 201302 201303 201304 201305 201306 201307 201308 201309 201310 201311 201312 201401 201402 201403 201404 201405 201406 201407 201408 201409 201410 201411 201412 201501 201502 201503 201504 201505 201506 201507 201508 201509 201510 201511 201512 201601 201602 201603 201604 201605 201606 201607 201608 201609 201610 201611 201612 201701 201702 201703 201704 201705 201706 201707 201708 201709 201710  201711 201712 {
merge 1:1 id using chirps`y', nogen
}
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\rain_CHIRPS.dta", replace



*****************************************************************************

* Köppen-Geiger climate zones *
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Climate_zones"
ras2dta, files(eth_koppen_72003600) idc(id) replace clear
rename eth_koppen_72003600 climate_zones
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\climate_zones.dta", replace

*****************************************************************************

* Global Horizontal Radiation *
clear all
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Irradiance"
ras2dta, files(eth_GHI) idc(id) replace clear
rename eth_GHI ghi
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\GHI.dta", replace

*****************************************************************************

* Elevation *
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Elevation"
ras2dta, files(eth_elevation025) idc(id) replace clear
rename eth_elevation025 elevation

summarize elevation
* Correct for variable being inverse (so highest is the lowest point and vice versa)
gen elevation = 228 - elevation2
summarize elevation
/* The lowest point in Ethiopia is -125m, and the highest is 4550 meter. With 90
as observation interval, each observation corresponds to 51,944 meter. */
gen elevation3 = elevation*51.944
gen elevation4 = elevation3 - 125
drop elevation elevation2 elevation3
rename elevation4 elevation
/* Now the dataset is between 0 and 90, with zero being the lowest point
of -125 meter, and highest being 4550 meter */
sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\Elevation.dta", replace

******************************************************************************


/* merge alle dataset together */

u "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\id_latlon.dta", clear
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\ndvi.dta", nogen
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_day.dta", nogen
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_night.dta", nogen
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\rain_trmm.dta", nogen
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\rain_CHIRPS.dta", nogen
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\GHI.dta", nogen
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\Elevation.dta", nogen
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\climate_zones.dta", nogen

drop if missing(lat) 

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\weather_Data", replace

*******************************************************************************

/* create panel-set */
clear all
cd "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in"

/* rain_near and creating the master with time-invariant variables*/

use id_latlon.dta

merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\GHI.dta", nogen
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\Elevation.dta", nogen
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\climate_zones.dta", nogen
merge 1:1 id using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\rain_trmm.dta", nogen

reshape long rain_trmm, i(id) j(year)

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\rain_trmm_panel", replace

/* ndvi */

use ndvi.dta

reshape long ndvi, i(id) j(year)

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\ndvi_panel.dta", replace

/* lst_day */
use lst_day.dta

reshape long lst_day, i(id) j(year)

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_day_panel.dta", replace

/* lst_night */

use lst_night.dta

reshape long lst_night, i(id) j(year)

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_night_panel.dta", replace


/* rain_chirps */
use rain_chirps.dta

reshape long chirps, i(id) j(year)

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\rain_chirps_panel.dta", replace

******************************************************************************

/* Merge datasets together */ 
use rain_trmm_panel.dta

merge 1:1 id year using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\ndvi_panel.dta", nogen
merge 1:1 id year using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_day_panel.dta", nogen
merge 1:1 id year using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\lst_night_panel.dta", nogen
merge 1:1 id year using "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\rain_chirps_panel.dta", nogen

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\weather_data_panel.dta", replace

/* Clean and create appropriate units */

** create month and year **
rename year time
gen time2 = time
tostring time2, replace
gen year = substr(time2,1,4)
gen month = substr(time2,5,2)
drop time2
destring year, replace
destring month, replace

** make NDVI unit 0.001**
gen ndvi2 = ndvi*0.1
drop ndvi
rename ndvi2 ndvi

** make rain_trmm unit 0.1 (corresponding to 1 increase is 0.1mm/hour **
gen rain2 = rain*10
drop rain_trmm
rename rain2 rain_trmm

** create time variable **
by id: gen paneltime=_n
drop time
rename paneltime time

sa "C:\Users\Albert\Documents\Polit\Speciale_local\Data\Stata_in\weather_data_panel.dta", replace
