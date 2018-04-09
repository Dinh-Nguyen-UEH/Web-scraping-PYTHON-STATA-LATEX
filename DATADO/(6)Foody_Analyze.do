*===============================================================================
*Set global path================================================================ 
global maytinh "D:\Dropbox (Vo Tat Thang)\[0][Master]Database"
*global maytinh "C:\Users\nguye\Dropbox (Vo Tat Thang)\[0][Master]Database"

global project "$maytinh\(3)Library_of_Project\(99)Mics\(13)Web-scraping"

global dataraw "$project\DATARAW"
global datatemp "$project\DATATEMP"
global datades "$project\DATADES"
*===============================================================================
 
use "$datades\foody_data_cleaned.dta", clear 
 

tab name district if category == 3 
tab name if category == 3 & district == "Phú Nhuận"
browse if category == 3 & district == "Phú Nhuận"
export excel using "$datades\foody_data_cleaned.xlsx", replace ///
	firstrow(varlabels)
