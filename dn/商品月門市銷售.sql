select substring(si.sdate,1,4) "年",substring(si.sdate,5,2) "月份",substring(si.sdate,5,4) "月日",l.name "大分類", m.name "中分類",s.name "小分類",eosc.Code "店號",posc.[Name] "門市",
     sum(sd.amount) "總銷售數", sum(sd.total) "總銷售額"
from dbo.PIS_Goods g, dbo.POS_SaleIndex as si, dbo.POS_SaleDetails as sd,
     dbo.PIS_GoodsLargeCategory as l, dbo.PIS_GoodsMiddleCategory as m,dbo.PIS_Color as c, dbo.PIS_Size as size,
     dbo.PIS_GoodsLittleCategory as s, dbo.POS_EosConfig as eosc, dbo.POS_PosConfig as posc

where si.SerNo = sd.saleindexSerNo
  and g.SerNo = sd.goodsserno
  and g.LargeCategorySerNo = l.SerNo
  and g.MiddleCategorySerNo = m.SerNo
  and g.SmallCategorySerNo = s.SerNo
  and si.cashregisterserno = eosc.serno
  and eosc.SalePointSerNo = posc.SerNo
  and g.colorserno=c.SerNo
  and g.sizeserno=size.SerNo
  and si.attribute<>'2'
  --and eosc.Code IN('0AC0006','0AC0048')
  --and substring(g.code,1,8) in('FWB2ZF22')
  --and substring(g.code,2,2) in('WL','WD','WK','WP','WS')
  --and substring(g.code,13,1) like '0'
  and substring(si.sdate,1,4) in('2017','2018')
  and substring(si.sdate,5,4) between '1101' and '1127'
  --and substring(si.sdate,5,2) IN('07','08','09','10')
  --and si.sdate between '20170601' and '20170630'
group by si.sdate,l.name, m.name,s.name,eosc.Code,posc.[Name]