@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Electricity Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ELECCOST
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as eleccost
}

where
       a.HeaderGrpCode = 'Z003'
  and  a.ChildGrpCode  = 'Activity'
  and(
       a.Component     = 'GLDI01'
    or a.Component     = 'GLGN01'
    or a.Component     = 'GLGN02'
    or a.Component     = 'GLGN03'
    or a.Component     = 'GLGN18'
    or a.Component     = 'LACI02'
    or a.Component     = 'LADI02'
    or a.Component     = 'LADI11'
    or a.Component     = 'LADI18'
    or a.Component     = 'LADI19'
    or a.Component     = 'LAMS02'
    or a.Component     = 'LAVM02'
    or a.Component     = 'LAVM08'

  )

group by
  a.Plant,
  a.Hedmaterial
