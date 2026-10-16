@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing Material Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PACKMTLCOST
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as packmtlcost
}

where
       a.HeaderGrpCode = 'Z003'
  and(
       a.ChildGrpCode  = 'Z008'
    or a.ChildGrpCode  = 'Z010'
    or a.ChildGrpCode  = 'Z011'
    or a.ChildGrpCode  = 'Z012'
    or a.ChildGrpCode  = 'Z013'
    or a.ChildGrpCode  = 'Z014'
    or a.ChildGrpCode  = 'Z041'
    or a.ChildGrpCode  = 'Z042'
  )

group by
  a.Plant,
  a.Hedmaterial
