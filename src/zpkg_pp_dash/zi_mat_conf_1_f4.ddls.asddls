@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MAT_CONF_1_F4 
as select from ZI_MAT_CONF_F4 as a
left outer join ZI_MAT_TOT as b on b.Product = a.Product and b.ProductionPlant = a.plant1
left outer join zdt_opr_mgrp_tmg as c on c.matkl = a.Productgroup
{
    key a.Plant,
    key c.zopn as Zopn,
    key a.Product,
    key a.Productname,
//    @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
    key cast( b.OpenYieldQuantity as abap.dec( 13, 3 ) ) as OpenYieldQuantity,
    key b.ProductionUnit
}
//group by
//a.Plant,
//a.Product,
//a.Productname,
//b.OpenYieldQuantity,
//b.ProductionUnit
