cd "D:\Google Drive\QAE_2020F_노동\Stata\"

** Cleaning 
clear
global year=2015
import excel "${year}년_교양과목 성적평가 분포.xls", sheet("Sheet1")
drop in 1/6
destring _all, replace

keep B C E G I

rename B college_name
rename C semester
rename E full_gpa
rename G p_Aplus
rename I p_A

save gpa_dist_${year}, replace


** Analysis
use gpa_dist_${year}, replace



** Q1. FHS Example

** (a)
use fhs, replace
su
tab

* Ans: 732

** (b)
collapse
egen

* Ans:



