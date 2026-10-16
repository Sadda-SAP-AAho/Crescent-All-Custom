@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_30

  as select from I_ProductValuationBasic
{
  key  Product,
  key  ValuationArea,
       Currency,
       cast( StandardPrice as abap.dec(15,2)) as StandardPrice
}
