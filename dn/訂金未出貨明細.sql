select distinct a.開訂日,a.店號,a.門市,a.貨號,a.品名,a.開訂時間,a.會員名稱,a.備註,a.未取量,a.庫存,a.在途,b.數量 "通知量",b.單據種類,b.單號,b.單據小備註,b.單據大備註,
                case when a.未取量>a.庫存 then  '>' when a.未取量=a.庫存  then '=' when (a.未取量<a.庫存 and a.備註 is not null) then '有備註' else '' end "訂存" ,
                case when a.未取量=b.數量 then  '=' else '' end "訂通" ,                
                '$'+substring(a.開訂日,5,4)+substring(a.門市,1,2)+'訂金'+'-'+isnull(a.會員名稱,'')+'，'+isnull(a.備註,'') "開單備註"               
from
(select i.sdate "開訂日",g.code "貨號",g.name "品名", posc.name "門市", posc.code "店號",i.sdate+posc.name+g.code "日門市貨號",
  d.taxedsaleprice "售價", d.amount "訂金量", d.OrderTakeQty "已取量",i.CRT_TIME "開訂時間",m.name "會員名稱",
  d.amount-d.OrderTakeQty "未取量", i.Remark "備註" , voi.LastAmount "庫存",voi.TransNotInAmount "在途"
from dbo.POS_SaleIndex as i
left outer join dbo.POS_Member as m
on i.MemberSerNo = m.serno
    ,dbo.POS_SaleDetails as d, dbo.PIS_Goods as g,
     dbo.POS_EosConfig as eosc, dbo.POS_PosConfig as posc,
     dbo.PIS_ViewInitialWarehouseAmountIncludeTransferAmount as voi
where i.SerNo = d.saleindexSerNo
  and g.SerNo = d.goodsserno
  and i.cashregisterserno=eosc.serno
  and eosc.SalePointSerNo=posc.SerNo
  and g.SerNo = voi.GoodsSerNo
  and posc.WarehouseSerNo = voi.WarehouseSerNo
  and i.attribute='1'
  and d.amount-d.OrderTakeQty > 0 
  and (d.amount-d.OrderTakeQty>=voi.LastAmount or i.Remark is not null)
  and g.code <> 'Z002') a
left outer join 
(select id.name "人員", co.name "單位", d.name "單據種類", toi.no "單號",toi.keyindate+co.name+g.code "日門市貨號",
       toi.keyindate "開單日", g.code "貨號", g.name "品名", tin.入庫倉,
       tod.transferoutamount "數量",tod.Remark "單據小備註",toi.Remark "單據大備註"
from dbo.PIS_TransferOutNoticeIndex as toi, dbo.PIS_TransferOutNoticeDetails as tod,
     dbo.UserID as id, dbo.PIS_Document as d, dbo.PIS_Goods as g, dbo.FAS_Corp as co,
     (select distinct iti.transferinwarehouseserno, iw.code, iw.name "入庫倉"
      from dbo.PIS_TransferOutNoticeIndex as iti, dbo.PIS_Warehouse as iw
      where iti.transferinwarehouseserno = iw.serno
      ) as tin
where toi.employeeserno = id.employeeserno
  and toi.DocumentSerNo = d.serno
  and toi.serno = tod.transferoutnoticeindexserno
  and toi.corpserno = co.serno
  and toi.transferinwarehouseserno = tin.transferinwarehouseserno 
  and tod.goodsserno = g.serno
  and d.name in('門市商品需求單','門市郵寄通知單') ) b
on a.日門市貨號 = b.日門市貨號
where  a.開訂日 between '20190118' and '20190118'
order by a.開訂時間
 