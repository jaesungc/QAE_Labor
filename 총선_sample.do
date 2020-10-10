cd "D:\1 SKKU 강의\4 QAE_노동\Quiz"

*************
** Cleaning
*************

clear
import excel "개표상황(투표구별)_강남구갑.xlsx", sheet("sheet1")
drop in 1/6
destring _all, replace

rename A 읍면동명
rename B 투표구명
rename C 선거인수
rename D 투표수
rename E cand1
rename F cand2
rename G cand3
rename H cand4
rename Z 계
rename AA 무효투표수
rename AB 기권수

drop AC
drop if 읍면동명=="합계"
drop if 읍면동명=="거소·선상투표"
drop if 읍면동명=="관외사전투표"
drop if 읍면동명=="국외부재자투표" 
drop if 읍면동명=="잘못 투입·구분된 투표지"

compress
save data_q12, replace


use data_q12, replace
keep if 투표구명=="소계" | 투표구명=="관내사전투표"
keep 읍면동명 투표구명 투표수

gen 관내사전투표=투표수[_n+1] if 투표구명=="소계"
keep if 투표구명=="소계"
gen p=관내사전투표/투표수
gsort -p
list

// 역삼1동, 0.129


* Q2.
use data_q12, replace
drop if 투표구명=="소계"
drop if 투표구명=="관내사전투표"
gen p=투표수/선거인수
gsort -p
list 투표구명 p in 1/2

// 역삼2동제6투 .5717045
// 압구정동제5투 .5615751 


clear
foreach i in 강남구갑 강남구병 강남구을 서초구갑 서초구을 {
			
	clear
	import excel "개표상황(투표구별)_`i'.xlsx", sheet("sheet1")
	drop in 1/6
	destring _all, replace
	gen district="`i'"
	order district
	save `i', replace

}


clear
foreach i in 강남구갑 강남구병 강남구을 서초구갑 서초구을 {
	append using `i'
}
rename A 읍면동명
rename B 투표구명
rename C 선거인수
rename D 투표수
rename E cand1
rename F cand2
rename G cand3
rename H cand4
rename Z 계
rename AA 무효투표수
rename AB 기권수

drop AC
drop if 읍면동명=="합계"
drop if 읍면동명=="거소·선상투표"
drop if 읍면동명=="관외사전투표"
drop if 읍면동명=="국외부재자투표" 
drop if 읍면동명=="잘못 투입·구분된 투표지"

save temp, replace


* 읍면동명 만들기 way 1
use temp, replace
replace 읍면동명=읍면동명[_n-1] if 읍면동명==""

drop if 투표구명=="소계"
drop if 투표구명=="관내사전투표"
drop I-Y
save master, replace

/*
* 읍면동명 만들기 way 2
use temp, replace
drop if 투표구명=="소계"
drop if 투표구명=="관내사전투표"
split 투표구명, p("제")
rename 투표구명1 site
tab 투표구명2
drop 투표구명2
tab site
unique site


* 읍면동명 만들기 way 3
use temp, replace
drop if 투표구명=="소계"
drop if 투표구명=="관내사전투표"
gen site=regexr(투표구명, "제[0-9]투", "")
replace site=regexr(site, "제[0-9][0-9]투", "")
tab site
unique site
*/
