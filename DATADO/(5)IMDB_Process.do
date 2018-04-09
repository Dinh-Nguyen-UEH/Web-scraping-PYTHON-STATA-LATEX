*===============================================================================
*Set global path================================================================
global maytinh "D:\Dropbox (Vo Tat Thang)\[0][Master]Database"
global maytinh "C:\Users\nguye\Dropbox (Vo Tat Thang)\[0][Master]Database"

global project "$maytinh\(3)Library_of_Project\(99)Mics\(13)Web-scraping"

global dataraw "$project\DATARAW"
global datades "$project\DATADES"
*===============================================================================

*===============================================================================
*Data cleaning==================================================================
import excel using "$dataraw\movie_data.xlsx", clear ///
                                               firstrow 
 
drop A

gen type = .	

foreach X in "Reality-TV" ///
             "Talk-Show" ///
             "News" ///
             "Documentary" ///
             "Action" ///
             "Adventure" ///
             "Biography" ///
             "Comedy" ///
             "Crime" ///
             "Drama" ///
             "Family" ///
             "Fantasy" ///
             "History" ///
             "Horror" ///
             "Mystery" ///
             "Romance" ///
             "Sci-Fi" ///
             "Thriller" ///
             "War" ///
             "Western" ///
             "Music" ///
             "Sport" ///
             "Animation" ///
             "Musical" ///
             "Short" {

	local x = strtoname("`X'")
	gen genre_`x' = .
	replace genre_`x' = 1 if strmatch(genre, "*`X'*") == 1 
	recode genre_`x' (. = 0)
	
	la var genre_`x' "Genre: `x'"
	
}
*
			 
forval year = 2000(1)2018 {

replace type = 0 if strmatch(year, "*(`year')") == 1
replace type = 1 if strmatch(year, "*(`year' Video Game)") == 1
replace type = 2 if strmatch(year, "*(`year' TV Special)") == 1
replace type = 3 if strmatch(year, "*(`year' TV Short)") == 1
replace type = 4 if strmatch(year, "*(`year' TV Movie)") == 1
replace type = 5 if strmatch(year, "*(`year' Video)") == 1
replace type = 6 if strmatch(year, "*(`year'–????)") == 1
replace type = 6 if strmatch(year, "*(`year'– )") == 1
replace type = 6 if strmatch(certificates, "*TV*") == 1

replace year = "`year'" if strmatch(year, "*(`year')") == 1
replace year = "`year'" if strmatch(year, "*(`year' Video Game)") == 1
replace year = "`year'" if strmatch(year, "*(`year' TV Special)") == 1
replace year = "`year'" if strmatch(year, "*(`year' TV Short)") == 1
replace year = "`year'" if strmatch(year, "*(`year' TV Movie)") == 1
replace year = "`year'" if strmatch(year, "*(`year' Video)") == 1
replace year = "`year'" if strmatch(year, "*(`year'–????)") == 1
replace year = "`year'" if strmatch(year, "*(`year'– )") == 1

}
*
la var type "Type"

la def label_type 0 "Movie" ///
                  1 "Video Game" ///
                  2 "TV Special" ///
				  3 "TV Short" ///
				  4 "TV Movie" ///
				  5 "Video" ///
				  6 "TV Shows"
la val type label_type				  
  
la def label_yes_no 0 "No" 1 "Yes"
la val genre_* label_yes_no 
  
*Destring int variables
replace runtime = subinstr(runtime," min","",.)
replace runtime = subinstr(runtime,",","",.)
replace gross = subinstr(gross,",","",.)
replace imdb = subinstr(imdb,".","",.)
destring votes runtime year gross imdb metascore, replace 

replace gross = gross/10^6

*Trim string variables
replace genre = strtrim(genre) 


*Drop not movie
keep if inlist(type ///
              ,0 /// Movie
              )
			  
foreach X of varlist genre_Reality_TV ///
                     genre_Talk_Show ///
					 genre_News ///
					 genre_Documentary ///
					 genre_Short {

	drop if `X' == 1

}
*

drop if runtime == .
drop if runtime >= 500
			   
compress

save "$datades\movie_data_cleaned.dta", replace	 
