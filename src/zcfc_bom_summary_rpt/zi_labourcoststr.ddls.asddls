@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Labour Cost(Stores)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LABOURCOSTSTR
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as labrcoststr
}

where
       a.HeaderGrpCode = 'Z003'
  and  a.ChildGrpCode  = 'Activity'
  and(
       a.Component     = 'GLGN10'
    or a.Component     = 'GLGN07'
    or a.Component     = 'GLGN08'
    or a.Component     = 'GLGN12'
    or a.Component     = 'GLGN16'
    or a.Component     = 'LACI07'
    or a.Component     = 'LAMS07'
    or a.Component     = 'LAST01'
    or a.Component     = 'LAVM03'

  )

group by
  a.Plant,
  a.Hedmaterial
