@AbapCatalog.sqlViewName: 'ZREJRESNFLTPRBLM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Flatness Problem'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRESNFLTPRBLM
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
      ( case when b.Rejrea1 = 'DUE TO FLATNESS PROBLEM' then b.Rejqty1 end ) as Total_Qty1_FLTPRBLM,
      ( case when b.Rejrea2 = 'DUE TO FLATNESS PROBLEM' then b.Rejqty2 end ) as Total_Qty2_FLTPRBLM,
      ( case when b.Rejrea3 = 'DUE TO FLATNESS PROBLEM' then b.Rejqty3 end ) as Total_Qty3_FLTPRBLM,
      ( case when b.Rejrea4 = 'DUE TO FLATNESS PROBLEM' then b.Rejqty4 end ) as Total_Qty4_FLTPRBLM,
      ( case when b.Rejrea5 = 'DUE TO FLATNESS PROBLEM' then b.Rejqty5 end ) as Total_Qty5_FLTPRBLM,
      ( case when b.Rejrea6 = 'DUE TO FLATNESS PROBLEM' then b.Rejqty6 end ) as Total_Qty6_FLTPRBLM,
      ( case when b.Rejrea7 = 'DUE TO FLATNESS PROBLEM' then b.Rejqty7 end ) as Total_Qty7_FLTPRBLM,
      ( case when b.Rejrea8 = 'DUE TO FLATNESS PROBLEM' then b.Rejqty8 end ) as Total_Qty8_FLTPRBLM,
      ( case when b.Rejrea9 = 'DUE TO FLATNESS PROBLEM' then b.Rejqty9 end ) as Total_Qty9_FLTPRBLM
}
