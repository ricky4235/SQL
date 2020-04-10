select 貨號,款色,品名,大分類,中分類,中,小分類,顏色,尺寸,首碼,一五六,
            [01] as '一月', [02] as '二月', [03] as '三月', [04] as '四月', 
            [05] as '五月', [06] as '六月', [07] as '七月', [08] as '八月', 
            [09] as '九月', [10] as '十月', [11] as '十一月', [12] as '十二月' 
from

(select s.月份, s.貨號,s.款色,s.品名,s.大分類,s.中分類,s.中,s.小分類,s.顏色,s.尺寸,s.首碼,s.一五六 ,max(s.總銷售數) "max月銷量"
from 
(select substring(si.sdate,1,4) "年",substring(si.sdate,5,2) "月份",l.name "大分類", m.name "中分類",s.name "小分類",c.name "顏色", size.name as "尺寸",
     g.code "貨號",substring(g.code,2,2) "中", substring(g.code,1,8) "款號", g.name "品名", outdate.首發日, sum(sd.amount) "總銷售數", sum(sd.total) "總銷售額",
     substring(g.code,1,1) "首碼", substring(g.code,5,2) "五六碼", substring(g.code,1,1)+substring(g.code,5,2) "一五六", substring(g.code,13,1) "末碼",substring(g.code,1,10) "款色"
from dbo.PIS_Goods g, dbo.POS_SaleIndex as si, dbo.POS_SaleDetails as sd,
     dbo.PIS_GoodsLargeCategory as l, dbo.PIS_GoodsMiddleCategory as m,dbo.PIS_Color as c, dbo.PIS_Size as size,
     dbo.PIS_GoodsLittleCategory as s, dbo.POS_EosConfig as eosc, dbo.POS_PosConfig as posc,
       (select vt.Code_g,vt.Name_g ,min(vt.sdate) "首發日"  
        from dbo.PIS_ViewTransfer vt
        where vt.TransferOutWarehouseCode like '0A'
        group by vt.Code_g,vt.Name_g 
       ) outdate
where si.SerNo = sd.saleindexSerNo
  and g.SerNo = sd.goodsserno
  and g.LargeCategorySerNo = l.SerNo
  and g.MiddleCategorySerNo = m.SerNo
  and g.SmallCategorySerNo = s.SerNo
  and si.cashregisterserno = eosc.serno
  and eosc.SalePointSerNo = posc.SerNo
  and g.colorserno=c.SerNo
  and g.sizeserno=size.SerNo
  and g.code=outdate.料號
  and si.attribute<>'2'
  --and substring(g.code,1,8) in('LWE6A301','FWCABN15')
  and substring(g.code,2,2) in('WA','WB','WC','MA','MC')
  and substring(g.code,13,1) like '0'
  --and si.sdate between '20170101' and '20181025'
group by substring(si.sdate,1,4),substring(si.sdate,5,2),l.name, m.name,s.name, g.code,g.goodsstylecode, g.name, outdate.首發日,c.name,size.name  ) s
group by  s.月份,s.款色, s.貨號,s.品名,s.大分類,s.中分類,s.中,s.小分類,s.顏色,s.尺寸,s.首碼,s.一五六
) as mx

pivot
( sum(max月銷量)
for 月份 IN ([01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12])
) AS PivotTable