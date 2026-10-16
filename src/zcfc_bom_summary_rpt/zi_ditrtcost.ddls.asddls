@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DI Treatment Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DITRTCOST
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as ditrtcost
}

where
       a.HeaderGrpCode = 'Z003'
  and  a.ChildGrpCode  = 'Activity'
  and(
       a.Component     = 'GLDI02'
    or a.Component     = 'GLDI03'
    or a.Component     = 'GLDI05'
    or a.Component     = 'GLDI06'
    or a.Component     = 'GLDI07'
    or a.Component     = 'GLGN41'
    or a.Component     = 'GLGN43'
    or a.Component     = 'GLGN53'
    or a.Component     = 'GLGN54'
    or a.Component     = 'LACT01'
  )

group by
  a.Plant,
  a.Hedmaterial
