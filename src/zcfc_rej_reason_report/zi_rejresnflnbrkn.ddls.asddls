@AbapCatalog.sqlViewName: 'ZREJRESNFLNBRKN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Flange Broken'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNFLNBRKN
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
      ( case when b.Rejrea1 = 'FLANGE BROKEN' then b.Rejqty1 end ) as Total_Qty1_FlnBrkn,
      ( case when b.Rejrea2 = 'FLANGE BROKEN' then b.Rejqty2 end ) as Total_Qty2_FlnBrkn,
      ( case when b.Rejrea3 = 'FLANGE BROKEN' then b.Rejqty3 end ) as Total_Qty3_FlnBrkn,
      ( case when b.Rejrea4 = 'FLANGE BROKEN' then b.Rejqty4 end ) as Total_Qty4_FlnBrkn,
      ( case when b.Rejrea5 = 'FLANGE BROKEN' then b.Rejqty5 end ) as Total_Qty5_FlnBrkn,
      ( case when b.Rejrea6 = 'FLANGE BROKEN' then b.Rejqty6 end ) as Total_Qty6_FlnBrkn,
      ( case when b.Rejrea7 = 'FLANGE BROKEN' then b.Rejqty7 end ) as Total_Qty7_FlnBrkn,
      ( case when b.Rejrea8 = 'FLANGE BROKEN' then b.Rejqty8 end ) as Total_Qty8_FlnBrkn,
      ( case when b.Rejrea9 = 'FLANGE BROKEN' then b.Rejqty9 end ) as Total_Qty9_FlnBrkn
}
