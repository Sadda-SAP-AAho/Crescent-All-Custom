@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'General Store Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GENSTRCOST 
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as genstrcost
}

where
       a.HeaderGrpCode = 'Z003'
  and(
       a.ChildGrpCode  = 'Z032'
    or a.ChildGrpCode  = 'Z035'
    or a.ChildGrpCode  = 'Z036'
  )

group by
  a.Plant,
  a.Hedmaterial
