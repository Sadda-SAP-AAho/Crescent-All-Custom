@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'material and product group wise stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PLANING_RPT_V6
  as select from ZCDS_PLANING_RPT_V5 as a
    inner join   zdt_bomdet          as b on  b.hedmaterial    = a.hedmaterial
                                          and b.plant          = a.plant
                                          and (
                                             b.productgroup    = 'Z025'
                                             or b.productgroup = 'Z026'
                                             or b.productgroup = 'Z027'
                                             or b.productgroup = 'Z028'
                                           )
    inner join   ZCDS_PLANING_RPT_V2 as c on  c.Product = b.component
                                          and c.Plant   = b.plant
{
  a.hedmaterial,
  a.plant,
  b.productgroup,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  sum( c.qty ) as qty,
  c.MaterialBaseUnit
}
group by
  a.hedmaterial,
  a.plant,
  b.productgroup,
  c.MaterialBaseUnit
