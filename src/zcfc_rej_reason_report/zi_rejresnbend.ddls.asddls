@AbapCatalog.sqlViewName: 'ZREJRESNBEND'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Bend'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNBEND
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
      ( case when b.Rejrea1 = 'BEND' then b.Rejqty1 end ) as Total_Qty1_Bend,
      ( case when b.Rejrea2 = 'BEND' then b.Rejqty2 end ) as Total_Qty2_Bend,
      ( case when b.Rejrea3 = 'BEND' then b.Rejqty3 end ) as Total_Qty3_Bend,
      ( case when b.Rejrea4 = 'BEND' then b.Rejqty4 end ) as Total_Qty4_Bend,
      ( case when b.Rejrea5 = 'BEND' then b.Rejqty5 end ) as Total_Qty5_Bend,
      ( case when b.Rejrea6 = 'BEND' then b.Rejqty6 end ) as Total_Qty6_Bend,
      ( case when b.Rejrea7 = 'BEND' then b.Rejqty7 end ) as Total_Qty7_Bend,
      ( case when b.Rejrea8 = 'BEND' then b.Rejqty8 end ) as Total_Qty8_Bend,
      ( case when b.Rejrea9 = 'BEND' then b.Rejqty9 end ) as Total_Qty9_Bend
}
