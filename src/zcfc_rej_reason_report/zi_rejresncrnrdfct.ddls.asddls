@AbapCatalog.sqlViewName: 'ZREJRESNCRNRDFCT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Corner Defect'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNCRNRDFCT
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
      ( case when b.Rejrea1 like 'CORNER DEFECT' then b.Rejqty1 end ) as Total_Qty1_CrnrDfct,
      ( case when b.Rejrea2 like 'CORNER DEFECT' then b.Rejqty2 end ) as Total_Qty2_CrnrDfct,
      ( case when b.Rejrea3 like 'CORNER DEFECT' then b.Rejqty3 end ) as Total_Qty3_CrnrDfct,
      ( case when b.Rejrea4 like 'CORNER DEFECT' then b.Rejqty4 end ) as Total_Qty4_CrnrDfct,
      ( case when b.Rejrea5 like 'CORNER DEFECT' then b.Rejqty5 end ) as Total_Qty5_CrnrDfct,
      ( case when b.Rejrea6 like 'CORNER DEFECT' then b.Rejqty6 end ) as Total_Qty6_CrnrDfct,
      ( case when b.Rejrea7 like 'CORNER DEFECT' then b.Rejqty7 end ) as Total_Qty7_CrnrDfct,
      ( case when b.Rejrea8 like 'CORNER DEFECT' then b.Rejqty8 end ) as Total_Qty8_CrnrDfct,
      ( case when b.Rejrea9 like 'CORNER DEFECT' then b.Rejqty9 end ) as Total_Qty9_CrnrDfct
}
