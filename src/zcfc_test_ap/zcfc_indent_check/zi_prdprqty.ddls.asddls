@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Purchase Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PRDPRQTY
  as select distinct from ZI_MNTRPRITM as a


{
  key a.Material,
  key a.Plant,
      //     sum( cast( a.RequestedQuantity as abap.dec(12,2) ) ) as pr_qty
      sum (cast(a.RequestedQuantity as abap.dec(12,2) ) ) as pr_qty


}
group by
  Material,
  Plant
