@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Melting Loss Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MELTLOSSCOST
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as meltlosscst
}

where
       a.HeaderGrpCode = 'Z003'
  and  a.ChildGrpCode  = 'Activity'
  and(
       a.Component     = 'GLGN04'
    or a.Component     = 'GLGN32'
    or a.Component     = 'GLMS01'
    or a.Component     = 'LAML01'
    or a.Component     = 'LAMS01'

  )

group by
  a.Plant,
  a.Hedmaterial
