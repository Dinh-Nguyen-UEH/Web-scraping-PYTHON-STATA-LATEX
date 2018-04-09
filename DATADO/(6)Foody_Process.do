*===============================================================================
*Set global path================================================================ 
global maytinh "D:\Dropbox (Vo Tat Thang)\[0][Master]Database"
*global maytinh "C:\Users\nguye\Dropbox (Vo Tat Thang)\[0][Master]Database"

global project "$maytinh\(3)Library_of_Project\(99)Mics\(13)Web-scraping"

global dataraw "$project\DATARAW"
global datatemp "$project\DATATEMP"
global datades "$project\DATADES"
*===============================================================================
  
	import excel using "$dataraw\foody_data_uncleaned.xlsx", ///
		clear ///
		sheet("Q11-Quán ăn") ///
		firstrow   
		
foreach district in "Q1" "Q2" "Q3" "Q4" "Q5" "Q6" "Q7" "Q8" "Q9" "Q10" "Q11" "Q12" ///
	"QTB" "QTP" "QBT" "QPN" {

	foreach category in "Nhà hàng" ///
                "Cà phê-dessert" ///
                "Quán ăn" ///
                "Bar-pub" ///
                "Karaoke" ///
                "Tiệm bánh" /// 
                "Tiệc cưới-hội nghị" ///
                "Ăn vặt-vỉa hè" ///
                "Sang trọng" ///
                "Giao cơm văn phòng" /// 
                "Buffet" ///
                "Beer club" /// 
                "Tiệc tận nơi" /// 
                "Khu ẩm thực" {


	import excel using "$dataraw\foody_data_uncleaned.xlsx", ///
		clear ///
		sheet("`district'-`category'") ///
		firstrow   
	
	ren *, lower 

	tostring address name score stat, replace
	
	*Remove specials characters from the address 
	replace address = strtrim(stritrim(address)) 
	replace address = usubinstr(address,char(10),"",.)
	replace address = ustrregexra(address,"[\n\r\t]","") 
 
	*Generate variable contains district and city 
	gen first_found = ustrpos(address, "Quận") 
	gen last_found = ustrrpos(address, ",") 
	gen district_city =  usubstr(address,first_found,last_found-1) if strmatch(address, "*Quận*") == 1
	replace address = usubinstr(address,district_city,"",1)
	 
	drop *_found

	replace address = strtrim(stritrim(address)) 
	replace district_city = strtrim(stritrim(district_city)) 

	gen first_found = ustrpos(district_city, ",") + 2 
	gen city =  usubstr(district_city,first_found,.) if strmatch(district_city, "*Quận*") == 1
	replace city = city[_N] if city == ""

	replace district_city = usubinstr(district_city,city,"",1)
	ren district_city district
	sort district
	replace district = district[_N] if district == ""
 
	drop *_found
 
	gen first_found = strpos(address, "P. ") 
	gen ward =  substr(address,first_found,.) if strmatch(address, "*P. ??*") == 1
	replace address = subinstr(address,ward,"",1)
	
	drop *_found

		foreach X of varlist address ward district city {

			replace `X' = strtrim(stritrim(`X')) 
			replace `X' = subinstr(`X', ",", "",.)

}
*

	*Generate number of stores fr a store
	gen chain_temp = 1 if strmatch(address, "*chi nhánh") == 1  
	replace address = usubinstr(address,"chi nhánh","",1) if strmatch(address, "*chi nhánh") == 1 
	gen total_stores = address if chain_temp == 1 
	replace total_stores = "1" if total_stores == "" 
	replace address = "Multiple stores" if chain_temp == 1  
	
	drop chain_temp
 
	replace ward = substr(ward,4,.) 
	replace district = substr(district,7,.) 
  
	gen first_found = strpos(stat, "-") 
	gen last_found = strrpos(stat, "-") 

	gen total_reviews = substr(stat,1,first_found-1) 
	gen total_pics = substr(stat,first_found,last_found-first_found)  
	 replace total_pics = subinstr(total_pics, "-", "", 1)

	drop *_found stat
 
	destring score total_stores total_reviews total_pics, replace
  
	recode score (. = .a)  
	
	la var address "Address"
	la var ward "Ward"
	la var district "District"
	la var city "City"
	la var total_stores "Total stores"
	la var total_reviews "Total reviews"
	la var total_pics "Total pictures"
  
	compress
 
	order name total_stores address ward district city 
	la data "Foody database - District: `district' - Category: `category'"
	
	save "$datatemp\foody_data_`district'_`category'_cleaned.dta", replace 
				
}
*				

}
*===============================================================================


*===============================================================================
*Append data====================================================================  
use "$datatemp\foody_data_Q1_Nhà hàng_cleaned.dta", clear

	foreach category in /// 
                "Cà phê-dessert" ///
                "Quán ăn" ///
                "Bar-pub" ///
                "Karaoke" ///
                "Tiệm bánh" /// 
                "Tiệc cưới-hội nghị" ///
                "Ăn vặt-vỉa hè" ///
                "Sang trọng" ///
                "Giao cơm văn phòng" /// 
                "Buffet" ///
                "Beer club" /// 
                "Tiệc tận nơi" /// 
                "Khu ẩm thực" {

	append using "$datatemp\foody_data_Q1_`category'_cleaned.dta"

}
*
save "$datades\foody_data_Q1_cleaned.dta", replace


use  "$datades\foody_data_Q1_cleaned.dta", clear
foreach district in "Q1" "Q2" "Q3" "Q4" "Q5" "Q6" "Q7" "Q8" "Q9" "Q10" "Q11" "Q12" ///
	"QTB" "QTP" "QBT" "QPN" {

	foreach category in ///
				"Nhà hàng" ///
                "Cà phê-dessert" ///
                "Quán ăn" ///
                "Bar-pub" ///
                "Karaoke" ///
                "Tiệm bánh" /// 
                "Tiệc cưới-hội nghị" ///
                "Ăn vặt-vỉa hè" ///
                "Sang trọng" ///
                "Giao cơm văn phòng" /// 
                "Buffet" ///
                "Beer club" /// 
                "Tiệc tận nơi" /// 
                "Khu ẩm thực" {

	append using "$datatemp\foody_data_`district'_`category'_cleaned.dta"

}
*
	
}
*

foreach X of varlist address ward district {

	replace `X' = strrtrim(strtrim(`X'))

}
*

replace city =  "TP. HCM" if strmatch(city, "*TP.*") == 1

egen category_code = group(category)
labmask category_code, val(category)
drop category
ren category_code category
la var category "Category"
	
la data "Foody database" 

duplicates drop _all, force // Why there are duplicates?

compress

save "$datades\foody_data_cleaned.dta", replace
export excel using "$datades\foody_data_cleaned.xlsx", replace ///
	firstrow(varlabels)
 