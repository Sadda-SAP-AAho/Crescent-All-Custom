@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shop Floor Data-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SHPFLOORDATA_1 
  as select distinct from ZI_SHPFLRRPT as a
{
  key cast( a.Shpflrdt as abap.dats )                                         as Shpflrdt,
  key a.Plant,
  key a.Matnr,
  key concat( concat( cast( a.Shpflrdt as abap.dats ) , a.Plant ) , a.Matnr ) as comb,
      a.Maktx,
      a.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.Goodcast                                                         as Goodcastqty
}

