@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Summary Report-Casting'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOMSM_CAST
  as select distinct from ZR_BOMCOST_RPT   as a
    left outer join       zdt_pp_matinffld as b on a.Component = b.product
    left outer join       I_Product        as c on b.product = c.Product
{
  key a.Plant,
  key a.Hedmaterial,
      sum(b.machloss * a.Childqty)    as mcloss,
      c.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      sum(c.GrossWeight * a.Childqty) as bunchwt
}

where
      a.HeaderGrpCode = 'Z003'
  and a.ChildGrpCode  = 'Z025'

group by
  a.Plant,
  a.Hedmaterial,
  c.WeightUnit
