select l.name "大分類", m.name "中分類",s.name "小分類",c.name "顏色", size.name as "尺寸",
     g.code "貨號",substring(g.code,2,2) "中", substring(g.code,1,8) "款號",substring(g.code,1,10) "款色", g.name "品名",g.TaxedListPrice "價格"
from dbo.PIS_Goods g,dbo.PIS_GoodsLargeCategory as l, dbo.PIS_GoodsMiddleCategory as m,dbo.PIS_Color as c, dbo.PIS_Size as size,
     dbo.PIS_GoodsLittleCategory as s
where  g.LargeCategorySerNo = l.SerNo
  and g.MiddleCategorySerNo = m.SerNo
  and g.SmallCategorySerNo = s.SerNo
  and g.colorserno=c.SerNo
  and g.sizeserno=size.SerNo
  --and substring(g.code,1,8) in('LWE6A301','FWCABN15')
  --and substring(g.code,2,2) in('WA')
  --and substring(g.code,13,1) like '0'
  --and si.sdate between '20181001' and '20181031'
