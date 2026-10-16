@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List wise Shortage - Cast Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PACK_CASTSTCK_1 
  as select from    zdt_bomdet          as a
    left outer join ZCDS_PLANING_RPT_V2 as b on  b.Product = a.component
                                             and b.Plant   = a.plant
    left outer join zdt_bomdet          as c on  c.hedmaterial    = a.hedmaterial
                                             and c.plant          = a.plant
                                             and c.component      = a.parent
                                             and (
                                                c.productgroup    = 'Z028'
                                                or c.productgroup = 'Z026'
                                                or c.productgroup = 'Z027'
                                              )
    left outer join ZCDS_PACK_PANTSTCK  as d on  d.hedmaterial = c.hedmaterial
                                             and d.Plant       = c.plant
                                             and d.component   = c.component
    left outer join ZCDS_PACK_MACSTCK   as e on  e.hedmaterial = c.hedmaterial
                                             and e.Plant       = c.plant
                                             and e.component   = c.component
    left outer join ZCDS_PACK_GRNDSTCK  as f on  f.hedmaterial = c.hedmaterial
                                             and f.Plant       = c.plant
                                             and f.component   = c.component
    left outer join zdt_pp_matinffld    as g on a.component = g.product
    
    left outer join I_ProductPlantBasic as h on  h.Product = a.hedmaterial
                                             and h.Plant   = a.plant
{
  a.hedmaterial,
  a.component,
  //  a.plant,
  (case when h.SpecialProcurementType = '40' then '1100'
                    else a.plant end)                       as Plant,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  b.qty,
  b.MaterialBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
  sum( coalesce( cast( d.qty as abap.dec( 13, 3 ) ), 0 )  + coalesce( cast( e.qty as abap.dec( 13, 3 ) ), 0 )
     + coalesce( cast( e.qty1 as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( f.qty as abap.dec( 13, 3 ) ), 0 )
     + coalesce( cast( f.qty1 as abap.dec( 13, 3 ) ), 0 ) ) as qty1,
  d.MaterialBaseUnit                                        as MaterialBaseUnit1,
  ( case when g.qtyperbox is not initial
                then g.qtyperbox
                else null end )                             as Cast_QtyPerBox,
  g.typeofmould                                             as Cast_TypeMould,
  g.subcode                                                 as Cast_SubCode
}
where
  a.productgroup = 'Z025'
group by
  a.hedmaterial,
  a.component,
  a.plant,
  h.SpecialProcurementType,
  b.qty,
  b.MaterialBaseUnit,
  d.MaterialBaseUnit,
  g.qtyperbox,
  g.typeofmould,
  g.subcode
