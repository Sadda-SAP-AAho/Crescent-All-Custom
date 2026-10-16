@AbapCatalog.sqlViewName: 'ZREJRESNCRACK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Crack'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNCRACK
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
      ( case when b.Rejrea1 like 'CRACK' then b.Rejqty1 end ) as Total_Qty1_Crack,
      ( case when b.Rejrea2 like 'CRACK' then b.Rejqty2 end ) as Total_Qty2_Crack,
      ( case when b.Rejrea3 like 'CRACK' then b.Rejqty3 end ) as Total_Qty3_Crack,
      ( case when b.Rejrea4 like 'CRACK' then b.Rejqty4 end ) as Total_Qty4_Crack,
      ( case when b.Rejrea5 like 'CRACK' then b.Rejqty5 end ) as Total_Qty5_Crack,
      ( case when b.Rejrea6 like 'CRACK' then b.Rejqty6 end ) as Total_Qty6_Crack,
      ( case when b.Rejrea7 like 'CRACK' then b.Rejqty7 end ) as Total_Qty7_Crack,
      ( case when b.Rejrea8 like 'CRACK' then b.Rejqty8 end ) as Total_Qty8_Crack,
      ( case when b.Rejrea9 like 'CRACK' then b.Rejqty9 end ) as Total_Qty9_Crack
}
