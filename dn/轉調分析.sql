select a.來源單號 "需求單",a.貨號,a.數量, a.品名,a.小備註,a.大備註,a.出庫倉,a.入庫倉,a.單號 "集貨單",b.出庫單號 "出庫單", c.出庫單號 "郵寄調撥單",
       substring(a.來源單號,6,4) "門市開單日",substring(a.單號,6,4) "商控開單日",substring(b.出庫單號,6,4) "門市製單日",
       substring(b.出貨單備註, charindex('回總倉',b.出貨單備註)+3,4) "回倉日",substring(c.出庫單號,6,4) "總倉寄出日",b.驗收日,c.驗收日 "郵寄驗收日",b.單況 "入庫狀況"
from 
(select substring(tod.remark,charindex('DA',tod.remark),13) "來源單號", id.name "人員",
       co.name "單位", d.name "單據種類", toi.no "單號", toi.keyindate "開單日",
       toi.crt_time "製單時間", g.code "貨號", g.name "品名", tout.出庫倉, tin.入庫倉,
       tod.transferoutamount "數量", toi.remark "大備註", tod.remark "小備註"
from dbo.PIS_TransferOutNoticeIndex as toi, dbo.PIS_TransferOutNoticeDetails as tod,
     dbo.UserID as id, dbo.PIS_Document as d, dbo.PIS_Goods as g, dbo.FAS_Corp as co,
     (select distinct oti.transferoutwarehouseserno, ow.code, ow.name "出庫倉"
      from dbo.PIS_TransferOutNoticeIndex as oti, dbo.PIS_Warehouse as ow
      where oti.transferoutwarehouseserno = ow.serno
      ) as tout,
     (select distinct iti.transferinwarehouseserno, iw.code, iw.name "入庫倉"
      from dbo.PIS_TransferOutNoticeIndex as iti, dbo.PIS_Warehouse as iw
      where iti.transferinwarehouseserno = iw.serno
      ) as tin
where toi.employeeserno = id.employeeserno
  and toi.DocumentSerNo = d.serno
  and toi.serno = tod.transferoutnoticeindexserno
  and toi.corpserno = co.serno
  and toi.transferoutwarehouseserno = tout.transferoutwarehouseserno
  and toi.transferinwarehouseserno = tin.transferinwarehouseserno
  and tod.goodsserno = g.serno
  and d.name  in('集貨通知單(商控)','總倉出貨通知單')) a
left outer join 
(select distinct toi.no "來源集貨單號", case when charindex('DA',vt.remark_d)='0' then '' else 
       substring(vt.remark_d, charindex('DA',vt.remark_d),13) end "備註需求單號", vt.No "出庫單號",
       convert(date,vt.SDate,111) "製單日", ti.crt_time "製單時間", vt.KeyInCode_h "員編",
       vt.KeyInName_h "製單人", vt.DocumentName "單據名稱", convert(date,vt.CheckDate,111) "驗收日",
       ti.mdt_time "結案時間", vt.TransferOutWarehouseName "出庫倉", vt.TransferInWarehouseName "入庫倉",
       case vt.status when '0' then '未入庫確認' when '1' then '已入庫確認' else 'other' end "單況",
       case vt.AllocateType when '0' then '調撥單' when '1' then '調撥出庫單' else 'other' end "種類",
       toi.remark "來源單備註", vt.remark_h "出貨單備註", vt.remark_d "出貨單明細備註"
from dbo.PIS_ViewTransfer as vt
 inner join dbo.PIS_TransferIndex as ti
   on vt.serno = ti.serno
 left outer join dbo.PIS_TransferOutNoticeIndex as toi
   on vt.OriginalDocumentNoSerNo_h = toi.SerNo
where substring(vt.no,1,2) = 'DH'
   and vt.DocumentName in('門市集貨出庫單','自動補貨單')) b
  on a.單號=b.來源集貨單號  
left outer join 
(select distinct toi.no "來源單號", case when charindex('DA',vt.remark_d)='0' then '' else 
       substring(vt.remark_d, charindex('DA',vt.remark_d),13) end "備註需求單號", vt.No "出庫單號",
       convert(date,vt.SDate,111) "製單日", ti.crt_time "製單時間", vt.KeyInCode_h "員編",
       vt.KeyInName_h "製單人", vt.DocumentName "單據名稱", convert(date,vt.CheckDate,111) "驗收日",
       ti.mdt_time "結案時間", vt.TransferOutWarehouseName "出庫倉", vt.TransferInWarehouseName "入庫倉",
       case vt.status when '0' then '未入庫確認' when '1' then '已入庫確認' else 'other' end "單況",
       case vt.AllocateType when '0' then '調撥單' when '1' then '調撥出庫單' else 'other' end "種類",
       toi.remark "來源單備註", vt.remark_h "出貨單備註", vt.remark_d "出貨單明細備註"
from dbo.PIS_ViewTransfer as vt
 inner join dbo.PIS_TransferIndex as ti
   on vt.serno = ti.serno
 left outer join dbo.PIS_TransferOutNoticeIndex as toi
   on vt.OriginalDocumentNoSerNo_h = toi.SerNo
where substring(vt.no,1,2) = 'DH'
   and vt.DocumentName in('郵寄調撥單')) c
  on a.來源單號=c.來源單號 
where  substring(a.單號,3,7) between '1071029' and '1071109'


----------------------------------------------------------------------------
select distinct toi.no "來源單號", case when charindex('DA',vt.remark_d)='0' then '' else 
       substring(vt.remark_d, charindex('DA',vt.remark_d),13) end "備註需求單號",vt.TransferOutAmount_d "數量" ,
       vt.DocumentName "單據名稱", vt.remark_d "小備註", vt.remark_h "大備註",
       vt.TransferOutWarehouseName "出庫倉", vt.TransferInWarehouseName "入庫倉",'' "集貨單",
       vt.No "出庫單號", '' "郵寄調撥單", '' "門市開單日", '' "商控開單日",'' "門市製單日",'' "回倉日",
       substring(vt.No,6,4) "總倉寄出日", convert(date,vt.CheckDate,111) "驗收日",'' "郵寄驗收日",        
       case vt.status when '0' then '未入庫確認' when '1' then '已入庫確認' else 'other' end "單況"
from dbo.PIS_ViewTransfer as vt
 inner join dbo.PIS_TransferIndex as ti
   on vt.serno = ti.serno
 left outer join dbo.PIS_TransferOutNoticeIndex as toi
   on vt.OriginalDocumentNoSerNo_h = toi.SerNo
where  vt.DocumentName in('自動補貨單','郵寄調撥單')
   and  substring(vt.No,3,7) between '1071015' and '1071031'
