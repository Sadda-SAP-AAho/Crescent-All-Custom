@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List wise Short - Machine Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PACK_MACSTCK_1
  as select from    zdt_bomdet          as a
    left outer join ZCDS_PLANING_RPT_V2 as b on  b.Product = a.component
                                             and b.Plant   = a.plant
    left outer join zdt_bomdet          as c on  c.hedmaterial = a.hedmaterial
                                             and c.plant       = a.plant
                                             and c.component   = a.parent
                                             and (
                                                c.productgroup = 'Z028'
                                              )
    left outer join ZCDS_PACK_PANTSTCK  as d on  d.hedmaterial = c.hedmaterial
                                             and d.Plant       = c.plant
                                             and d.component   = c.component

    left outer join I_ProductPlantBasic as h on  h.Product = a.hedmaterial
                                             and h.Plant   = a.plant
  //    left outer join ZCDS_PACK_GRNDSTCK  as e on  e.hedmaterial = c.hedmaterial
  //                                             and e.plant       = c.plant
  //                                             and e.component   = c.component
{
  a.hedmaterial,
  a.component,
  //  a.plant,
  (case when h.SpecialProcurementType = '40' then '1100'
                    else a.plant end) as Plant,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  b.qty,
  b.MaterialBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
  //  sum( coalesce( cast( d.qty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( e.qty as abap.dec( 13, 3 ) ), 0 )
  //     + coalesce( cast( e.qty1 as abap.dec( 13, 3 ) ), 0 ) ) as qty1,
  sum( d.qty )                        as qty1,
  d.MaterialBaseUnit                  as MaterialBaseUnit1
}
where
  a.productgroup = 'Z026'
group by
  a.hedmaterial,
  a.component,
  a.plant,
  h.SpecialProcurementType,
  b.qty,
  b.MaterialBaseUnit,
  d.MaterialBaseUnit
