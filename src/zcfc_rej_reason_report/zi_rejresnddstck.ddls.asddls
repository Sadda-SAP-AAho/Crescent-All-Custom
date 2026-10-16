@AbapCatalog.sqlViewName: 'ZREJRESNDDSTCK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Dead Stock'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNDDSTCK
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
      ( case when b.Rejrea1 = 'DEAD STOCK' then b.Rejqty1 end ) as Total_Qty1_DDSTCK,
      ( case when b.Rejrea2 = 'DEAD STOCK' then b.Rejqty2 end ) as Total_Qty2_DDSTCK,
      ( case when b.Rejrea3 = 'DEAD STOCK' then b.Rejqty3 end ) as Total_Qty3_DDSTCK,
      ( case when b.Rejrea4 = 'DEAD STOCK' then b.Rejqty4 end ) as Total_Qty4_DDSTCK,
      ( case when b.Rejrea5 = 'DEAD STOCK' then b.Rejqty5 end ) as Total_Qty5_DDSTCK,
      ( case when b.Rejrea6 = 'DEAD STOCK' then b.Rejqty6 end ) as Total_Qty6_DDSTCK,
      ( case when b.Rejrea7 = 'DEAD STOCK' then b.Rejqty7 end ) as Total_Qty7_DDSTCK,
      ( case when b.Rejrea8 = 'DEAD STOCK' then b.Rejqty8 end ) as Total_Qty8_DDSTCK,
      ( case when b.Rejrea9 = 'DEAD STOCK' then b.Rejqty9 end ) as Total_Qty9_DDSTCK
}
