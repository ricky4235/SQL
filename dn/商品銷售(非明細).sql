select substring(si.sdate,1,4) "銷售年",substring(si.sdate,5,2) "銷售月",si.sdate "銷售日期",substring(si.sdate,5,4) "月日",substring(si.sdate,7,2) "日",
       g.code "貨號",substring(g.code,1,1) "首碼",substring(g.code,1,8) "款號",g.name "品名",
       l.name "大分類",substring(g.code,2,2) "中代", mi.name "中分類",s.name "小分類" ,c.name "顏色", size.name as "size",
       sd.taxedlistprice "定價", sum(sd.Amount) "銷售量", sum(sd.total) "銷售額"
from dbo.POS_SaleIndex as si
  inner join dbo.POS_SaleDetails as sd
          on si.SerNo = sd.saleindexSerNo
  inner join dbo.POS_EosConfig as eosc
          on si.cashregisterserno = eosc.serno
  left outer  join dbo.INV_InvoiceNoDetails inv
          on si.StartInvoiceSerNo = inv.serno        
  left outer join dbo.UserID as id
          on si.salesserno = id.serno
  left outer join dbo.UserID as id2
          on si.museridserno = id2.serno
  left outer join dbo.POS_Member as m
          on si.MemberSerNo = m.serno
  , dbo.PIS_Goods as g, dbo.POS_PosConfig as posc
  ,  dbo.PIS_GoodsLargeCategory as l, dbo.PIS_GoodsMiddleCategory as mi, dbo.PIS_GoodsLittleCategory as s, dbo.PIS_Color as c, dbo.PIS_Size as size
where g.SerNo = sd.goodsserno
  and eosc.SalePointSerNo = posc.SerNo
  and g.LargeCategorySerNo = l.SerNo
  and g.MiddleCategorySerNo = mi.SerNo
  and g.SmallCategorySerNo = s.SerNo
  and g.colorserno=c.SerNo
  and g.sizeserno=size.SerNo
  and si.sdate between '20180701' and '20180927'
  --and sd.taxedlistprice in (880,1080)
  --and substring(si.sdate,5,4) between '0714' and '0812'
  --and substring(si.sdate,1,4) in('2017','2018')
  --and posc.code like '0AC0041%'
  --and substring(g.code,2,2) like 'WL'
  --and substring(g.code,1,1) like 'P'
  and g.code like 'PWL3BA%'
  --and substring(g.code,1,1) in('L','M','N','P')
  --and l.name like '寢具類'
  --and g.code like 'B052'
  and si.attribute <> '2'
group by si.sdate,g.code,g.name,l.name,mi.name,s.name,c.name,size.name,sd.taxedlistprice
order by si.sdate 
