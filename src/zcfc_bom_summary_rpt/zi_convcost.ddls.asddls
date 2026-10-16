@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Conversion Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CONVCOST
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as convcost
}

where
       a.HeaderGrpCode = 'Z003'
  and  a.ChildGrpCode  = 'Activity'
  and(
       a.Component     = 'GLGN06'
    or a.Component     = 'GLGN19'
    or a.Component     = 'GLGN26'
    or a.Component     = 'GLGN27'
    or a.Component     = 'GLGN28'
    or a.Component     = 'GLGN31'
    or a.Component     = 'GLGN36'
    or a.Component     = 'GLGN52'
    or a.Component     = 'LACI09'
    or a.Component     = 'LACI11'
    or a.Component     = 'LADI16'
    or a.Component     = 'LAGN03'
    or a.Component     = 'LAGN04'
    or a.Component     = 'LAMC01'
    or a.Component     = 'LAMM01'
    or a.Component     = 'LAVM06'

  )

group by
  a.Plant,
  a.Hedmaterial
