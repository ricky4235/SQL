select substring(si.sdate,1,4) "銷售年",substring(si.sdate,5,2) "銷售月",si.sdate "銷售日期",substring(si.sdate,5,4) "月日",substring(si.sdate,7,2) "日", convert(varchar(13),si.saleno) "單號",
       posc.code "店號",posc.code+convert(varchar(13),si.saleno) "店單號", posc.name "門市", si.remark "備註", case si.attribute when '0' then '一般'
           when '1' then '訂金' when '2' then '尾款' else '其他' end "單別",
       g.code "貨號",substring(g.code,1,1) "首碼",substring(g.code,1,8) "款號",substring(g.code,1,10) "款色",g.name "品名",
       l.name "大分類",substring(g.code,2,2) "中代", mi.name "中分類",s.name "小分類" ,c.name "顏色", size.name as "size",
       sd.taxedlistprice "定價", sd.taxedsaleprice "售價",
       sd.Amount "銷售量", sd.total "銷售額", m.code "會員代號",m.membercardno "會員卡號", m.name "會員名稱", m.CellPhone,
       case m.sex when '0' then '女' when '1' then '男' when '2' then '公司' else '未填' end "性別",
       m.birthday, m.firstdate "會員發卡日", m.TotalConsume "會員累消",
       inv.invoiceno "發票號碼", si.saletotal "發票總額",si.time "銷售時間",
       m.homezipcode "ZIP",m.firstdate "發卡日", id.name "銷售員", id2.name "製表人"
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
  and si.sdate between '20181201' and '20190120'
  --and substring(si.sdate,5,4) between '0714' and '0802'
  --and substring(g.code,1,8) in ('PWL5BF01','PWL8BE01','PWL3BA01','PWL3BA02','PWL3BA03','PWL3BA04','PWL3BA05','PWL3BA06','PWL3BA07','PWL3BA08','PWL3BA09','PWL3BA10','PWL3BA11','PWL3BA12','PWL3BA13')
  --and posc.code like '0AC0041%'
  --and substring(g.code,2,2) like 'F%'
  --and substring(g.code,1,1) in('L','M','N','P')
  --and l.name like '寢具類'
  --and g.code like 'MFAA000%'
  and si.attribute <> '2'
order by posc.code,si.sdate  