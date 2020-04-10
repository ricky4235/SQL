select g.code "貨號",substring(g.code,1,1) "首碼",substring(g.code,1,8) "款號", substring(g.code,2,2) "中代",g.name "品名",
       isnull(voi.lastamount,0) "倉存",isnull(voi.TransNotInAmount,0) "在途",isnull(voi.lastamount,0)+isnull(voi.TransNotInAmount,0) "庫存",
       w.code "店櫃代號",w.name "門市",l.name "大分類",substring(g.code,2,2) "中代", mi.name "中分類",s.name "小分類" ,c.name "顏色", size.name as "size"
        from dbo.PIS_ViewInitialWarehouseAmountIncludeTransferAmount as voi, dbo.PIS_Goods as g,
             dbo.PIS_Warehouse as w,dbo.PIS_GoodsLargeCategory as l, dbo.PIS_GoodsMiddleCategory as mi, dbo.PIS_GoodsLittleCategory as s, dbo.PIS_Color as c, dbo.PIS_Size as size
        where voi.WarehouseSerNo = w.SerNo
          and g.LargeCategorySerNo = l.SerNo
          and g.MiddleCategorySerNo = mi.SerNo
          and g.SmallCategorySerNo = s.SerNo
          and g.colorserno=c.SerNo
          and g.sizeserno=size.SerNo
          and voi.GoodsSerNo = g.SerNo
          and w.Code like '0A%'
          --and substring(g.code,1,8) like '%'
          and g.code like 'PWL3BA%'
        order by g.code,w.code