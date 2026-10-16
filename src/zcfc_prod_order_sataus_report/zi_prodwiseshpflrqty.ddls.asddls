@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Prod Order wise Shop Floor Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRODWISESHPFLRQTY
  as select distinct from ZI_CONF_ORD as a
    inner join            ZI_CONF_HDR as b on a.Id = b.Id
{
  key a.Prodord,
      a.Plant,
      a.Matnr,
      a.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      sum(a.Pendprqty) as ShopFlrQty
}

where
  b.Shpflrdt >= '20260401'

group by
  a.Prodord,
  a.Plant,
  a.Matnr,
  a.Meins
