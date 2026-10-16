@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shop Floor Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SHPFLOORDATA
  as select distinct from ZI_SHPFLOORDATA_1 as a
{
  key a.Shpflrdt,
  key a.Plant,
  key a.Matnr,
  key a.comb,
      a.Maktx,
      a.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      sum(a.Goodcastqty) as Goodcastqty
}

group by
  a.Shpflrdt,
  a.Plant,
  a.Matnr,
  a.comb,
  a.Maktx,
  a.Meins
