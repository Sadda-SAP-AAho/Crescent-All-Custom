@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Labour Cost(Spl. Painting)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LABOURCOSTSP
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as labrcostsp
}

where
      a.HeaderGrpCode = 'Z003'
  and a.ChildGrpCode  = 'Activity'
  and a.Component     = 'LFG020'

group by
  a.Plant,
  a.Hedmaterial
