@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for PP Casting Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_pp_casting_dlts1
  as select distinct from I_ManufacturingOrderOperation as a
    inner join            ZI_CONF_ORD                   as b on b.Prodord = a.ManufacturingOrder
//    left outer join       zcds_pp_component_dlts        as c on  c.Prodord                     = a.ManufacturingOrder
//                                                             and c.ManufacturingOrderOperation = a.ManufacturingOrderOperation_2
{
  key a.ManufacturingOrder,
  key a.ManufacturingOrderOperation_2,
  key b.Shpflrno
//      c.CostCtrActivityType

}
group by
  a.ManufacturingOrder,
  a.ManufacturingOrderOperation_2,
  b.Shpflrno
//  c.CostCtrActivityType
