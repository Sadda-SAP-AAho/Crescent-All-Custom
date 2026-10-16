@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Labour Cost(Others)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LABOURCOSTOTH
  as select distinct from ZR_BOMCOST_RPT as a
{
  key a.Plant,
  key a.Hedmaterial,
      sum(coalesce(a.Amount,0)) as labrcostoth
}

where
       a.HeaderGrpCode = 'Z003'
  and  a.ChildGrpCode  = 'Activity'
  and(
       a.Component     = 'GLGN17'
    or a.Component     = 'GLGN29'
    or a.Component     = 'GLGN30'
    or a.Component     = 'GLGN35'
    or a.Component     = 'GLGN45'
    or a.Component     = 'GLGN47'
    or a.Component     = 'GLGN48'
    or a.Component     = 'GLGN49'
    or a.Component     = 'GLGN50'
    or a.Component     = 'GLGN51'
    or a.Component     = 'GLGN55'
    or a.Component     = 'GLGN56'
    or a.Component     = 'GLGN57'
    or a.Component     = 'GLGN58'
    or a.Component     = 'GLGN59'
    or a.Component     = 'LACP01'
    or a.Component     = 'LADI04'
    or a.Component     = 'LAMS03'
    or a.Component     = 'LAMS04'
    or a.Component     = 'LAMS08'
    or a.Component     = 'LAOF01'
    or a.Component     = 'LFG001'
    or a.Component     = 'LFG002'
    or a.Component     = 'LFG003'
    or a.Component     = 'LFG004'
    or a.Component     = 'LFG005'
    or a.Component     = 'LFG006'
    or a.Component     = 'LFG007'
    or a.Component     = 'LFG008'
    or a.Component     = 'LFG009'
    or a.Component     = 'LFG010'
    or a.Component     = 'LFG011'
    or a.Component     = 'LFG012'
    or a.Component     = 'LFG013'
    or a.Component     = 'LFG014'
    or a.Component     = 'LFG015'
    or a.Component     = 'LFG016'
    or a.Component     = 'LFG018'
    or a.Component     = 'LFG022'
    or a.Component     = 'LFG023'
    or a.Component     = 'LFG024'
    or a.Component     = 'LFG025'
    or a.Component     = 'LFG026'
    or a.Component     = 'LFG027'
    or a.Component     = 'LFG028'
    or a.Component     = 'LFG030'
    or a.Component     = 'LFG033'
    or a.Component     = 'LFG036'
    or a.Component     = 'LFG037'
    or a.Component     = 'LFG038'
    or a.Component     = 'LFG039'
    or a.Component     = 'LFG040'
    or a.Component     = 'LFG042'
    or a.Component     = 'LFG043'

  )

group by
  a.Plant,
  a.Hedmaterial
