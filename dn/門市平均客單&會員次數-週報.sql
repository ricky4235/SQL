select a.銷售日 , a.年, a.月日 , a.月 , a.日 , a.店號 , a.門市 , a.發票起 , a.發票總額 , b.會員代號
from
(select distinct si.sdate "銷售日" ,substring(si.sdate,1,4) "年",substring(si.sdate,5,4) "月日", substring(si.sdate,5,2) "月", substring(si.sdate,7,2) "日",
        posc.code "店號",posc.name "門市", si.saleno,
       inv.invoiceno "發票起", inv2.invoiceno "發票迄", si.saletotal "發票總額"
from dbo.POS_SaleIndex as si
  inner join dbo.POS_SaleDetails as sd
          on si.SerNo = sd.saleindexSerNo
  inner join dbo.POS_EosConfig as eosc
          on si.cashregisterserno = eosc.serno
  inner join dbo.UserID as id
          on si.salesserno = id.serno
  inner join dbo.INV_InvoiceNoDetails as inv
          on si.StartInvoiceSerNo = inv.serno
  inner join dbo.INV_InvoiceNoDetails as inv2
          on si.StopInvoiceSerNo = inv2.serno
  , dbo.PIS_Goods as g, dbo.POS_PosConfig as posc
where g.SerNo = sd.goodsserno
  and eosc.SalePointSerNo = posc.SerNo
  --and si.sdate between '20180901' and '20180910'
  --and substring(si.sdate,1,4) in ('2017','2018')
  --and substring(si.sdate,5,4) between '0901' and '0930'
  --and posc.code like '0AC%'
  and sd.amount > '0'
  and isnull(inv.isabandoned,'0') = '0'
  and si.attribute <> '2'
) a

left join

(select distinct m.code "會員代號",m.membercardno "會員卡號", m.name "會員名稱",
       inv.invoiceno "發票號碼", si.saletotal "發票總額"
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
  --and si.sdate between '20180720' and '20180731'
  --and substring(si.sdate,5,4) between '0714' and '0802'
  --and substring(si.sdate,1,4) in('2017','2018')
  --and posc.code like '0AC0041%'
  --and substring(g.code,2,2) like 'F%'
  --and substring(g.code,1,1) in('L','M','N','P')
  --and l.name like '寢具類'
  --and g.code like 'MFAA000%'
  and si.attribute <> '2'
  ) b
  on a.發票起= b.發票號碼
where a.年 like '2018'
and a.月 like '10'