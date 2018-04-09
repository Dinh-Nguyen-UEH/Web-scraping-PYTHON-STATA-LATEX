*===============================================================================
*Set global path================================================================ 
global maytinh "D:\Dropbox (Vo Tat Thang)\[0][Master]Database"
*global maytinh "C:\Users\nguye\Dropbox (Vo Tat Thang)\[0][Master]Database"

global project "$maytinh\(3)Library_of_Project\(99)Mics\(13)Web-scraping"

global dataraw  "$project\DATARAW"
global datatemp "$project\DATATEMP"
global datades  "$project\DATADES"

global datapro "$maytinh\(1)Library_of_Data\(1)Proccessed_Data"
*===============================================================================


use  "$datapro\total_fish_export_VN.dta", clear

*===============================================================================
*Analyze fish production sector=================================================
use "$datades\price_stock_VN.dta", clear

keep if subsector == 10
*keep if year >= 2012
 
keep if inlist(stock_code,"AAM" ///	Công ty Cổ phần Thủy sản Mekong
		,"ABT" /// Công ty Cổ phần Xuất nhập khẩu Thủy sản Bến Tre
		,"ACL" /// Công ty Cổ phần Xuất Nhập Khẩu Thủy sản Cửu Long An Giang
		,"AGF" /// Công ty Cổ phần Xuất nhập khẩu Thủy sản An Giang
		,"AGM" /// Công ty Cổ phần Xuất Nhập Khẩu An Giang 
		,"CMX") /// Công ty Cổ phần Chế biến Thủy sản và Xuất nhập khẩu Cà Mau
	| inlist(stock_code,"DAT" /// Công ty Cổ phần Đầu tư Du lịch và Phát triển Thủy sản 
		,"ICF" /// Công ty Cổ phần Đầu tư Thương mại Thủy sản 
		,"VHC" /// Công ty Cổ phần Vĩnh Hoàn 
		,"ANV" /// Công ty Cổ phần Nam Việt 
		,"FMC" /// Công ty Cổ phần Thực phẩm Sao Ta 
		,"HVG" /// Công ty Cổ phần Hùng Vương 
		,"TS4") // Công ty Cổ phần Thủy sản số 4

gen reporter_iso = "VNM"		
merge m:1 reporter_iso year using "$datapro\total_fish_export_VN.dta"		
		
duplicates drop stock_code year week, force
drop price_close price_open price_high price_low volume date day

 
global type connected 
global y price_close_year
global x year
global mlabel mlabel(stock_code) mlabp(6)

twoway ($type $y $x if stock_code == "AAM", sort $mlabel) ///
	($type $y $x if stock_code == "ABT", sort $mlabel) ///
	($type $y $x if stock_code == "ACL", sort $mlabel)  ///
	($type $y $x if stock_code == "AGF", sort $mlabel)  ///
	($type $y $x if stock_code == "AGM", sort $mlabel)  ///
	($type $y $x if stock_code == "CMX", sort $mlabel)   ///
	($type $y $x if stock_code == "DAT", sort $mlabel)   ///
	($type $y $x if stock_code == "ICF", sort $mlabel)   ///
	($type $y $x if stock_code == "VHC", sort $mlabel)   ///
	($type $y $x if stock_code == "ANV", sort $mlabel)   ///
	($type $y $x if stock_code == "FMC", sort $mlabel)   ///
	($type $y $x if stock_code == "HVG", sort $mlabel)   ///
	($type $y $x if stock_code == "TS4", sort $mlabel)   ///
	($type trade_val $x if stock_code == "TS4", sort yaxis(2)),   ///
	legend(on ///
           row(4) order(1 "AAM" 2 "ABT" 3 "ACL" 4 "AGF" ///
	                    5 "AGM" 6 "CMX" 7 "DAT" 8 "ICF" ///
						9 "VHC" 10 "ANV" 11 "FMC" 12 "HVG" 13 "TS4")) 
	*xscale(r(1 12)) xlabel(1(1)12) ///
 
help color
twoway (scatter volume_week week if stock_code == "DAT", sort color(blue)) /// 
	(scatter volume_week week if stock_code == "VHC", sort color(green)) ///	
	(connected price_high_week week if stock_code == "DAT", sort yaxis(2) color(blue)) ///
	(connected price_high_week week if stock_code == "VHC", sort yaxis(2) color(green)), ///
	legend(on ///
           row(4))  
		   
		   help bar
 