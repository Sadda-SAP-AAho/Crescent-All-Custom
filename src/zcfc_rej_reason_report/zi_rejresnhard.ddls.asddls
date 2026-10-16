@AbapCatalog.sqlViewName: 'ZREJRESNHARD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Hard'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNHARD
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
      ( case when b.Rejrea1 = 'HARD' then b.Rejqty1 end ) as Total_Qty1_HARD,
      ( case when b.Rejrea2 = 'HARD' then b.Rejqty2 end ) as Total_Qty2_HARD,
      ( case when b.Rejrea3 = 'HARD' then b.Rejqty3 end ) as Total_Qty3_HARD,
      ( case when b.Rejrea4 = 'HARD' then b.Rejqty4 end ) as Total_Qty4_HARD,
      ( case when b.Rejrea5 = 'HARD' then b.Rejqty5 end ) as Total_Qty5_HARD,
      ( case when b.Rejrea6 = 'HARD' then b.Rejqty6 end ) as Total_Qty6_HARD,
      ( case when b.Rejrea7 = 'HARD' then b.Rejqty7 end ) as Total_Qty7_HARD,
      ( case when b.Rejrea8 = 'HARD' then b.Rejqty8 end ) as Total_Qty8_HARD,
      ( case when b.Rejrea9 = 'HARD' then b.Rejqty9 end ) as Total_Qty9_HARD
}
