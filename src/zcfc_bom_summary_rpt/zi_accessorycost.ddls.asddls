@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Accessory Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ACCESSORYCOST
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as accscost
}

where
       a.HeaderGrpCode = 'Z003'
  and(
       a.ChildGrpCode  = 'Z030'
    or a.ChildGrpCode  = 'Z031'
    or a.ChildGrpCode  = 'Z034'
  )

group by
  a.Plant,
  a.Hedmaterial
