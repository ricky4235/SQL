select substring(si.sdate,1,4) "年",substring(si.sdate,5,2) "月份",l.name "大分類", m.name "中分類",s.name "小分類",c.name "顏色", size.name as "尺寸",
     g.code "貨號",substring(g.code,2,2) "中", substring(g.code,1,8) "款號",substring(g.code,1,10) "款色", g.name "品名", outdate.首發日, sum(sd.amount) "總銷售數", sum(sd.total) "總銷售額",
     substring(g.code,1,1) "首碼", substring(g.code,5,2) "五六碼", substring(g.code,1,1)+substring(g.code,5,2) "一五六", substring(g.code,13,1) "末碼", g.TaxedListPrice "售價"
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
  and g.code=outdate.Code_g
  and si.attribute<>'2'
  --and substring(g.code,1,8) in('LWE6A301','FWCABN15')
  --and substring(g.code,2,2) in('HR','HS')
  --and substring(g.code,13,1) like '0'
  and si.sdate between '20180101' and '20181231'
group by substring(si.sdate,1,4),substring(si.sdate,5,2),l.name, m.name,s.name, g.code,g.goodsstylecode, g.name, outdate.首發日,c.name,size.name,g.TaxedListPrice 