select distinct vd.LargeCategoryName "大分類", MiddleCategoryCode "中分類",vd.SmallCategoryName "小分類", vd.sellyear "銷售年",
       vd.code "料號", outdate.首發日, substring(vd.code,1,1) "首碼",substring(vd.code,1,8) "款號", substring(vd.code,2,2) "中代", 
       vd.name "品名", vd.colorname "Color", vd.sizename "Size",vd.taxedcostprice "成本",
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
  and substring(vd.code,2,2) in('HR')
  --and substring(vd.code,1,1) in('L','M','N','P')
  --and vd.code like 'PWL3BA%'