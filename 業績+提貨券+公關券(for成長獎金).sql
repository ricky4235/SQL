select a.日期,a.年,a.月,a.月日,a.店號,a.門市,a.縣市,a.區域,a.金額 "業績",isnull(sum(b.提貨券金額),0) "公關+提貨券金額"
from

(select i.sdate "日期",substring(i.sdate,1,4) "年",substring(i.sdate,5,4) "月日", substring(i.sdate,5,2) "月", substring(i.sdate,7,2) "日",
       substring(i.sdate,5,2)+posc.code "月店號" , i.sdate+posc.code "日店號",
       posc.code "店號", posc.name "門市", substring(w.address,1,3) "縣市",
       case  when substring(w.address,1,3) in('台北市','新北市','宜蘭縣') then '北區' 
             when substring(w.address,1,3) in('桃園縣','桃園市','新竹市','新竹縣','彰化市','彰化縣','台中市') then '中區' 
             when substring(w.address,1,3) in('嘉義市','台南市','高雄市','屏東縣') then '南區' end "區域",
       isnull(sum(pd.exchangesum),0) "金額"
from dbo.POS_SaleIndex as i, dbo.POS_EosConfig as eosc,
     dbo.POS_PosConfig as posc, dbo.PIS_Warehouse w,
     dbo.POS_PayDetails as pd, dbo.POS_PayWay as pw
where i.cashregisterserno=eosc.serno
  and eosc.SalePointSerNo=posc.SerNo
  and posc.warehouseserno=w.serno
  and pd.SaleIndexSerNo = i.SerNo
  and pd.PayWaySerNo = pw.serno
  and pw.name in ('現金','信用卡')
  --and i.sdate between '20170101' and '20180930'
  --and substring(i.sdate,5,4) between '0101' and '1010'
  and posc.code like '0AC%'
group by i.sdate, posc.code, posc.name, substring(w.address,1,3)
 ) a

left join

(select eosc.Code "店號",w.[Name] "店櫃",i.SDate "使用日期", i.SDate+eosc.Code "日店號",cp.[No] "提貨券編碼", cp.[Value] "提貨券金額",i.UseCouponTotal "提貨券總金額"
from dbo.DCS_Coupon as cp,dbo.POS_SaleIndex as i,dbo.POS_EosConfig as eosc,dbo.POS_PosConfig as posc,dbo.PIS_Warehouse as w
where   i.SerNo = cp.SaleIndexSerNo
  and i.cashregisterserno=eosc.serno
  and eosc.SalePointSerNo=posc.SerNo
  and posc.warehouseserno=w.serno
  --and i.SDate between '20180925' and '20180930'
  ) b

on a.日店號=b.日店號
where a.月日 between '1001' and '1031'
and a.年 in('2017','2018')
group by a.日期,a.年,a.月,a.月日,a.店號,a.門市,a.縣市,a.區域,a.金額
order by a.年,a.日期,a.店號