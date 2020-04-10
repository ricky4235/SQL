select distinct si.sdate "銷售日" ,substring(si.sdate,1,4) "年",substring(si.sdate,5,4) "月日", substring(si.sdate,5,2) "月", substring(si.sdate,7,2) "日",
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
where g.SerNo = sd.goodsserno   /*where中的=也等同join的效果*/
  and eosc.SalePointSerNo = posc.SerNo
  --and si.sdate between '20180901' and '20180910'
  and substring(si.sdate,1,4) in ('2017','2018')
  and substring(si.sdate,5,4) between '0901' and '0930'
  and posc.code like '0AC%'
  and sd.amount > '0'
  and isnull(inv.isabandoned,'0') = '0'
  and si.attribute <> '2'
order by posc.code, si.sdate, inv.invoiceno

