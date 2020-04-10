select s.月份, s.貨號,s.款號,s.款色,s.品名,s.大分類,s.中分類,s.中,s.小分類,s.顏色,s.尺寸,s.首碼,s.一五六 ,s.首發日,s.價格,max(s.總銷售數) "max月銷量",s.合計庫存
from 
(select substring(si.sdate,1,4) "年",substring(si.sdate,5,2) "月份",l.name "大分類", m.name "中分類",s.name "小分類",c.name "顏色", size.name as "尺寸",
     g.code "貨號",substring(g.code,2,2) "中", substring(g.code,1,8) "款號", g.name "品名", outdate.首發日, sum(sd.amount) "總銷售數", sum(sd.total) "總銷售額",g.TaxedListPrice "價格",
     substring(g.code,1,1) "首碼", substring(g.code,5,2) "五六碼", substring(g.code,1,1)+substring(g.code,5,2) "一五六", substring(g.code,13,1) "末碼",substring(g.code,1,10) "款色",
     isnull(hd.總倉庫存,0)+isnull(st.門市庫存,0) "合計庫存"
from dbo.PIS_Goods g
    left outer join
       (select vt.Code_g,vt.Name_g ,min(vt.sdate) "首發日"  
        from dbo.PIS_ViewTransfer vt
        where vt.TransferOutWarehouseCode like '0A'
        group by vt.Code_g,vt.Name_g 
       ) outdate
    on g.code=outdate.Code_g
      left outer join
       (select g.code, isnull(voi.lastamount,0) + isnull(voi.TransNotInAmount,0) "總倉庫存"
        from dbo.PIS_ViewInitialWarehouseAmountIncludeTransferAmount as voi, dbo.PIS_Goods as g,
             dbo.PIS_Warehouse as w
             where voi.WarehouseSerNo = w.SerNo
               and voi.GoodsSerNo = g.SerNo
               and w.Code  = '0A'
       ) as hd
    on g.code=hd.code
  left outer join
       (select g.code, sum(isnull(voi.lastamount,0)) + sum(isnull(voi.TransNotInAmount,0)) "門市庫存"
        from dbo.PIS_ViewInitialWarehouseAmountIncludeTransferAmount as voi, dbo.PIS_Goods as g,
             dbo.PIS_Warehouse as w
        where voi.WarehouseSerNo = w.SerNo
          and voi.GoodsSerNo = g.SerNo
          and w.Code like '0AC%'
        group by g.code
       ) as st
    on g.code=st.code
    

     ,dbo.POS_SaleIndex as si, dbo.POS_SaleDetails as sd,
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
  --and substring(g.code,1,8) in('LWK3YD03')
  and substring(g.code,2,2) in('WC')
  and substring(g.code,13,1) like '0'
  --and si.sdate between '20170101' and '20181025'
group by substring(si.sdate,1,4),substring(si.sdate,5,2),l.name, m.name,s.name, g.code,g.goodsstylecode, g.name, outdate.首發日,c.name,size.name,g.TaxedListPrice,hd.總倉庫存,st.門市庫存  ) s
group by  s.月份,s.款號,s.款色, s.貨號,s.品名,s.大分類,s.中分類,s.中,s.小分類,s.顏色,s.尺寸,s.首碼,s.一五六,s.首發日,s.價格,s.合計庫存
