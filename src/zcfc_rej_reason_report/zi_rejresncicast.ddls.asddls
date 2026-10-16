@AbapCatalog.sqlViewName: 'ZREJRESNCICAST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-CI CAST'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNCICAST
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
      ( case when b.Rejrea1 = 'C.I. CASTINGS' then b.Rejqty1 end ) as Total_Qty1_CICast,
      ( case when b.Rejrea2 = 'C.I. CASTINGS' then b.Rejqty2 end ) as Total_Qty2_CICast,
      ( case when b.Rejrea3 = 'C.I. CASTINGS' then b.Rejqty3 end ) as Total_Qty3_CICast,
      ( case when b.Rejrea4 = 'C.I. CASTINGS' then b.Rejqty4 end ) as Total_Qty4_CICast,
      ( case when b.Rejrea5 = 'C.I. CASTINGS' then b.Rejqty5 end ) as Total_Qty5_CICast,
      ( case when b.Rejrea6 = 'C.I. CASTINGS' then b.Rejqty6 end ) as Total_Qty6_CICast,
      ( case when b.Rejrea7 = 'C.I. CASTINGS' then b.Rejqty7 end ) as Total_Qty7_CICast,
      ( case when b.Rejrea8 = 'C.I. CASTINGS' then b.Rejqty8 end ) as Total_Qty8_CICast,
      ( case when b.Rejrea9 = 'C.I. CASTINGS' then b.Rejqty9 end ) as Total_Qty9_CICast
}
