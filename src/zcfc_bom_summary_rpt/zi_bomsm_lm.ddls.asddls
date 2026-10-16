@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Summary Report-LM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOMSM_LM
  as select distinct from ZR_BOMCOST_RPT as a

{
  key a.Plant,
  key a.Hedmaterial,
      max(a.Parent) as lmmatl
}
where
      a.HeaderGrpCode = 'Z003'
  and a.ChildGrpCode  = 'Z021'

group by
  a.Plant,
  a.Hedmaterial
