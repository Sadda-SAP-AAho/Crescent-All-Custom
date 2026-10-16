@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Summary Report-Casting1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOMSM_CAST_1
  as select distinct from ZR_BOMCOST_RPT   as a
    left outer join       zdt_pp_matinffld as b on a.Component = b.product
{
  key a.Plant,
  key a.Hedmaterial,
      max(b.qtyperbox)   as qtybox,
      max(b.typeofmould) as typmold
}

where
      a.HeaderGrpCode = 'Z003'
  and a.ChildGrpCode  = 'Z025'

group by
  a.Plant,
  a.Hedmaterial
