*===============================================================================
*Set global path================================================================ 
global maytinh "D:\Dropbox (Vo Tat Thang)\[0][Master]Database"
*global maytinh "C:\Users\nguye\Dropbox (Vo Tat Thang)\[0][Master]Database"

global project "$maytinh\(3)Library_of_Project\(99)Mics\(13)Web-scraping"

global dataraw  "$project\DATARAW"
global datatemp "$project\DATATEMP"
global datades  "$project\DATADES"
*===============================================================================

*===============================================================================
*Data of all companies==========================================================
import excel using "$dataraw\company_data_uncleaned.xlsx", clear ///
                                                           firstrow   
 drop page records total
 
*Delete unnecessary characters======== 
replace rows = subinstr(rows,"{","",.)
replace rows = subinstr(rows,"}","",.) 
replace rows = subinstr(rows,"'cell': ","",.) // Delete cell string in main data string

*Create id variable===========
gen str  id = substr(rows,7,3)
 la var id "Stock ID"
 replace id = subinstr(id,",","",.)
 replace id = strtrim(id)

replace rows = subinstr(rows,"'id': ","",.) // Delete id label in main data string
replace rows = subinstr(rows,id,"",2) // Delete id value
replace rows = subinstr(rows,", [, ","",1) // Delete unnescessary character
replace rows = subinstr(rows,"'","",.) // Delete unnescessary character 

*Create stock code variable=============
gen str  stock_code = substr(rows, 1, 3)
 la var stock_code "Stock code"
 replace stock_code = strtrim(stock_code)
 replace rows = subinstr(rows,stock_code, "", 1)

*Create ISIN code variable==============
gen str  isin_code = substr(rows, 1, 14)
 la var isin_code "ISIN code"
 replace rows      = subinstr(rows, isin_code, "", .)
 replace isin_code = subinstr(isin_code, ",", "" , .)
 replace isin_code = strtrim(isin_code)

*Create FIGI code variable============== 
gen str figi_code  = substr(rows, 1, 14)
 la var figi_code "FIGI code"
 replace rows      = subinstr(rows, figi_code, "", .)
 replace figi_code = subinstr(figi_code, ",", "", .)
 replace figi_code = strtrim(figi_code)

replace rows = "," + rows if strpos(rows,",") != 1

*Create listing data variable=====
gen last_found = strrpos(rows,"]") // Identify start of listing date string location
gen first_date = last_found - 12 // Identify end of listing date string location

gen str listing_date = substr(rows, first_date, last_found)
 drop last_found ///
      first_date
 la var listing_date "Listing date"
	  
replace listing_date = subinstr(listing_date, ",", "", .)
replace rows         = subinstr(rows, listing_date, "", .)
replace listing_date = subinstr(listing_date, "]", "", .) 
   
replace rows = subinstr(rows,", ","",1) 

*Create comany name and listing quantity variable=========== 
gen last_found  = strrpos(rows, ",") // Identify end of company name string location
gen first_found = strpos(rows, ",") // Identify start of company name string location

gen str total_temp = substr(rows,first_found,last_found)
 drop last_found ///
      first_found

 *Company name	  
replace rows = subinstr(rows, total_temp, "", .)
 ren rows company_name
 la var company_name "Company name"
 
 *Total listing quantity
replace total_temp = subinstr(total_temp,", ","",1)
replace total_temp = subinstr(total_temp,", ", " k ",1)
  *Registered listing quantity
gen str  listing_registered = substr(total_temp,1,strpos(total_temp, "k"))
 replace total_temp         = subinstr(total_temp,listing_registered, "", .)
 replace listing_registered = subinstr(listing_registered," k","",1)
  *Actual listing quantity
gen last_found = strrpos(total_temp,",")
 ren total_temp listing_actual 
 replace listing_actual = substr(listing_actual,1,last_found-1)
 drop last_found

replace listing_registered = subinstr(listing_registered,",00","",1)
replace listing_actual = subinstr(listing_actual,",00","",1)
replace listing_registered = subinstr(listing_registered,".","",.)
replace listing_actual = subinstr(listing_actual,".","",.)
 
la var listing_registered "Registered listing quantity"
la var listing_actual "Actual listing quantity" 
 
*Format date for date variables 
destring id listing_actual listing_registered, replace
gen listing_date_temp = date(listing_date,"DMY",2050)
 drop listing_date
ren listing_date_temp listing_date
 la var listing_date "Listing date"
 format listing_date %d 

gen listing_year = year(listing_date) 
 la var listing_year "Listing year"

order stock_code

compress

save "$datades\company_data_cleaned.dta", replace 
export excel using "$datades\company_data_cleaned.xlsx", replace ///
	firstrow(varlabels)
*===============================================================================
 

*===============================================================================
*Data of companies by sector====================================================  
foreach sheet in "Financial (1)" ///
	"Financial (2)" ///
	"Financial (3)" ///
	"Financial (4)" ///
	"Con. Staples (1)" ///
	"Con. Staples (2)" ///
	"Con. Staples (3)" ///
	"Utilities (1)" ///
	"Health Care (1)" ///
	"Health Care (2)" ///
	"Energy (1)" ///
	"Infor. Tech. (1)" ///
	"Infor. Tech. (2)" ///
	"Con. Discre. (1)" ///
	"Con. Discre. (2)" ///
	"Con. Discre. (3)" ///
	"Con. Discre. (4)" ///
	"Industrials (1)" ///
	"Industrials (2)" ///
	"Industrials (3)" ///
	"Materials (1)" ///
	"Real Estate (1)" {
	
	import excel using "$dataraw\company_sector_data_uncleaned.xlsx", ///
		sheet("`sheet'") ///
		clear ///
		firstrow   
 
	drop page records total
	
	tostring *, replace
	 
	*Delete unnecessary characters======== 
	replace rows = subinstr(rows,"{","",.)
	replace rows = subinstr(rows,"}","",.) 
	replace rows = subinstr(rows,"'cell': ","",.) // Delete cell string in main data string

	*Create id variable===========
	gen str  id = substr(rows,7,3)
	 la var  id "Stock ID"
	 replace id = subinstr(id,",","",.)
	 replace id = strtrim(id)

replace rows = subinstr(rows,"'id': ","",.) // Delete id label in main data string
replace rows = subinstr(rows,id,"",2) // Delete id value
replace rows = subinstr(rows,", [, ","",1) // Delete unnescessary character
replace rows = subinstr(rows,"'","",.) // Delete unnescessary character 

*Create stock code variable=============
gen str  stock_code = substr(rows, 1, 3)
 la var stock_code "Stock code"
 replace stock_code = strtrim(stock_code)
 replace rows = subinstr(rows,stock_code, "", 1)

*Create ISIN code variable==============
gen str  isin_code = substr(rows, 1, 14)
 la var isin_code "ISIN code"
 replace rows      = subinstr(rows, isin_code, "", .)
 replace isin_code = subinstr(isin_code, ",", "" , .)
 replace isin_code = strtrim(isin_code)

*Create FIGI code variable============== 
gen str figi_code  = substr(rows, 1, 14)
 la var figi_code "FIGI code"
 replace rows      = subinstr(rows, figi_code, "", .)
 replace figi_code = subinstr(figi_code, ",", "", .)
 replace figi_code = strtrim(figi_code)

replace rows = "," + rows if strpos(rows,",") != 1

*Create listing data variable=====
gen last_found = strrpos(rows,"]") // Identify start of listing date string location
gen first_date = last_found - 12 // Identify end of listing date string location

gen str listing_date = substr(rows, first_date, last_found)
 drop last_found ///
      first_date
 la var listing_date "Listing date"
	  
replace listing_date = subinstr(listing_date, ",", "", .)
replace rows         = subinstr(rows, listing_date, "", .)
replace listing_date = subinstr(listing_date, "]", "", .) 
   
replace rows = subinstr(rows,", ","",1) 

*Create comany name and listing quantity variable=========== 
gen last_found  = strrpos(rows, ",") // Identify end of company name string location
gen first_found = strpos(rows, ",") // Identify start of company name string location

gen str total_temp = substr(rows,first_found,last_found)
 drop last_found ///
      first_found

 *Company name	  
replace rows = subinstr(rows, total_temp, "", .)
 ren rows company_name
 la var company_name "Company name"
 
 *Total listing quantity
replace total_temp = subinstr(total_temp,", ","",1)
replace total_temp = subinstr(total_temp,", ", " k ",1)
  *Registered listing quantity
gen str  listing_registered = substr(total_temp,1,strpos(total_temp, "k"))
 replace total_temp         = subinstr(total_temp,listing_registered, "", .)
 replace listing_registered = subinstr(listing_registered," k","",1)
  *Actual listing quantity
gen last_found = strrpos(total_temp,",")
 ren total_temp listing_actual 
 replace listing_actual = substr(listing_actual,1,last_found-1)
 drop last_found

replace listing_registered = subinstr(listing_registered,",00","",1)
replace listing_actual = subinstr(listing_actual,",00","",1)
replace listing_registered = subinstr(listing_registered,".","",.)
replace listing_actual = subinstr(listing_actual,".","",.)
 
la var listing_registered "Registered listing quantity"
la var listing_actual "Actual listing quantity" 
 
*Format date for date variables 
destring id listing_actual listing_registered, replace
gen listing_date_temp = date(listing_date,"DMY",2050)
 drop listing_date
ren listing_date_temp listing_date
 la var listing_date "Listing date"
 format listing_date %d 

gen listing_year = year(listing_date) 
 la var listing_year "Listing year"

*Resclae listing quantity
foreach X of varlist listing_actual ///
                     listing_registered {
					 
	replace `X' = `X'/10^6

	local `X'_label : variable label `X'
	la var `X' "``X'_label' (mills.)"
					 
}
*					 
 
la var sector "Sector"
la var subsector "Sub-sector"
 
order stock_code

compress

save "$datatemp\company_data_`sheet'_cleaned.dta", replace  
 
}  
*


*Append data
use "$datatemp\company_data_Financial (1)_cleaned.dta", clear

foreach sheet in ///
	"Financial (2)" ///
	"Financial (3)" ///
	"Financial (4)" ///
	"Con. Staples (1)" ///
	"Con. Staples (2)" ///
	"Con. Staples (3)" ///
	"Utilities (1)" ///
	"Health Care (1)" ///
	"Health Care (2)" ///
	"Energy (1)" ///
	"Infor. Tech. (1)" ///
	"Infor. Tech. (2)" ///
	"Con. Discre. (1)" ///
	"Con. Discre. (2)" ///
	"Con. Discre. (3)" ///
	"Con. Discre. (4)" ///
	"Industrials (1)" ///
	"Industrials (2)" ///
	"Industrials (3)" ///
	"Materials (1)" ///
	"Real Estate (1)" {
	
		append using "$datatemp\company_data_`sheet'_cleaned.dta"
	
}
*	

foreach X of varlist sector ///
                     subsector { 
					 
	replace `X' = strrtrim(strtrim(`X'))				 
					 
	egen `X'_code = group(`X')
	labmask `X'_code, val(`X')
	drop `X'
	ren `X'_code `X'

	la var sector "Sector"
	la var subsector "Sub-sector"
	
}
*
	
compress

save "$datades\sector_company_data_cleaned.dta", replace  
export excel using "$datades\sector_company_data_cleaned.xlsx", replace ///
	firstrow(varlabels)
 
merge 1:1 stock_code using  "$datades\company_data_cleaned.dta"
tab company_name if _merge == 2
