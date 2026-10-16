@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for PP Casting Details 3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_pp_casting_dlts3
  as select from    zcds_pp_casting_dlts1 as a
    left outer join zcds_pp_casting_dlts2 as b on b.Shpflrno = a.Shpflrno
{
  key a.Shpflrno,
  key a.ManufacturingOrder,
  key a.ManufacturingOrderOperation_2,
  key b.MaterialDocument
 //     a.CostCtrActivityType
}
