@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for BOM Subsequent Material - Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PACK_MAT_DET_S
  as select from    ZCDS_PACK_MAT_DET   as a
    left outer join ZCDS_PLANING_RPT_V2 as b on  b.Product = a.component
                                             and b.Plant   = a.plant
    left outer join ZCDS_PLANING_RPT_V2 as c on  c.Product = a.matZ027
                                             and c.Plant   = a.plant
    left outer join ZCDS_PLANING_RPT_V2 as d on  d.Product = a.matZ026
                                             and d.Plant   = a.plant
    left outer join ZCDS_PLANING_RPT_V2 as e on  e.Product = a.matZ028
                                             and e.Plant   = a.plant
    left outer join I_ProductPlantBasic as h on  h.Product = a.hedmaterial
                                             and h.Plant   = a.plant
{
      //    key a.plant,
  key (case when h.SpecialProcurementType = '40' then '1100'
                  else a.plant end) as Plant,
  key a.hedmaterial,
      a.component                   as matz025,
      @Semantics.quantity.unitOfMeasure: 'Unit1'
      b.qty                         as casting,
      b.MaterialBaseUnit            as unit1,
      a.matZ027,
      @Semantics.quantity.unitOfMeasure: 'Unit2'
      c.qty                         as grind,
      c.MaterialBaseUnit            as unit2,
      a.matZ026,
      @Semantics.quantity.unitOfMeasure: 'Unit3'
      d.qty                         as mach,
      d.MaterialBaseUnit            as unit3,
      a.matZ028,
      @Semantics.quantity.unitOfMeasure: 'Unit4'
      e.qty                         as paint,
      e.MaterialBaseUnit            as unit4
}
