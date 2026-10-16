@AbapCatalog.sqlViewName: 'ZREJRESNINSSHFT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Insert Shifting'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNINSSHFT
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
      ( case when b.Rejrea1 = 'DUE TO INSERT SHIFTING' then b.Rejqty1 end ) as Total_Qty1_InsShft,
      ( case when b.Rejrea2 = 'DUE TO INSERT SHIFTING' then b.Rejqty2 end ) as Total_Qty2_InsShft,
      ( case when b.Rejrea3 = 'DUE TO INSERT SHIFTING' then b.Rejqty3 end ) as Total_Qty3_InsShft,
      ( case when b.Rejrea4 = 'DUE TO INSERT SHIFTING' then b.Rejqty4 end ) as Total_Qty4_InsShft,
      ( case when b.Rejrea5 = 'DUE TO INSERT SHIFTING' then b.Rejqty5 end ) as Total_Qty5_InsShft,
      ( case when b.Rejrea6 = 'DUE TO INSERT SHIFTING' then b.Rejqty6 end ) as Total_Qty6_InsShft,
      ( case when b.Rejrea7 = 'DUE TO INSERT SHIFTING' then b.Rejqty7 end ) as Total_Qty7_InsShft,
      ( case when b.Rejrea8 = 'DUE TO INSERT SHIFTING' then b.Rejqty8 end ) as Total_Qty8_InsShft,
      ( case when b.Rejrea9 = 'DUE TO INSERT SHIFTING' then b.Rejqty9 end ) as Total_Qty9_InsShft
}
