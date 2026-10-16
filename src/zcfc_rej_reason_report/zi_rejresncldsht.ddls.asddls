@AbapCatalog.sqlViewName: 'ZREJRESNCLDSHT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Cold Shut'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNCLDSHT
  as select distinct from ZI_REJRSNBASIC as a

    inner join            ZI_CONF_ITM    as b on  a.Shpflrno = b.Shpflrno
                                              and a.itemkey  = b.Item
{
  key a.Shpflrno,
  key a.itemkey,
  key a.orderkey,
      a.Shpflrdt,
      a.Plant,
      a.Dept,
      a.Deptname,
      a.Opr,
      a.Oprname,
      a.Cont,
      a.Contname,
      a.Matnr,
      a.Maktx,
      ( case when b.Rejrea1 = 'COLD SHUT/SHORT METAL/COLD METAL' then b.Rejqty1 end ) as Total_Qty1_ColdShut,
      ( case when b.Rejrea2 = 'COLD SHUT/SHORT METAL/COLD METAL' then b.Rejqty2 end ) as Total_Qty2_ColdShut,
      ( case when b.Rejrea3 = 'COLD SHUT/SHORT METAL/COLD METAL' then b.Rejqty3 end ) as Total_Qty3_ColdShut,
      ( case when b.Rejrea4 = 'COLD SHUT/SHORT METAL/COLD METAL' then b.Rejqty4 end ) as Total_Qty4_ColdShut,
      ( case when b.Rejrea5 = 'COLD SHUT/SHORT METAL/COLD METAL' then b.Rejqty5 end ) as Total_Qty5_ColdShut,
      ( case when b.Rejrea6 = 'COLD SHUT/SHORT METAL/COLD METAL' then b.Rejqty6 end ) as Total_Qty6_ColdShut,
      ( case when b.Rejrea7 = 'COLD SHUT/SHORT METAL/COLD METAL' then b.Rejqty7 end ) as Total_Qty7_ColdShut,
      ( case when b.Rejrea8 = 'COLD SHUT/SHORT METAL/COLD METAL' then b.Rejqty8 end ) as Total_Qty8_ColdShut,
      ( case when b.Rejrea9 = 'COLD SHUT/SHORT METAL/COLD METAL' then b.Rejqty9 end ) as Total_Qty9_ColdShut
}
