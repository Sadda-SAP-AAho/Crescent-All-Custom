@AbapCatalog.sqlViewName: 'ZREJRESNBLOW'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Blow'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNBLOW
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
      ( case when b.Rejrea1 = 'BLOW HOLES/GAS HOLE/HOLE PROBLEM' then b.Rejqty1 end ) as Total_Qty1_Blow,
      ( case when b.Rejrea2 = 'BLOW HOLES/GAS HOLE/HOLE PROBLEM' then b.Rejqty2 end ) as Total_Qty2_Blow,
      ( case when b.Rejrea3 = 'BLOW HOLES/GAS HOLE/HOLE PROBLEM' then b.Rejqty3 end ) as Total_Qty3_Blow,
      ( case when b.Rejrea4 = 'BLOW HOLES/GAS HOLE/HOLE PROBLEM' then b.Rejqty4 end ) as Total_Qty4_Blow,
      ( case when b.Rejrea5 = 'BLOW HOLES/GAS HOLE/HOLE PROBLEM' then b.Rejqty5 end ) as Total_Qty5_Blow,
      ( case when b.Rejrea6 = 'BLOW HOLES/GAS HOLE/HOLE PROBLEM' then b.Rejqty6 end ) as Total_Qty6_Blow,
      ( case when b.Rejrea7 = 'BLOW HOLES/GAS HOLE/HOLE PROBLEM' then b.Rejqty7 end ) as Total_Qty7_Blow,
      ( case when b.Rejrea8 = 'BLOW HOLES/GAS HOLE/HOLE PROBLEM' then b.Rejqty8 end ) as Total_Qty8_Blow,
      ( case when b.Rejrea9 = 'BLOW HOLES/GAS HOLE/HOLE PROBLEM' then b.Rejqty9 end ) as Total_Qty9_Blow
}
