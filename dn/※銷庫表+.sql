select a.年,a.月份,b.大分類,b.中分類,b.小分類,b.顏色,b.尺寸,b.料號,a.中,b.款號,b.款色,b.品名,b.首發日,a.總銷售數,a.總銷售額,b.首碼,b.五六碼,b.一五六,b.末碼,
       b.售價, b.總倉庫存, b.門市庫存, b.合計庫存
from
(select substring(si.sdate,1,4) "年",substring(si.sdate,5,2) "月份",l.name "大分類", m.name "中分類",s.name "小分類",c.name "顏色", size.name as "尺寸",
     g.code "貨號",substring(g.code,2,2) "中", substring(g.code,1,8) "款號",substring(g.code,1,10) "款色", g.name "品名", sum(sd.amount) "總銷售數", sum(sd.total) "總銷售額",
     substring(g.code,1,1) "首碼", substring(g.code,5,2) "五六碼", substring(g.code,1,1)+substring(g.code,5,2) "一五六", substring(g.code,13,1) "末碼"
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
  and substring(g.code,1,8) in('PML6BE06')
  --and substring(g.code,2,2) in('HR','HS')
  --and substring(g.code,13,1) like '0'
  --and si.sdate between '20181001' and '20181031'
group by substring(si.sdate,1,4),substring(si.sdate,5,2),l.name, m.name,s.name, g.code,g.goodsstylecode, g.name,c.name,size.name 
) a
right join 
(select distinct vd.LargeCategoryName "大分類", MiddleCategoryCode "中分類",vd.SmallCategoryName "小分類", vd.sellyear "銷售年",
       vd.code "料號", outdate.首發日, substring(vd.code,1,8) "款號", substring(vd.code,2,2) "中代",
       substring(vd.code,1,10) "款色" ,substring(vd.code,1,1) "首碼", substring(vd.code,5,2) "五六碼",
       substring(vd.code,1,1)+substring(vd.code,5,2) "一五六", substring(vd.code,13,1) "末碼",
       vd.name "品名", vd.colorname "顏色", vd.sizename "尺寸",vd.taxedcostprice "成本",
       vd.taxedlistprice "售價", vd.specname "舊料號", hd.總倉庫存, st.門市庫存 , isnull(hd.總倉庫存,0)+isnull(st.門市庫存,0) "合計庫存"
from dbo.PIS_ViewGoodsData vd
  left outer join
       (select g.code, isnull(voi.lastamount,0) + isnull(voi.TransNotInAmount,0) "總倉庫存"
        from dbo.PIS_ViewInitialWarehouseAmountIncludeTransferAmount as voi, dbo.PIS_Goods as g,
             dbo.PIS_Warehouse as w
             where voi.WarehouseSerNo = w.SerNo
               and voi.GoodsSerNo = g.SerNo
               and w.Code  = '0A'
       ) as hd
    on vd.code=hd.code
  left outer join
       (select g.code, sum(isnull(voi.lastamount,0)) + sum(isnull(voi.TransNotInAmount,0)) "門市庫存"
        from dbo.PIS_ViewInitialWarehouseAmountIncludeTransferAmount as voi, dbo.PIS_Goods as g,
             dbo.PIS_Warehouse as w
        where voi.WarehouseSerNo = w.SerNo
          and voi.GoodsSerNo = g.SerNo
          and w.Code like '0AC%'
        group by g.code
       ) as st
    on vd.code=st.code
  left outer join
       (select vt.Code_g,vt.Name_g ,min(vt.sdate) "首發日"  
        from dbo.PIS_ViewTransfer vt
        where vt.TransferOutWarehouseCode like '0A'
        group by vt.Code_g,vt.Name_g 
       ) outdate
    on vd.code = outdate.Code_g
where vd.isstop = '0'
  --and substring(vd.code,2,2) LIKE 'WB'
  and substring(vd.code,1,8) in('PML6BE06')
  --and substring(vd.code,1,1) in('L','M','N','P')
  --and vd.code like 'PWL3BA%'
  ) b
on a.貨號=b.料號
