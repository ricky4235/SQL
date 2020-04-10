select eosc.Code "店號",w.[Name] "店櫃",i.SDate "使用日期", i.SDate+eosc.Code "日店號",cp.[No] "提貨券編碼",
       cp.[Value] "提貨券金額",i.UseCouponTotal "提貨券總金額",i.SaleNo "單號" ,eosc.Code+i.SaleNo "店單號"
from dbo.DCS_Coupon as cp,dbo.POS_SaleIndex as i,dbo.POS_EosConfig as eosc,dbo.POS_PosConfig as posc,dbo.PIS_Warehouse as w
where   i.SerNo = cp.SaleIndexSerNo
  and i.cashregisterserno=eosc.serno
  and eosc.SalePointSerNo=posc.SerNo
  and posc.warehouseserno=w.serno
  and cp.[No] like 'DRP%'
  --and i.SDate between '20180925' and '20180930'