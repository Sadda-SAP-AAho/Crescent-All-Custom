@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Labour Cost(Grinding)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LABOURCOSTGR
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as labrcostgr
}

where
       a.HeaderGrpCode = 'Z003'
  and  a.ChildGrpCode  = 'Activity'
  and(
       a.Component     = 'GLGN15'
    or a.Component     = 'GLGN09'
    or a.Component     = 'GLGN21'
    or a.Component     = 'GLGN22'
    or a.Component     = 'GLGN23'
    or a.Component     = 'GLGN24'
    or a.Component     = 'GLGN25'
    or a.Component     = 'GLGN34'
    or a.Component     = 'GLGN38'
    or a.Component     = 'LADI05'
    or a.Component     = 'LADI06'
    or a.Component     = 'LADI07'
    or a.Component     = 'LAGN01'
    or a.Component     = 'LAGN02'
  )

group by
  a.Plant,
  a.Hedmaterial
