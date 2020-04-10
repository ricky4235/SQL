select k.大分類 ,k.中分類 ,k.Rank "排名",k.小分類 ,k.顏色 ,k.款色 ,k.總銷售數 ,k.總銷售額 
from
(select substring(si.sdate,1,4) "年",substring(si.sdate,5,2) "月份",l.name "大分類", m.name "中分類",s.name "小分類",c.name "顏色",
     substring(g.code,1,10) "款色", sum(sd.amount) "總銷售數", sum(sd.total) "總銷售額",
     rank() over (partition by l.name , m.name order by sum(sd.amount) desc) "Rank"
from dbo.PIS_Goods g, dbo.POS_SaleIndex as si, dbo.POS_SaleDetails as sd,
     dbo.PIS_GoodsLargeCategory as l, dbo.PIS_GoodsMiddleCategory as m,dbo.PIS_Color as c, dbo.PIS_Size as size,
     dbo.PIS_GoodsLittleCategory as s, dbo.POS_EosConfig as eosc, dbo.POS_PosConfig as posc,
       (select g.code, min(ti.sdate) "首發日"
        from dbo.PIS_TransferOutNoticeDetails as td, dbo.PIS_TransferOutNoticeIndex as ti,
             dbo.pis_goods as g,dbo.PIS_Warehouse as w
        where td.TransferOutNoticeIndexSerNo = ti.SerNo
          and td.GoodsSerNo=g.SerNo
          and substring(w.code,1,3) like '0A'
        group by g.code
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
  and g.code=outdate.code
  and si.attribute<>'2'
  --and substring(g.code,1,8) in('LWE6A301','FWCABN15')
  and substring(g.code,2,2) in('WA','WB','WC','WD','WL','WP','WK','MA','MC','ML','MP','MK')
  and substring(g.code,13,1) like '0'
  and si.sdate between '20181101' and '20181130'
group by substring(si.sdate,1,4),substring(si.sdate,5,2),l.name, m.name,s.name,c.name,substring(g.code,1,10)
) k
where k.Rank <16
order by k.大分類 ,k.中分類 ,k.Rank