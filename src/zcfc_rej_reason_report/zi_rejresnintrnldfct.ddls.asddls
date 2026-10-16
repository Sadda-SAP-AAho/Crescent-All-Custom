@AbapCatalog.sqlViewName: 'ZREJRESNINTRDFCT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Internal Defect'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNINTRNLDFCT
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
      ( case when b.Rejrea1 = 'INTERNAL DEFECT' then b.Rejqty1 end ) as Total_Qty1_IntrnlDfct,
      ( case when b.Rejrea2 = 'INTERNAL DEFECT' then b.Rejqty2 end ) as Total_Qty2_IntrnlDfct,
      ( case when b.Rejrea3 = 'INTERNAL DEFECT' then b.Rejqty3 end ) as Total_Qty3_IntrnlDfct,
      ( case when b.Rejrea4 = 'INTERNAL DEFECT' then b.Rejqty4 end ) as Total_Qty4_IntrnlDfct,
      ( case when b.Rejrea5 = 'INTERNAL DEFECT' then b.Rejqty5 end ) as Total_Qty5_IntrnlDfct,
      ( case when b.Rejrea6 = 'INTERNAL DEFECT' then b.Rejqty6 end ) as Total_Qty6_IntrnlDfct,
      ( case when b.Rejrea7 = 'INTERNAL DEFECT' then b.Rejqty7 end ) as Total_Qty7_IntrnlDfct,
      ( case when b.Rejrea8 = 'INTERNAL DEFECT' then b.Rejqty8 end ) as Total_Qty8_IntrnlDfct,
      ( case when b.Rejrea9 = 'INTERNAL DEFECT' then b.Rejqty9 end ) as Total_Qty9_IntrnlDfct
}
