@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Labour Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LABOURCOST
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as labrcost
}

where
       a.HeaderGrpCode = 'Z003'
  and  a.ChildGrpCode  = 'Activity'
  and(
       a.Component     = 'GLGN13'
    or a.Component     = 'GLGN14'
    or a.Component     = 'LAM001'
    or a.Component     = 'LAM002'
    or a.Component     = 'LAM003'
    or a.Component     = 'LAM004'
    or a.Component     = 'LAM005'
    or a.Component     = 'LAM006'
    or a.Component     = 'LAM008'
    or a.Component     = 'LAM009'
    or a.Component     = 'LAM010'
    or a.Component     = 'LAM011'
    or a.Component     = 'LAM012'
    or a.Component     = 'LAM015'

  )

group by
  a.Plant,
  a.Hedmaterial
