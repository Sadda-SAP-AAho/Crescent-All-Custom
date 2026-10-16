@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_31

  as select from I_Product as a

{

  a.Product,
  a.WeightUnit,
  cast( a.NetWeight as abap.dec(15,2) ) as NetWeight

}
