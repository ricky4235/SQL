select d.name, ti.sdate "調撥日期", ti.checkdate "驗收日期", g.code,substring(g.code,1,8) "款號", g.name,tout.name "出庫倉",
       td.transferoutamount "出庫數", tin.name "入庫倉", td.transferinamount "入庫數", td.remark
from dbo.PIS_TransferDetails as td, dbo.PIS_TransferIndex as ti, dbo.PIS_Goods as g,
     dbo.PIS_Document as d,
     (select distinct oti.transferoutwarehouseserno, ow.code, ow.name
      from dbo.PIS_TransferIndex as oti, dbo.PIS_Warehouse as ow
      where oti.transferoutwarehouseserno = ow.serno
      ) as tout,
     (select distinct iti.transferinwarehouseserno, iw.code, iw.name
      from dbo.PIS_TransferIndex as iti, dbo.PIS_Warehouse as iw
      where iti.transferinwarehouseserno = iw.serno
      ) as tin
where ti.serno = td.transferindexserno
  and ti.documentserno = d.serno
  and td.goodsserno = g.serno
  and ti.transferoutwarehouseserno = tout.transferoutwarehouseserno
  and ti.transferinwarehouseserno = tin.transferinwarehouseserno 
  and ti.sdate between '20180701' and '20180731' 
  and substring(g.code,1,8) like 'PWL3BA01'