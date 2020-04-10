select ar.sdate "上班日", substring(ar.sdate,1,4) "年",substring(ar.sdate,5,4) "月日", substring(ar.sdate,5,2) "月", substring(ar.sdate,7,2) "日",
       pc.code "店號", pc.name "門市", emp.code "員編", emp.name "人員", x.店人力 ,
       ar.starttime "上班時間", ar.EndTime "下班時間" , ar.sdate+pc.code "日店號"
from dbo.HRS_AttendanceRecord as ar ,dbo.HRS_Employee as emp, dbo.POS_PosConfig as pc,

     (select ar.sdate, emp.code
      from dbo.HRS_AttendanceRecord as ar, dbo.HRS_Employee as emp
      where ar.EmployeeSerNo = emp.SerNo
      group by ar.sdate, emp.code) z  ,
      
      (select ar.sdate "日", pc.code "店號", count(emp.code) "店人力"
        from dbo.HRS_AttendanceRecord as ar, dbo.HRS_Employee as emp, dbo.POS_PosConfig as pc
        where ar.EmployeeSerNo = emp.SerNo
          and ar.SalePointSerNo = pc.serno
          and pc.code like '0AC%'
          and emp.code <> 'zz0001'
        group by ar.sdate, pc.code, pc.name ) x

where ar.EmployeeSerNo = emp.SerNo
  and ar.SalePointSerNo = pc.serno
  and ar.sdate = z.sdate
  and emp.code = z.code
  and ar.sdate = x.日
  and pc.code = x.店號
  and ar.sdate between '20180830' and '20180910'
  and pc.code like '0AC%'
  and emp.code <> 'zz0001'
group by ar.sdate, pc.code, pc.name, emp.code, emp.name, ar.starttime, ar.EndTime ,x.店人力
order by ar.sdate, pc.code
