/*from A join B on A.code=B.code 
等同
  from A, B where A.code=B.code*/

select ar.sdate "上班日", pc.code "店號", pc.name "門市", emp.code "員編", emp.name "人員",
       ar.starttime "上班時間", ar.EndTime "下班時間" , ar.sdate+pc.code "日店號"
from dbo.HRS_AttendanceRecord as ar ,dbo.HRS_Employee as emp, dbo.POS_PosConfig as pc,
     (select ar.sdate, emp.code
      from dbo.HRS_AttendanceRecord as ar, dbo.HRS_Employee as emp
      where ar.EmployeeSerNo = emp.SerNo
      group by ar.sdate, emp.code) z  
where ar.EmployeeSerNo = emp.SerNo
  and ar.SalePointSerNo = pc.serno
  and ar.sdate = z.sdate
  and emp.code = z.code
  and ar.sdate between '20180910' and '20180910'
  and pc.code like '0AC%'
order by ar.sdate, pc.code

-----------------------------------------------------------------------------------
等同
-----------------------------------------------------------------------------------
select ar.sdate "上班日", pc.code "店號", pc.name "門市", emp.code "員編", emp.name "人員",
       ar.starttime "上班時間", ar.EndTime "下班時間" , ar.sdate+pc.code "日店號"
from dbo.HRS_AttendanceRecord as ar
  left outer join
     (select ar.sdate, emp.code
      from dbo.HRS_AttendanceRecord as ar, dbo.HRS_Employee as emp
      where ar.EmployeeSerNo = emp.SerNo
      group by ar.sdate, emp.code) z
      on ar.sdate = z.sdate
    ,dbo.HRS_Employee as emp, dbo.POS_PosConfig as pc
where ar.EmployeeSerNo = emp.SerNo
  and ar.SalePointSerNo = pc.serno
  and emp.code = z.code
  and ar.sdate between '20180910' and '20180910'
  and pc.code like '0AC%'
order by ar.sdate, pc.code