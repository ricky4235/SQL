select posc.code "發卡店代", posc.name "發卡店櫃", m.code "會員代號", m.name "會員名稱", m.membercardno "卡號",
       m.firstdate "發卡日",m.Birthday "生日",year(getdate())-left(m.Birthday,4) "年齡" , m.HomeTel "市話" ,m.CellPhone "手機" ,m.HomeAddress "地址",m.OfficeAddress "公司地址",
       case m.sex   when '0' then '女' when '1' then '男' when '2' then '公司' else '未填' end "性別",
       case m.Married when  '0' then '未婚' when '1' then '已婚' when '2' then '已婚單身' when '3' then '無' end "婚姻",
       m.TotalConsume "累積消費金額",m.LastConsume "前次消費金額", m.LatestConsumeDate "前次消費日" ,m.E_Mail,
       case m.ReceiveTel when '0' then '否' when '1' then '是' end "接收電話",
       case m.ReceiveShortMessage when '0' then '否' when '1' then '是' end "接收簡訊",
       case m.ReceiveDM when '0' then '否' when '1' then '是' end "接收DM",
       case m.ReceiveEmail when '0' then '否' when '1' then '是' end "接收Email",
       case m.ReceiveShare when '0' then '否' when '1' then '是' end "接收同業分享",
       m.LastModifyReason "最後修改原因",m.Remark "備註"
from dbo.POS_Member as m, dbo.POS_PosConfig as posc
where m.salepointserno = posc.SerNo
  and m.ReceiveShortMessage like '1'
  and left(m.membercardno,2) like '09'
  and len(m.membercardno) like '10'
  --and m.code like 'N%'
  --and m.firstdate>'20160714'
  --and m.name like '%※%'