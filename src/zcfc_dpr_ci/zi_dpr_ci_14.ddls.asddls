@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR CI - Labour Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_DPR_CI_14 
  as select from ZI_LABBKREGHEAD as a
inner join ZI_LABBKREGITEM as b on b.Id = a.Id
{
    a.Rptdate,
    a.Costcode as Dept,
    sum( cast( b.Amount as abap.dec( 23,2 ) ) ) as actlabexp
}
where a.Plantcode = '1100'
group by
a.Rptdate,
a.Costcode
