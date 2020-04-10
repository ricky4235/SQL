select l.name "大分類", m.name "中分類",s.name "小分類", g.sellyear "銷售年",
  g.code "貨號",g.name "品名", c.name "顏色", size.name as "size",sum(iw.lastamount) "庫存數",
  sum(iw.InAmount) "總進", sum(isnull(iw.possellamount,0)) "累計銷售"
FROM dbo.PIS_Warehouse as w, dbo.PIS_InitialWarehouseAmount as iw, dbo.PIS_Goods as g,
     dbo.PIS_GoodsLargeCategory as l, dbo.PIS_GoodsMiddleCategory as m,
     dbo.PIS_GoodsLittleCategory as s, dbo.PIS_Color as c, dbo.PIS_Size as size
where iw.warehouseserno=w.serno
  and iw.goodsserno=g.serno
  and g.LargeCategorySerNo = l.SerNo
  and g.MiddleCategorySerNo = m.SerNo
  and g.SmallCategorySerNo = s.SerNo
  and g.colorserno=c.SerNo
  and g.sizeserno=size.SerNo
  and w.warehousetype in (1,3)
  and g.code LIKE 'P%'
group by l.name, m.name,s.name, g.sellyear,
  g.code,g.name, c.name, size.name
having sum(iw.lastamount) > '0'