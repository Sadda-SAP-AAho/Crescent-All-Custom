@AbapCatalog.sqlViewName: 'ZREJRSNHD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason Header'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRSNHD 
  as select distinct from ZI_SHPFLRRPT as a
  inner join            I_ProductPlantBasic        as b on  a.Matnr = b.Product
                                                          and a.Plant    = b.Plant

  left outer join       I_ProfitCenterText         as c on b.ProfitCenter = c.ProfitCenter
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
  c.ProfitCenterName as Profit_Center,
  @Semantics.quantity.unitOfMeasure: 'Wtunit'
  a.Stdwt as UnitWt,
  a.Wtunit,
  
  a.Totcast,
  
  ( a.Totcast * a.Stdwt ) as Total_Cast_Wt,
  
  a.Goodcast,
  
  ( a.Goodcast * a.Stdwt ) as Total_Good_Cast_Wt,
  
  ( a.Rejqty1 + a.Rejqty2 + a.Rejqty3 + a.Rejqty4 + a.Rejqty5 +
    a.Rejqty6 + a.Rejqty7 + a.Rejqty8 + a.Rejqty9) as Total_RejQty,
    
  ( ( a.Rejqty1 + a.Rejqty2 + a.Rejqty3 + a.Rejqty4 + a.Rejqty5 +
    a.Rejqty6 + a.Rejqty7 + a.Rejqty8 + a.Rejqty9) * a.Stdwt ) as Total_Rej_Wt
  
  

}
