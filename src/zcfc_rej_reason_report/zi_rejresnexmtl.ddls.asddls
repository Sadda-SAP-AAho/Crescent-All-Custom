@AbapCatalog.sqlViewName: 'ZREJRESNEXMTL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Extra Metal/Fins'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNEXMTL
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
      ( case when b.Rejrea1 = 'EXTRA METAL/FINS' then b.Rejqty1 end ) as Total_Qty1_EXMTL,
      ( case when b.Rejrea2 = 'EXTRA METAL/FINS' then b.Rejqty2 end ) as Total_Qty2_EXMTL,
      ( case when b.Rejrea3 = 'EXTRA METAL/FINS' then b.Rejqty3 end ) as Total_Qty3_EXMTL,
      ( case when b.Rejrea4 = 'EXTRA METAL/FINS' then b.Rejqty4 end ) as Total_Qty4_EXMTL,
      ( case when b.Rejrea5 = 'EXTRA METAL/FINS' then b.Rejqty5 end ) as Total_Qty5_EXMTL,
      ( case when b.Rejrea6 = 'EXTRA METAL/FINS' then b.Rejqty6 end ) as Total_Qty6_EXMTL,
      ( case when b.Rejrea7 = 'EXTRA METAL/FINS' then b.Rejqty7 end ) as Total_Qty7_EXMTL,
      ( case when b.Rejrea8 = 'EXTRA METAL/FINS' then b.Rejqty8 end ) as Total_Qty8_EXMTL,
      ( case when b.Rejrea9 = 'EXTRA METAL/FINS' then b.Rejqty9 end ) as Total_Qty9_EXMTL
}
