@AbapCatalog.sqlViewName: 'ZREJRESNDESCHNG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Design Changed'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNDESCHNG
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
      ( case when b.Rejrea1 = 'DESIGN CHANGED' then b.Rejqty1 end ) as Total_Qty1_DESCHNG,
      ( case when b.Rejrea2 = 'DESIGN CHANGED' then b.Rejqty2 end ) as Total_Qty2_DESCHNG,
      ( case when b.Rejrea3 = 'DESIGN CHANGED' then b.Rejqty3 end ) as Total_Qty3_DESCHNG,
      ( case when b.Rejrea4 = 'DESIGN CHANGED' then b.Rejqty4 end ) as Total_Qty4_DESCHNG,
      ( case when b.Rejrea5 = 'DESIGN CHANGED' then b.Rejqty5 end ) as Total_Qty5_DESCHNG,
      ( case when b.Rejrea6 = 'DESIGN CHANGED' then b.Rejqty6 end ) as Total_Qty6_DESCHNG,
      ( case when b.Rejrea7 = 'DESIGN CHANGED' then b.Rejqty7 end ) as Total_Qty7_DESCHNG,
      ( case when b.Rejrea8 = 'DESIGN CHANGED' then b.Rejqty8 end ) as Total_Qty8_DESCHNG,
      ( case when b.Rejrea9 = 'DESIGN CHANGED' then b.Rejqty9 end ) as Total_Qty9_DESCHNG
}
