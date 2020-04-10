select id.name "人員", co.name "單位", d.name "單據種類", toi.sdate "生效日", toi.no "單號",
       toi.keyindate "開單日", tout.name "出庫門市", tod.transferoutamount "出庫數",
       tin.name "入庫門市", tod.transferinamount "入庫數", g.name,  toi.remark "備註"
from dbo.PIS_TransferOutNoticeIndex as toi, dbo.PIS_TransferOutNoticeDetails as tod,
     dbo.UserID as id, dbo.PIS_Document as d, dbo.PIS_Goods as g, dbo.FAS_Corp as co,
     (select distinct oti.transferoutwarehouseserno, ow.code, ow.name
      from dbo.PIS_TransferIndex as oti, dbo.PIS_Warehouse as ow
      where oti.transferoutwarehouseserno = ow.serno
      ) as tout,
     (select distinct iti.transferinwarehouseserno, iw.code, iw.name
      from dbo.PIS_TransferIndex as iti, dbo.PIS_Warehouse as iw
      where iti.transferinwarehouseserno = iw.serno
      ) as tin
where toi.employeeserno = id.employeeserno
  and toi.DocumentSerNo = d.serno
  and toi.serno = tod.transferoutnoticeindexserno
  and toi.corpserno = co.serno
  and toi.transferoutwarehouseserno = tout.transferoutwarehouseserno
  and toi.transferinwarehouseserno = tin.transferinwarehouseserno 
  and tod.goodsserno = g.serno
  and toi.sdate > '20180707'
  --and g.code='MFAA0001'
  --and tin.code='0AC0011'
order by toi.no