@AbapCatalog.sqlViewName: 'ZREJRSNBASIC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason-Basic'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRSNBASIC
  as select distinct from ZI_SHPFLRRPT        as a
    inner join            I_ProductPlantBasic as b on  a.Matnr = b.Product
                                                   and a.Plant = b.Plant

    left outer join       I_ProfitCenterText  as c on b.ProfitCenter = c.ProfitCenter
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
      c.ProfitCenterName                                           as Profit_Center,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.Stdwt                                                      as UnitWt,
      a.Wtunit,
      
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.Totcast,
      a.Meins,
      
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      ( a.Totcast * a.Stdwt )                                      as Total_Cast_Wt,

      a.Goodcast,
      
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      ( a.Goodcast * a.Stdwt )                                     as Total_Good_Cast_Wt,

      @Semantics.quantity.unitOfMeasure: 'Meins'
      ( a.Rejqty1 + a.Rejqty2 + a.Rejqty3 + a.Rejqty4 + a.Rejqty5 +
        a.Rejqty6 + a.Rejqty7 + a.Rejqty8 + a.Rejqty9)             as Total_RejQty,

      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      ( ( a.Rejqty1 + a.Rejqty2 + a.Rejqty3 + a.Rejqty4 + a.Rejqty5 +
        a.Rejqty6 + a.Rejqty7 + a.Rejqty8 + a.Rejqty9) * a.Stdwt ) as Total_Rej_Wt



}

where a.Rejected = 'No'
