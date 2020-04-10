select si.sdate "銷售日", si.time "銷售時間", g.code"貨號",g.name"品名", si.attribute "單別", posc.code "店號",
  posc.name "門市", id.name "銷售員",sd.taxedsaleprice "售價", sd.amount "銷售數",
  sd.total "銷售額", sd.realdiscount "折扣", inv.invoiceno "發票號碼", si.saletotal "發票總額",
  m.name "會員名稱", m.membercardno "卡號", m.code "會員代號", case m.sex 
  when '0' then '女' when '1' then '男' when '2' then '公司' else '未填' end "性別",
  m.birthday "生日",year(getdate())-left(m.Birthday,4) "年齡" , m.firstdate "發卡日", m.TotalConsume "累積消費", sd.promoteserno
from dbo.POS_SaleIndex as si
  inner join dbo.POS_SaleDetails as sd
          on si.SerNo = sd.saleindexSerNo
  inner join dbo.POS_EosConfig as eosc
          on si.cashregisterserno = eosc.serno
  inner join dbo.UserID as id
          on si.salesserno = id.serno
  inner join dbo.POS_Member as m
          on si.MemberSerNo = m.serno
  inner join dbo.INV_InvoiceNoDetails inv
          on si.StartInvoiceSerNo = inv.serno
  , dbo.PIS_Goods as g, dbo.POS_PosConfig as posc
where g.SerNo = sd.goodsserno
  and eosc.SalePointSerNo = posc.SerNo
  --and g.code in('MFAA0001','MFAA0002')
  and si.sdate between '20180601' and '20180630'
  and posc.code like '0AC0041'
  and si.attribute <> '2'
order by posc.code,si.sdate, si.time