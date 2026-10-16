@AbapCatalog.sqlViewName: 'ZREJRESNLDTSTFL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Load Test Fail'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNLDTSTFL
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
      ( case when b.Rejrea1 = 'LOAD TEST FAIL' then b.Rejqty1 end ) as Total_Qty1_LDTSTFL,
      ( case when b.Rejrea2 = 'LOAD TEST FAIL' then b.Rejqty2 end ) as Total_Qty2_LDTSTFL,
      ( case when b.Rejrea3 = 'LOAD TEST FAIL' then b.Rejqty3 end ) as Total_Qty3_LDTSTFL,
      ( case when b.Rejrea4 = 'LOAD TEST FAIL' then b.Rejqty4 end ) as Total_Qty4_LDTSTFL,
      ( case when b.Rejrea5 = 'LOAD TEST FAIL' then b.Rejqty5 end ) as Total_Qty5_LDTSTFL,
      ( case when b.Rejrea6 = 'LOAD TEST FAIL' then b.Rejqty6 end ) as Total_Qty6_LDTSTFL,
      ( case when b.Rejrea7 = 'LOAD TEST FAIL' then b.Rejqty7 end ) as Total_Qty7_LDTSTFL,
      ( case when b.Rejrea8 = 'LOAD TEST FAIL' then b.Rejqty8 end ) as Total_Qty8_LDTSTFL,
      ( case when b.Rejrea9 = 'LOAD TEST FAIL' then b.Rejqty9 end ) as Total_Qty9_LDTSTFL
}
