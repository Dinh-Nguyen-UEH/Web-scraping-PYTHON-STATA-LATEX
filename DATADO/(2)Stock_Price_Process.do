*===============================================================================
*Set global path================================================================ 
global maytinh "D:\Dropbox (Vo Tat Thang)\[0][Master]Database"
*global maytinh "C:\Users\nguye\Dropbox (Vo Tat Thang)\[0][Master]Database"

global project "$maytinh\(3)Library_of_Project\(99)Mics\(13)Web-scraping"

global dataraw  "$project\DATARAW\stock_data"
global datatemp "$project\DATATEMP"
global datades  "$project\DATADES"
*===============================================================================

local i = 1
foreach stock_code in ///
BIC ///
BMI ///
BVH ///
PGI ///
AGR ///
APG ///
BSI ///
FIT ///
FTS ///
HAG ///
HCM ///
OGC ///
SSI ///
TVS ///
BID ///
CTG ///
EIB ///
MBB ///
STB ///
VCB ///
LIX ///
AAM ///
ABT ///
ACL ///
AGF ///
AGM ///
ANV ///
BBC ///
BHN ///
CLC ///
CMX ///
DAT ///
FMC ///
GTN ///
HLG ///
HNG ///
HVG ///
ICF ///
IDI ///
KDC ///
LAF ///
LSS ///
MSN ///
NAF ///
NSC ///
PAN ///
SAB ///
SBT ///
SCD ///
SSC ///
TAC ///
TS4 ///
VCF ///
VHC ///
VNM ///
BTP ///
BWE ///
CHP ///
CLW ///
DRL ///
GAS ///
KHP ///
NT2 ///
PGD ///
PPC ///
S4A ///
SBA ///
SHP ///
SII ///
SJD ///
TBC ///
TDW ///
TMP ///
UIC ///
VSH ///
DCL ///
DHG ///
DMC ///
IMP ///
OPC ///
PME ///
SJF ///
SPM ///
TRA ///
VDP ///
JVC ///
VMD ///
ASP ///
CNG ///
GSP ///
PGC ///
PJT ///
PLX ///
PVD ///
PVT ///
PXS ///
PXT ///
DGW ///
FPT ///
TIE ///
CMG ///
CMT ///
ELC ///
HDB ///
SGT ///
VCI ///
VND ///
VPB ///
AST ///
CTF ///
DAH ///
DSN ///
HOT ///
RIC ///
STT ///
SVT ///
TCT ///
VNG ///
CMV ///
COM ///
HAX ///
HTL ///
MWG ///
SFC ///
SVC ///
CSM ///
DRC ///
PAC ///
PHR ///
SRC ///
TMT ///
TNC ///
ADS ///
EVE ///
FTM ///
GDT ///
GIL ///
GMC ///
KMR ///
PNJ ///
SAV ///
SBV ///
STK ///
TCM ///
TTF ///
TVT ///
VTB ///
AMD ///
BCE ///
BCG ///
BMP ///
BRC ///
BTT ///
C32 ///
C47 ///
CAV ///
CCI ///
CDC ///
CDO ///
CEE ///
CTD ///
DAG ///
DIG ///
DLG ///
DQC ///
EMC ///
FCN ///
GEX ///
HAS ///
HBC ///
HCD ///
HDG ///
HHS ///
HID ///
HTI ///
HU1 ///
HU3 ///
IJC ///
ITA ///
L10 ///
LCG ///
LGC ///
LGL ///
LM8 ///
MCG ///
MDG ///
PC1 ///
PET ///
PIT ///
PNC ///
PPI ///
PTC ///
PXI ///
RAL ///
REE ///
ROS ///
SAM ///
SC5 ///
SHA ///
SHI ///
SMA ///
SRF ///
TCD ///
TCH ///
TCR ///
THG ///
THI ///
TIP ///
TNA ///
TSC ///
TV1 ///
TYA ///
UDC ///
VHG ///
VNE ///
VPG ///
VRC ///
VSI ///
CII ///
CLL ///
DVP ///
GMD ///
HAH ///
HTV ///
MHC ///
NCT ///
PDN ///
SFI ///
SKG ///
STG ///
TCL ///
TCO ///
TMS ///
VIP ///
VJC ///
VNL ///
VNS ///
VOS ///
VSC ///
VTO ///
APC ///
ITD ///
ST8 ///
TLG ///
AAA ///
ACC ///
ATG ///
BFC ///
BMC ///
CSV ///
CTI ///
CVT ///
DCM ///
DHA ///
DHC ///
DHM ///
DIC ///
DPM ///
DPR ///
DTL ///
DTT ///
DXV ///
FCM ///
GTA ///
HAI ///
HAP ///
HII ///
HMC ///
HPG ///
HRC ///
HSG ///
HT1 ///
HVX ///
KPF ///
KSA ///
KSB ///
KSH ///
LBM ///
LCM ///
MCP ///
NAV ///
NKG ///
NNC ///
PLP ///
POM ///
PTB ///
QBS ///
RDP ///
SFG ///
SMC ///
SVI ///
TLH ///
TNT ///
TPC ///
TRC ///
VAF ///
VFG ///
VID ///
VIS ///
VPK ///
VPS ///
ASM ///
CCL ///
CIG ///
CLG ///
D2D ///
DRH ///
DTA ///
DXG ///
FDC ///
FLC ///
HAR ///
HDC ///
HQC ///
HTT ///
ITC ///
KAC ///
KBC ///
KDH ///
KHA ///
LDG ///
LHG ///
NBB ///
NLG ///
NTL ///
NVL ///
NVT ///
PDR ///
PTL ///
QCG ///
SCR ///
SGR ///
SJS ///
SZL ///
TDC ///
TDH ///
TEG ///
TIX ///
VIC ///
VPH ///
VRE {

	cap import delimited ///
		using "$dataraw\historical-price-`stock_code'010120083032018.csv", ///
		clear ///
		varnames(1) 

	if _rc == 601 {
	
		dis "Processing: `stock_code', number `i'"
		dis "This stock (`stock_code') has no price data"
		continue
	
	}
	else { 
	
		if `i' == 1 {
	
			save "$datades\price_stock_VN.dta", replace
	
		}
		else { 
	
			dis "Processing: `stock_code', number `i'"
			
			qui append using "$datades\price_stock_VN.dta"
	
			qui save "$datades\price_stock_VN.dta", replace
	
	
		}
	}
	*
	
	local i = `i' +1
	
}
*

*Rename variable
ren ticker stock_code
foreach X of varlist open close high low {

	ren `X' price_`X' 

}
* 
la var price_open "Open price (thous.)"
la var price_close "Close price (thous.)"
la var price_high "High price (thous.)"  
la var price_low "Low price (thous.)" 
la var stock_code "Stock code"

*Rescale trading volume value
replace volume = volume / 1000 
 la var volume "Traded volume (thous.)"

*Format date for date variables  
ren date date_string
gen date = date(date_string,"DMY",2050)  
 la var date "Date"
 format date %d  
 
gen month_string = substr(date_string,strpos(date_string,"/")+1,10) 
gen year_string = substr(month_string,strpos(month_string,"/")+1,10) 

gen week_temp = week(date)
tostring week_temp, replace
gen week_string = week_temp + "/" + year_string 

 
gen day = day(date)
gen week = weekly(week_string,"WY",2015)
 format week %tw  
gen month = monthly(month_string,"MY",2015)
 format month %tm  
gen year = year(date)
 la var day "Day"
 la var week "Week"
 la var month "Month"
 la var year "Year"
 
drop *_string week_temp
 
order stock_code date year month week day price_*  
 
*Create mean variable by week, month and year==========
foreach type in "year" "year month" "year month week" {

	if "`type'" == "year month" {
	
		local name = "month"
	
	}
	else if "`type'" == "year month week" {
	
		local name = "week"
	
	}
	else {
	
		local name = "year"
	
	}
	*
	

	foreach X of varlist price_close price_open price_high price_low volume {

		bysort stock_code `type': egen `X'_`name' = mean(`X')
	
		local label: variable label  `X'
		la var `X'_`name' "Mean `label' by `name'"
 
	}
	*	

}
* 
 
sort date volume
 
merge m:1 stock_code using "$datades\sector_company_data_cleaned.dta"
 drop if _merge == 2
 drop _merge*

compress
 
la data "Vietnam stock market prices data"	
save "$datades\price_stock_VN.dta", replace
*===============================================================================
 
 
 
 