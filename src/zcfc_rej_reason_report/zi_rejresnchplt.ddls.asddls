@AbapCatalog.sqlViewName: 'ZREJRESNCHPLT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Chaplet High'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNCHPLT
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
      ( case when b.Rejrea1 = 'CHAPLET HIGH' then b.Rejqty1 end ) as Total_Qty1_Chaplet,
      ( case when b.Rejrea2 = 'CHAPLET HIGH' then b.Rejqty2 end ) as Total_Qty2_Chaplet,
      ( case when b.Rejrea3 = 'CHAPLET HIGH' then b.Rejqty3 end ) as Total_Qty3_Chaplet,
      ( case when b.Rejrea4 = 'CHAPLET HIGH' then b.Rejqty4 end ) as Total_Qty4_Chaplet,
      ( case when b.Rejrea5 = 'CHAPLET HIGH' then b.Rejqty5 end ) as Total_Qty5_Chaplet,
      ( case when b.Rejrea6 = 'CHAPLET HIGH' then b.Rejqty6 end ) as Total_Qty6_Chaplet,
      ( case when b.Rejrea7 = 'CHAPLET HIGH' then b.Rejqty7 end ) as Total_Qty7_Chaplet,
      ( case when b.Rejrea8 = 'CHAPLET HIGH' then b.Rejqty8 end ) as Total_Qty8_Chaplet,
      ( case when b.Rejrea9 = 'CHAPLET HIGH' then b.Rejqty9 end ) as Total_Qty9_Chaplet
}
