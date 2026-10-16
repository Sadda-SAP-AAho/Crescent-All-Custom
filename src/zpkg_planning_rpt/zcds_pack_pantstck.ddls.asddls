@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List wise Shortage - Paint Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PACK_PANTSTCK
  as select from    zdt_bomdet          as a
    inner join      ZCDS_PLANING_RPT_V2 as b on  b.Product = a.component
                                             and b.Plant   = a.plant
    left outer join I_ProductPlantBasic as h on  h.Product = a.hedmaterial
                                             and h.Plant   = a.plant
{
  a.hedmaterial,
  a.component,
  //  a.plant,
  (case when h.SpecialProcurementType = '40' then '1100'
                    else a.plant end) as Plant,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  b.qty,
  b.MaterialBaseUnit
}
where
  a.productgroup = 'Z028'


//as select from    zdt_bomdet          as a
//    left outer join ZCDS_PLANING_RPT_V2 as b on  b.Product = a.component
//                                             and b.Plant = a.plant
//    left outer join zdt_bomdet          as c on  c.hedmaterial  = a.hedmaterial
//                                             and c.plant        = a.plant
//                                             and c.parent       = a.component
//                                             and ( c.productgroup = 'Z025' or c.productgroup = 'Z027' or c.productgroup = 'Z026' )
//    left outer join ZCDS_PACK_CASTSTCK  as d on  d.hedmaterial = c.hedmaterial
//                                             and d.plant       = c.plant
//                                             and d.component   = c.component
//    left outer join ZCDS_PACK_GRNDSTCK  as e on  e.hedmaterial = c.hedmaterial
//                                             and e.plant       = c.plant
//                                             and e.component   = c.component
//    left outer join ZCDS_PACK_MACSTCK  as f  on  f.hedmaterial = c.hedmaterial
//                                             and f.plant       = c.plant
//                                             and f.component   = c.component
//{
//  a.hedmaterial,
//  a.component,
//  a.plant,
//  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//  b.qty,
//  b.MaterialBaseUnit,
//  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
//  sum( coalesce( cast( d.qty as abap.dec( 13, 3 ) ), 0 )  + coalesce( cast( e.qty as abap.dec( 13, 3 ) ), 0 )
//     + coalesce( cast( e.qty1 as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( f.qty as abap.dec( 13, 3 ) ), 0 )
//     + coalesce( cast( f.qty1 as abap.dec( 13, 3 ) ), 0 ) ) as qty1,
//  d.MaterialBaseUnit as MaterialBaseUnit1
//}
//where
//  a.productgroup = 'Z028'
//group by
//  a.hedmaterial,
//  a.component,
//  a.plant,
//  b.qty,
//  b.MaterialBaseUnit,
//  d.MaterialBaseUnit
